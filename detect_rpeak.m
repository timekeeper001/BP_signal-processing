function r_loc=detect_rpeak(signal,gain)
sig=signal/gain;
wt=modwt(sig,4,'sym4');
wtrec=zeros(size(wt));
wtrec(3:4,:)=wt(3:4,:);
y=imodwt(wtrec,'sym4');
avg=mean(y.^2);
[~,r_loc]=findpeaks(y,'MINPEAKHEIGHT',8*avg,'MINPEAKDISTANCE',50);

for i = 1:length(r_loc)
    left=max(1,r_loc(i)-4);
    right=min(r_loc(i)+4,length(signal));
    
    signal_section=signal(1,left:right);
    [~,r_index(i)]=max(signal_section);
    interval=(left:right);
    r_loc(i)=interval(r_index(i));
end
end

% l=length(loc);
% signal_section=signal(1,(loc(l)-5):end);
% [r_peak(l),r_index(l)]=max(signal_section);
% r_loc(l)=loc(l)-6+r_index(l);




