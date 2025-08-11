% this code puts together all the features in the single csv file, called
% "all.csv" 
P = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\filtered_features';
S = dir(fullfile(P,'*.txt')); 
all = zeros(1,68)
for k = 1:numel(S)
    F = fullfile(P,S(k).name);
    S(k).data = readtable(F)
    data = table2array(S(k).data)
    num = size(data,1)
    new = zeros(num, 68)
    new(:,2:end) = data
    file_name = erase(S(k).name, ["filtered_features_",".txt"])
    ID = str2double(file_name)
    new(:,1) = repmat(ID, [num 1])
    all = [all; new]
end
csvwrite('all_filtered.csv',all)