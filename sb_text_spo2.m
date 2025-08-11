%to open and read the NIRS files in matlab; 
table0 = readtable('file1-patient_monitor1.csv');
table1 = readtable('file1-patient_monitor2.csv');
table2 = readtable('file1-patient_monitor3.csv');
data = [table0; table1; table2];
data(1:137,:)=[];
rows_to_keep = ~cellfun('isempty', data.Var1);
data = data(rows_to_keep, :);
ms = data.Var3;
ms_str = arrayfun(@(x) sprintf('%08d', mod(x, 100000000)), ms, 'UniformOutput', false);
time_str = string(data.Ver0_1_PhilipsLAN);
combined_time = strcat(time_str, ':', ms_str);
split_str = split(data.Var1, ' - ');
date = split_str(:,1);
date_time = strcat(date, '', combined_time);
a = datetime(date_time, 'InputFormat', 'dd/MM/yyyyHH:mm:ss:SSSSSSSS');
b = seconds(diff(a));
b = [0; b]; % Add zero at the beginning to start from zero
ts = cumsum(b);
% to plot the data before artefact removal; Sat in stored in column called RSO2
figure;hold on;grid on
sp = data.Var14;
plot(ts, sp, 'b.');
data = table(ts, sp);
% to remove NaNs at the start and end of signal; the number of rows differs
% in each participant, and some participants do not have any NaN value 
% data(1:554,:)=[];
% data = data(1:4409,:);
% data = data(4410:end,:)
% this file has to be divided into 2 parts because of lots of NaN values in
% between. the first file consists of: 
% data = data(217:4820,:)
% the second part consists of:
% data = data(5304:end,:)
% To rewrite and plot the updated ts and sat before next step begins
[ts, sp] = renew(data);
plot(ts, sp, 'g.');
%artefact removal 
spo2_artefact = ts(find(sp<20));
spo2_suddenchange = diff(sp);
a  = ts(find(spo2_suddenchange < -4));
b = ts(find(spo2_suddenchange > 4));
all = [spo2_artefact; a; b];
y = arrayfun(@(all)[all-15:all+15], all, 'UniformOutput', false);
y = cell2mat(y);
y = reshape(y, numel(y), 1);
remove = ismember(ts, y);
data = table(ts, sp);
data(remove,:)=[];
[ts, sp] = renew(data);
plot(ts,sp, 'r.');
% to replcase NaNs with cubic spline interpolation
tnans = ts(find(sp == 0));
sp(sp==0)=NaN; 
data = table(ts, sp);
nansreplaced = fillmissing(data, 'pchip');
[ts, sp] = renew(nansreplaced);
plot(ts, sp, 'r.');
% to upsample to 10 Hz 
Fs = 10; 
last_time = ceil(ts(end)/Fs)*Fs;
time_to_interp = ts(1) : 1/Fs : last_time ;
upsampled_data = [time_to_interp ; interp1(ts, sp, time_to_interp , 'pchip')];
% To rewrite and plot the updated ts and sat before next step begins
ts = upsampled_data(1,:);
sp = upsampled_data(2,:);
plot(ts, sp, 'b.');
% to anti-alising filter of 1/12 Hz. John recommended this method for
% antialising for preventing numerical instability because of low order
[z p k] = butter(6, (1/12)/(10/2),'low');
[sos, g] = zp2sos(z,p,k);
antiali = filtfilt(sos,g,sp) ;
plot(ts, antiali, 'r.');
% to downsample to 1/6 Hz
time_to_interp = ts(1) : 6 : last_time;
downsampled_data = [time_to_interp ; interp1(ts, antiali, time_to_interp)];
% To rewrite and plot the updated ts and sat before next step begins
ts = downsampled_data(1,:);
sp = downsampled_data(2,:);
plot(ts, sp, 'g.');
sp = sp.';
ts = ts.';
sp(sp>100) = 100;
% to save the pre-processed data as mydata.txt; if the NIRS file is broken to seperate files with a rather long duration between files, and have been analyzed 
% in different parts, there would be more than one mydata.txt; EX:
% mydata1.txt, mydata2.txt & ...
data = table(ts, sp);
writetable(data, 'spo2_1_long_pre.txt', 'Delimiter', 'tab');