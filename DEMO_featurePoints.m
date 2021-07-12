wfdb2mat('mimic2wdb/31/3100038/3100038_0022',[2,4,7],1000,500);%1500000可以，15
[tm,signal,Fs,siginfo]=rdmat('3100038_0022m');
feature_mat=[];

signal=(signal)';
tm = tm(:,~isnan(signal(1,:)));%% remove NaNs from signals
signal = signal(:,~isnan(signal(1,:)));
tm = tm(:,~isnan(signal(2,:)));
signal = signal(:,~isnan(signal(2,:)));
tm = tm(:,~isnan(signal(3,:)));
signal = signal(:,~isnan(signal(3,:)));

ppg_signal=signal(1,:);
ecg_signal=signal(2,:);
abp_signal=signal(3,:);
%percent=detect_NaN(ecg_signal)

% ppg_signal=normalize_signal(ppg_signal);
% ppg_signal=filter_signal(ppg_signal);
% [ppg_foot, systolic, notch, dicrotic]=BP_annotate(ppg_signal,125,1,[],1);
r_loc=detect_rpeak(ecg_signal,siginfo(2).Gain);
plot(tm,ecg_signal);
hold on;
plot(tm(r_loc),ecg_signal(r_loc),'ro');

% ppg_signal_d=diff(ppg_signal);
% 
% 
% [ppg_foot, systolic, notch, dicrotic]=BP_annotate(ppg_signal,125,1,[],0);
% 
% 
% % plot(tm,ppg_signal);
% % hold on;
% % plot(tm(1:end-1),ppg_signal_d);
% % hold on;
% % plot(tm(loc),ppg_signal_d(loc),'ro');
% % 
% r_loc=detect_rpeak(ecg_signal,siginfo(2).Gain);
% new_feature_mat=generate_features(2102049,ppg_signal,ppg_signal_d,abp_signal,ppg_foot,systolic,notch,r_loc);
% % plot(tm,ecg_signal);
% % hold on;
% % plot(tm(r_loc),ecg_signal(r_loc),'ro');
% 
% %feature_mat=generate_features(3102037,ppg_signal,abp_signal,ppg_foot,systolic,notch,r_loc);


