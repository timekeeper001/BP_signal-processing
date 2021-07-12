function signal=filter_signal(signal)
[b,a] = butter(4,[0.5,50]/(125/2));  % butterworth filter sf=125, 低频调低，高频50
signal = filtfilt(b,a,signal); 
end