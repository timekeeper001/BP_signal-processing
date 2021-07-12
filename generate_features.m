function feature_mat=generate_features(patient_id,ppg_signal,ppg_signal_d,abp_signal,ppg_foot,systolic,notch,r_loc)
feature_mat=[];
for i = 1:(size(systolic,2)-1) 
    %ppg_section=ppg_signal(1,round(ppg_foot(i)*0.625):round(ppg_foot(i+1)*0.625));%fs=125下的图像
    abp_section=abp_signal(1,round(ppg_foot(i)*0.625):round(ppg_foot(i+1)*0.625));%125/200=0.625
    
    left=round(ppg_foot(i)*0.625);
    right=round(systolic(i)*0.625);
    if left>=right
        continue
    end
    ppg_signal_d_section=ppg_signal_d(1,left:right);
    [~,Q_index]=max(ppg_signal_d_section);
    interval=(left:right);
    Q=interval(Q_index);% Q：ppg导数最大值，出现在foot到systolic之间 fs=125下的坐标
    
    rpeak=0;
    for j = 1:(size(r_loc,2)-1)
        if r_loc(j)<ppg_foot(i)*0.625-20 && r_loc(j+1)>ppg_foot(i)*0.625-20 % 200/125=1.6
            rpeak=r_loc(j);%fs=125下的横坐标
            =(1/125)*(r_loc(j+1)-r_loc(j));%heart rate r-r
            breakHrRR
        end
    end
    if rpeak==0
        continue
    end
    %heart rate
    HrSS=(1/200)*(systolic(i+1)-systolic(i));%Kachuee,2017
    
    %Amplitude
    AmFS=ppg_signal(round(systolic(i)*0.625))-ppg_signal(round(ppg_foot(i)*0.625));%li,2014
    AmSN=ppg_signal(round(systolic(i)*0.625))-ppg_signal(round(notch(i)*0.625));%li,2014
    AmFN=ppg_signal(round(notch(i)*0.625))-ppg_signal(round(ppg_foot(i)*0.625));%li,2014
    AmFN_FS = AmFN/AmFS;%li,2014;Kachuee,2017 'AI'
    AmFN_SN = AmFN/AmSN;%li,2014
    
    
    %Time span
    TmFN=(1/200)*(notch(i)-ppg_foot(i));%li,2014; Slapničar, 2019
    TmNF=(1/200)*(ppg_foot(i+1)-notch(i));%li,2014; Slapničar, 2019
    TmFN_NF=TmFN/TmNF;%li,2014;
    Tm_FS=(1/200)*(systolic(i)-ppg_foot(i));%kurylyak,2013
    Tm_SF=(1/200)*(ppg_foot(i+1)-systolic(i));%kurylyak,2013 
    Tm_SN=(1/200)*(notch(i)-systolic(i));%Kachuee,2017 'LASI'
    Tm_FQ=(1/125)*(Q)-(1/200)*(ppg_foot(i));%Slapničar
    
    PAT_S=(1/200)*(systolic(i))-(1/125)*(rpeak);%li,2014;Kachuee,2017
    PAT_F=(1/200)*(ppg_foot(i))-(1/125)*(rpeak);%li,2014;Kachuee,2017
    PAT_Q=(1/125)*(Q-rpeak);%li,kachuee
    
    %area
    ArFS=0;%Kachuee,2017
    for k =round(ppg_foot(i)*0.625):round(systolic(i)*0.625)
        ArFS=ArFS+ppg_signal(k)-ppg_signal(round(ppg_foot(i)*0.625));
    end
    
    ArSN=0;%Kachuee,2017
    for l = round(systolic(i)*0.625):round(notch(i)*0.625)
        ArSN=ArSN+ppg_signal(l)-ppg_signal(round(ppg_foot(i)*0.625));
    end
    
    ArNF=0;%Kachuee,2017
    for m = round(notch(i)*0.625):round(ppg_foot(i+1)*0.625)
        ArNF=ArNF+ppg_signal(m)-ppg_signal(round(ppg_foot(i)*0.625));
    end
    ArNF_FN=ArNF/(ArFS+ArSN);%li,2014
    
    SBP=max(abp_section);
    DBP=min(abp_section);
    
    features=[patient_id,HrRR,HrSS,AmFS,AmSN,AmFN,AmFN_FS,AmFN_SN,TmFN,TmNF,TmFN_NF,Tm_FS,Tm_SF,Tm_SN,Tm_FQ,PAT_S,PAT_F,PAT_Q,ArFS,ArSN,ArNF,ArNF_FN,SBP,DBP];
    feature_mat=[feature_mat;features];
    %     tm_section=tm(1,round(ppg_foot(i)*0.625):round(ppg_foot(i+1)*0.625));
    %     plot(tm_section,abp_section)
end
feature_mat=rmoutliers(feature_mat);
end