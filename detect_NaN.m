function percent=detect_NaN(signal)
signal_NaN = signal(:,isnan(signal(1,:)));
percent=length(signal_NaN)/length(signal);
end

