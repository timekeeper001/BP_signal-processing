wfdb2mat('mimic2wdb/31/3100038/3100038_0045',[5],2500);
[tm,signal,Fs,siginfo]=rdmat('3100038_0045m');
signal=signal';
r_loc=detect_rpeak(signal,siginfo(1).Gain);
% signaltr=signal/siginfo(1).Gain;
% wt=modwt(signaltr,4,'sym4');
% wtrec=zeros(size(wt));
% wtrec(3:4,:)=wt(3:4,:);
% y=imodwt(wtrec,'sym4');
% % plot(tm,y);
% avg=mean(y.^2);
% [peak,loc]=findpeaks(y,'MINPEAKHEIGHT',8*avg,'MINPEAKDISTANCE',50);
% for i = 1:length(loc)
%     signal_section=signal(1,(loc(i)-5):(loc(i)+5));
%     [r_peak(i),r_index(i)]=findpeaks(signal_section);
%     r_loc(i)=loc(i)-6+r_index(i);
% end
plot(tm,signal);
hold on;
plot(tm(r_loc),signal(r_loc),'ro');


