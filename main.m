%%%%在数据集文件夹路径下运行！！！
path='/Users/jni/Documents/MATLAB/test/dataset_1h';
dataset=dir(path);
feature_mat=[];  
for i=4:2:numel(dataset)
    record_mat=dataset(i).name(1:end-4);
    patient_id=str2num(dataset(i).name(1:end-10));
    [tm,signal,Fs,siginfo]=rdmat(record_mat);
    disp(['------------Processing ',record_mat,'--------------']);
    
    signal=(signal)';
    signal = signal(:,~isnan(signal(1,:)));%% remove NaNs from signals
    signal = signal(:,~isnan(signal(2,:)));
    signal = signal(:,~isnan(signal(3,:)));% if needed，tm值要相应变化
    ppg_signal=signal(1,:);
    ecg_signal=signal(2,:);
    abp_signal=signal(3,:);
    
    ppg_signal=normalize_signal(ppg_signal);%normalization
    ppg_signal=filter_signal(ppg_signal);%butterworth filter 0.5/50
    ppg_signal_d=diff(ppg_signal);
    [ppg_foot, systolic, notch, dicrotic]=BP_annotate(ppg_signal,125,0);%ppg特征点提取 %1-画图 %resample:200
    
    r_loc=detect_rpeak(ecg_signal,siginfo(2).Gain);%ecg特征点提取
    
    new_feature_mat=generate_features(patient_id,ppg_signal,ppg_signal_d,abp_signal,ppg_foot,systolic,notch,r_loc);
    feature_mat=[feature_mat;new_feature_mat];
end

% SBP=feature_mat(:,21);
% histogram(SBP);
%writematrix(feature_mat,'data_20p_1h.csv');


% wfdb2mat('mimic2wdb/31/3100038/3100038_0021',[2,4,6],1375);
% [tm,signal,Fs,siginfo]=rdmat('3100038_0021m');














