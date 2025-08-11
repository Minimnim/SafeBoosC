clear all; 
data = readtable('mydata_1.txt');
ts = data(:,1);
sat = data(:,2); 
dataa = readtable('spo2_1_post.txt');
ts_spo2 = dataa(:,1);
spo2 = dataa(:,2); 
tran = readtable('transient_1.txt');
tran = table(ts,tran);
tran_spo2 = readtable('spo2_post_transient_1.txt');
tran_spo2 = table(ts_spo2, tran_spo2);
filtered = readtable('filtered_1.txt');
filtered = table(ts, filtered); 
filtered_spo2 = readtable('spo2_post_filtered_1.txt');
filtered_spo2 = table(ts_spo2, filtered_spo2);
%find the mutual time between nirs and spo2
[common_times, idx1, idx2] = intersect(ts, ts_spo2);
data = table2array(data);
data = data(idx1,:);
dataa = table2array(dataa);
dataa = dataa(idx2,:);
tran = table2array(tran);
tran = table2array(tran);
tran = tran(idx1,:);
tran_spo2 = table2array(tran_spo2);
tran_spo2 = table2array(tran_spo2);
tran_spo2 = tran_spo2(idx2,:);
filtered = table2array(filtered);
filtered = table2array(filtered);
filtered = filtered(idx1,:);
filtered_spo2 = table2array(filtered_spo2);
filtered_spo2 = table2array(filtered_spo2);
filtered_spo2 = filtered_spo2(idx2,:); 
%ftoe 
ftoe = (dataa(:,2)-data(:,2))./dataa(:,2);
ftoe_total_pow = nanmean(abs(ftoe).^2 );
ftoe_env = (abs(hilbert(ftoe))).^2;
meanenv = mean(ftoe_env);
SDenv = std(ftoe_env);
%Pearson Correlation Coefficient of Derivatives for signals
x_prime = diff(data(:,2));
y_prime = diff(dataa(:,2));
mean_x_prime = mean(x_prime);
mean_y_prime = mean(y_prime);
numerator = sum((x_prime - mean_x_prime) .* (y_prime - mean_y_prime));
denominator = sqrt(sum((x_prime - mean_x_prime).^2) * sum((y_prime - mean_y_prime).^2));
r_x_prime_y_prime_signals = numerator / denominator;
%Pearson Correlation Coefficient of Derivatives for filtered signals
x_prime = diff(filtered(:,2));
y_prime = diff(filtered_spo2(:,2));
mean_x_prime = mean(x_prime);
mean_y_prime = mean(y_prime);
numerator = sum((x_prime - mean_x_prime) .* (y_prime - mean_y_prime));
denominator = sqrt(sum((x_prime - mean_x_prime).^2) * sum((y_prime - mean_y_prime).^2));
r_x_prime_y_prime_filtered = numerator / denominator;
%Pearson Correlation Coefficient of Derivatives for filtered transients
x_prime = diff(tran(:,2));
y_prime = diff(tran_spo2(:,2));
mean_x_prime = mean(x_prime);
mean_y_prime = mean(y_prime);
numerator = sum((x_prime - mean_x_prime) .* (y_prime - mean_y_prime));
denominator = sqrt(sum((x_prime - mean_x_prime).^2) * sum((y_prime - mean_y_prime).^2));
r_x_prime_y_prime_tran = numerator / denominator;
%Binary event match
tran = tran(:,2);
tran(tran >= mode(tran)) = 0;
tran(tran > 0) = 1; 
tran_spo2 = tran_spo2(:,2);
tran_spo2(tran_spo2 >= mode(tran_spo2)) = 0; 
tran_spo2(tran_spo2 > 0) = 1; 
both = (sum(tran == 1 & tran_spo2 == 1))/length(tran);
none = (sum(tran == 0 & tran_spo2 == 0))/length(tran);
spo2_only = (sum(tran == 0 & tran_spo2 == 1))/length(tran);
nirs_only = (sum(tran == 1 & tran_spo2 == 0))/length(tran);
both + none + spo2_only + nirs_only
table = [mean(ftoe), mode(ftoe), ftoe_total_pow, meanenv, SDenv, r_x_prime_y_prime_signals, r_x_prime_y_prime_filtered, r_x_prime_y_prime_tran, both, none, spo2_only, nirs_only];
writematrix(table, 'fio_1.txt', 'Delimiter', 'tab')