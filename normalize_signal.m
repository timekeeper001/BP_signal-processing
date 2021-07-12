function norm_sig = normalize_signal(ppg)
    norm_sig=(ppg-min(ppg))/(max(ppg)-min(ppg));
end
