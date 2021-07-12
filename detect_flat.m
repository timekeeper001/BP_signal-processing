function percent=detect_flat(signal,window)

len = size(signal,2);
flat_loc=ones(1, (len-window +1));

for i = 2:(window)
    candidate_loc = (signal(1,1:(len-window+1)) ==  signal(1,i:(len-window+i)));
    flat_loc=(flat_loc & candidate_loc);
end

flat_loc=[flat_loc,zeros(1,window-1)];
flat_loc2=flat_loc;

for i = 2:(window)
    flat_loc(i:end) = flat_loc(i:end) | flat_loc2(1:(end-i+1));
    
end

percent=sum(flat_loc)/len;
end