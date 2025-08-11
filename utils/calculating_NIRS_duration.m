P = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\new';
S = dir(fullfile(P,'*.txt')); 
PP = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\neww';
SS = dir(fullfile(PP,'*.txt')); 
i = zeros(16,1)
for k = 1:numel(S)
    clear dur
    F = fullfile(P,S(k).name);
    S(k).data = readtable(F);
    transient = table2array(S(k).data);
    FF = fullfile(PP,SS(k).name);
    SS(k).data = readtable(FF);
    mydata = table2array(SS(k).data);
    ts = mydata(:,1);
    dur = ts(end,1) - ts(1,1);
    i(k,1) = dur;
end 