P = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\spo2_preductal';
S = dir(fullfile(P,'*.txt')); 
params = decomp_PARAMS
fs = 1 / 6;
db_plot = false;
for k = 1:numel(S)
    F = fullfile(P,S(k).name);
    S(k).data = readtable(F);
    data = table2array(S(k).data)
    sat = data(:,2)
    sat = fillmissing(sat, 'linear')
    y = shorttime_iter_SSA_decomp(sat, fs, params, db_plot);
    transient = y.component.'
    nirs = y.nirs.'
    without_component = nirs - transient + nanmean(sat)
    tran = append('spo2_pre_transient', '_' ,  erase(S(k).name, 'spo2_'))
    fil = append('spo2_pre_filtered', '_' ,  erase(S(k).name, 'spo2_'))
    csvwrite(tran,transient)
    csvwrite(fil,without_component)
end 
