% This code puts together all the features in a single CSV file called "all_transients.csv" 
P = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\transients_features';
S = dir(fullfile(P, '*.txt')); 

% Preallocate space for the data: one additional column for filenames
all = cell(numel(S), 16);

for k = 1:numel(S)
    F = fullfile(P, S(k).name);
    S(k).data = readtable(F);
    data = table2array(S(k).data);
    
    % Store the filename in the first column
    all{k, 1} = S(k).name;
    
    % Store each element of data in the remaining columns
    all(k, 2:(1 + numel(data))) = num2cell(data);
end

% Convert the cell array to a table for easy writing to a CSV
all_table = cell2table(all, 'VariableNames', ['Filename', arrayfun(@(x) ['Feature', num2str(x)], 1:15, 'UniformOutput', false)]);

% Write the table to a CSV file
writetable(all_table, 'all_transients.csv');
