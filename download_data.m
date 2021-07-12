%%%%%%%%下载的数据拖到数据集文件夹
%每条记录最短5分钟
patient_count=0;
min_time=5;
max_time=60;
n=2;%想要几个患者
t_flat=0.05; %tolerated_flat_percent
t_NaN=0.03; %tolerated_NaN_percent

patient_list=physionetdb('mimic2wdb/31/');
for patient_index = 393:length(patient_list)
    patient_id=char(patient_list(patient_index));
    
    %检测所有记录里有没有出现过这三个信号
    layout_file=strcat('mimic2wdb/31/',patient_id,patient_id(1:end-1),'_layout');
    [layout_info]=wfdbdesc(layout_file);
    all_channel_list=[];
    for i = 1:(size(layout_info,2))
        all_channel_list=[all_channel_list,string(layout_info(i).Description)];
    end
    ppg=strmatch("PLETH",all_channel_list,'exact');
    ecg=strmatch("II",all_channel_list,'exact');
    abp=strmatch("ABP",all_channel_list,'exact');%返回信号的序号或【】
    if isempty(ppg) || isempty(ecg) || isempty(abp) %检查所有记录里否存在三条信号
        disp([patient_id,' FAIL: lack of channels in ALL records']);
        continue
        
    else
        total_length=0;
        record_list=physionetdb(strcat('mimic2wdb/31/',patient_id));
        
        %如果有的话，则继续检测###每一条###
        for record_index=3:length(record_list)
            record_id=char(record_list(record_index));
            record_path=strcat('mimic2wdb/31/',patient_id,record_id);
            record_mat=strcat(record_id,'m');
            [record_info]=wfdbdesc(record_path);
            signal_length=(record_info(1).LengthSamples)*(1/125)*(1/60);
            
            %检测这一条记录里有没有出现三条信号
            channel_list=[];
            for i = 1:(size(record_info,2))
                channel_list=[channel_list,string(record_info(i).Description)];
            end
            ppg=strmatch("PLETH",channel_list,'exact');
            ecg=strmatch("II",channel_list,'exact');
            abp=strmatch("ABP",channel_list,'exact');%返回信号的序号或【】
            if isempty(ppg) || isempty(ecg) || isempty(abp) %检查这一条记录里是否存在三条信号
                disp([record_id,' FAIL: lack of channels in this record']);
                continue
                
                %检测这条记录时长
            elseif signal_length<=min_time
                disp([record_id,' FAIL: too short ',num2str(signal_length)]);
                continue
                
                %如果计入这条记录后时长小于等于60分钟>全部下载>检查flat是否超过5%,NaN是否超过5%
            elseif total_length+signal_length<=max_time
                wfdb2mat(record_path, [ppg,ecg,abp]);
                [tm,signal,Fs,siginfo]=rdmat(record_mat);
                
                signalTr=(signal)';
                ppg_signal=signalTr(1,:);
                ecg_signal=signalTr(2,:);
                abp_signal=signalTr(3,:);
                if (detect_flat(ppg_signal,15)>t_flat||detect_flat(ecg_signal,15)>t_flat||detect_flat(abp_signal,15)>t_flat)
                    delete(strcat(record_mat,'.mat'));
                    delete(strcat(record_mat,'.hea'));
                    disp([record_id,' deleted: too many flats']);
                    continue
                elseif (detect_NaN(ppg_signal)>t_NaN)||detect_NaN(ecg_signal)>t_NaN||detect_NaN(abp_signal)>t_NaN
                    delete(strcat(record_mat,'.mat'));
                    delete(strcat(record_mat,'.hea'));
                    disp([record_id,' deleted: too many NaN']);
                    continue
                else
                    total_length=total_length+signal_length;
                    disp([record_id,' downloaded, total length: ',num2str(total_length)]);
                end
                
                %如果计入这条记录后时长大于60分钟>下载部分>检查flat是否超过5%,NaN是否超过5%
            elseif  total_length+signal_length>max_time
                sample=(max_time-total_length)*60*125;
                wfdb2mat(record_path, [ppg,ecg,abp], sample);
                [tm,signal,Fs,siginfo]=rdmat(record_mat);
                
                signalTr=(signal)';
                ppg_signal=signalTr(1,:);
                ecg_signal=signalTr(2,:);
                abp_signal=signalTr(3,:);
                if (detect_flat(ppg_signal,15)>t_flat||detect_flat(ecg_signal,15)>t_flat||detect_flat(abp_signal,15)>t_flat)
                    delete(strcat(record_mat,'.mat'));
                    delete(strcat(record_mat,'.hea'));
                    disp([record_id,' deleted: too many flats']);
                    continue
                elseif (detect_NaN(ppg_signal)>t_NaN)||detect_NaN(ecg_signal)>t_NaN||detect_NaN(abp_signal)>t_NaN
                    delete(strcat(record_mat,'.mat'));
                    delete(strcat(record_mat,'.hea'));
                    disp([record_id,' deleted: too many NaN']);
                    continue
                else
                    total_length=max_time;
                    disp([record_id,' downloaded, total length: ',num2str(total_length)]);
                    break
                end
            end
        end
        if total_length<max_time && total_length>0
            disp(['-------------------------DELETE patient',patient_id,' related records!!!!!!!!!-------------------------']);
        elseif total_length==max_time
            patient_count=patient_count+1;
            disp(['-------------------------',num2str(patient_count),' patients selected-------------------------']);
            if patient_count>=n
                break
            end
        end
    end
end


%
% for index=3100331:3100332
%     id=char(num2str(index));
%     total_length=0;
%     try
%         for i = 1:200 %开始和结束
%             No=num2str(i,'%04d');
%             recordName=strcat('mimic2wdb/31/',id,'/',id,'_',No); %'mimic2wdb/31/3100038/3100038_0021'
%             recordMat=strcat(id,'_',No,'m');%'3100038_0021m'
%
%             wfdb2mat(recordName,[],125);
%             [tm,signal,Fs,siginfo]=rdmat(recordMat);
%             siglist=[];
%
%             for i = 1:(size(siginfo,2))
%                 siglist=[siglist,string(siginfo(i).Description)];
%             end
%
%             ppg=strmatch("PLETH",siglist,'exact');
%             ecg=strmatch("II",siglist,'exact');
%             abp=strmatch("ABP",siglist,'exact');%返回信号的序号或【】
%
%             if isempty(ppg) || isempty(ecg) || isempty(abp) %检查是否存在三条信号
%                 delete(strcat(recordMat,'.mat'));
%                 delete(strcat(recordMat,'.hea'));
%                 disp([strcat(id,'_',No),' deleted: lack of signals']);
%
%             else
%                 wfdb2mat(recordName,[ppg,ecg,abp]);
%                 [tm,signal,Fs,siginfo]=rdmat(recordMat);
%                 signalTr=(signal)';
%                 ppg_signal=signalTr(1,:);
%                 ecg_signal=signalTr(2,:);
%                 abp_signal=signalTr(3,:);
%                 signal_length=size(signal,1)*(1/125)*(1/60);%分钟
%
%                 if signal_length <= min_time  %长度小于5分钟
%                     delete(strcat(recordMat,'.mat'));
%                     delete(strcat(recordMat,'.hea'));
%                     disp([strcat(id,'_',No),' deleted: too short ',num2str(signal_length)]);
%
%                 elseif (detect_flat(ppg_signal,15)>t_flat||detect_flat(ecg_signal,15)>t_flat||detect_flat(abp_signal,15)>t_flat)
%                     delete(strcat(recordMat,'.mat'));
%                     delete(strcat(recordMat,'.hea'));
%                     disp([strcat(id,'_',No),' deleted: too many flats']);
%
%                 elseif total_length+signal_length>60
%                     sample=(60-total_length)*60*125;
%                     total_length=60;
%                     wfdb2mat(recordName,[ppg,ecg,abp],sample);
%                     disp([strcat(id,'_',No),' downloaded, total length: ',num2str(total_length)]);
%                     break
%
%                 else
%                     total_length=total_length+signal_length;
%                     disp([strcat(id,'_',No),' downloaded, total length: ',num2str(total_length)]);
%
%                 end
%             end
%         end
%         patient_count=patient_count+1;
%         disp(['-------------------------',num2str(patient_count),' patients selected-------------------------']);
%         if patient_count>=n
%             break
%         end
%     catch
%         if total_length>0
%             patient_count=patient_count+1;
%             disp(['-------------------------',num2str(patient_count),' patients selected-------------------------']);
%             if patient_count>=n
%                 break
%             end
%         end
%     end
% end
