path='/Users/jni/Documents/MATLAB/test/dataset_1h_20p';
dataset=dir(path);
feature_mat=[];  
sec=5*60*125; %%%五分钟
for i=4:2:numel(dataset)
    record_mat=dataset(i).name(1:end-4);
    patient_id=str2num(dataset(i).name(1:end-10));
    [tm,SIGNAL,Fs,siginfo]=rdmat(record_mat);
    disp(['------------Processing ',record_mat,'--------------']);
    SIGNAL=(SIGNAL)';
    for n = 1 : ceil(length(SIGNAL)/sec)
        signal=SIGNAL(:,(n-1)*sec+1 : min(n*sec,length(SIGNAL)));
        signal = signal(:,~isnan(signal(1,:)));%% remove NaNs from signals
        signal = signal(:,~isnan(signal(2,:)));
        signal = signal(:,~isnan(signal(3,:)));% if needed，tm值要相应变化
        ppg_signal=signal(1,:);
        ecg_signal=signal(2,:);
        abp_signal=signal(3,:);

        ppg_signal=normalize_signal(ppg_signal);%normalization
        ppg_signal=filter_signal(ppg_signal);%butterworth filter 0.5/50
        ppg_signal_d=diff(ppg_signal);
        [ppg_foot, systolic, notch, dicrotic]=BP_annotate(ppg_signal,125,1,[],1);%ppg特征点提取 %1-画图 %resample:200
        
        prompt='GOOD SIGNAL?';
        answer=input(prompt);
        close;
        if answer == 1 
        ppg_signal_d=diff(ppg_signal);
        r_loc=detect_rpeak(ecg_signal,siginfo(2).Gain);%ecg特征点提取
        new_feature_mat=generate_features(patient_id,ppg_signal,ppg_signal_d,abp_signal,ppg_foot,systolic,notch,r_loc);
        feature_mat=[feature_mat;new_feature_mat];
        
        elseif answer == 2
            continue
        else
            error('exit');
        end 
        
    end
end

% SBP=feature_mat(:,21);
% histogram(SBP);
writematrix(feature_mat,'data_20p_1h.csv');



% path='/Users/jni/Documents/MATLAB/test/dataset_1h';
% dataset=dir(path);
% i=8;% +2every time
% sec=1*60*125;
% record_mat=dataset(i).name(1:end-4);
% [tm,signal,Fs,siginfo]=rdmat(record_mat);
% disp(['------------Checking ',record_mat,'--------------']);
% signal=(signal)';
% tm = tm(:,~isnan(signal(1,:)));%% remove NaNs from signals
% signal = signal(:,~isnan(signal(1,:)));
% tm = tm(:,~isnan(signal(2,:)));
% signal = signal(:,~isnan(signal(2,:)));
% tm = tm(:,~isnan(signal(3,:)));
% signal = signal(:,~isnan(signal(3,:)));
% 
% for n = 1 : ceil(length(signal)/sec)
%     signal_section=signal(:,(n-1)*sec+1 : min(n*sec,length(signal)));
%     ppg_signal=signal_section(1,:);
%     ecg_signal=signal_section(2,:);
%     abp_signal=signal_section(3,:);
%     ppg_signal=normalize_signal(ppg_signal);%normalization
%     ppg_signal=filter_signal(ppg_signal);%butterworth filter 0.5/50
%     [ppg_foot, systolic, notch, dicrotic]=BP_annotate(ppg_signal,125,1);
% end