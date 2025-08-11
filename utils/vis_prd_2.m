% Define folder where text files are located
folderPath = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\transients\non injury';  % Change to your folder path
files = dir(fullfile(folderPath, '*.txt'));  % Get all .txt files in the folder

allTransients = {};  % To store all the transients from all files

% Step 1: Extract transients (drops) from all files
for i = 1:length(files)
    % Read each text file
    filePath = fullfile(folderPath, files(i).name);
    data = load(filePath);
    
    % Compute the baseline (mode of the data)
    baseline = mode(data);
    
    % Find values that drop below the baseline
    belowBaseline = find(data < baseline);
    
    % Find distinct transients (drops) by checking for gaps between indices
    if length(belowBaseline) > 1
        diffBelowBaseline = diff(belowBaseline);
        dropStartIndices = [belowBaseline(1); belowBaseline(find(diffBelowBaseline > 1) + 1)];
        dropEndIndices = [belowBaseline(find(diffBelowBaseline > 1)); belowBaseline(end)];
        
        % Collect each transient (drop)
        for j = 1:length(dropStartIndices)
            transient = data(dropStartIndices(j):dropEndIndices(j)) - baseline;  % Shift drop to baseline = 0
            allTransients{end+1} = transient;  % Store the transient
        end
    end
end

% Step 2: Align transients by their center point (minimum value)
maxLength = max(cellfun(@length, allTransients));  % Find the longest transient

alignedTransients = nan(length(allTransients), maxLength);  % Initialize matrix with NaNs

for i = 1:length(allTransients)
    transient = allTransients{i};
    dropLength = length(transient);
    
    % Find the center of the transient (the minimum point)
    [~, minIdx] = min(transient);  % Find index of minimum value (center point)
    
    % Align the transient around its center
    centerIdx = round(maxLength / 2);  % The center index of the matrix row
    startIdx = max(1, centerIdx - (minIdx - 1));  % Ensure startIdx is positive
    
    % Adjust end index to ensure it fits within the matrix bounds
    endIdx = min(startIdx + dropLength - 1, maxLength);
    
    % Place the aligned transient into the matrix (handling different lengths)
    alignedTransients(i, startIdx:endIdx) = transient(1:(endIdx - startIdx + 1));
end

% Step 3: Extract the central 5% of each aligned transient
alignedLength = size(alignedTransients, 2);  % Get the total length of aligned transients
centralPortionLength = round(0.05 * alignedLength);  % 5% of the total length
halfPortionLength = floor(centralPortionLength / 2);

centralTransients = nan(size(alignedTransients, 1), centralPortionLength);  % Preallocate for central data

for i = 1:size(alignedTransients, 1)
    % Extract the central portion around the center of each aligned transient
    centerIdx = round(alignedLength / 2);  % Center of the aligned data
    startIdx = centerIdx - halfPortionLength;
    endIdx = startIdx + centralPortionLength - 1;
    
    % Extract the central 5% and store it
    centralTransients(i, :) = alignedTransients(i, startIdx:endIdx);
end

% Step 4: Visualization of central 5% of each transient
figure;
hold on;

% % Plot individual central portions with light red color
% for i = 1:size(centralTransients, 1)
%     plot(centralTransients(i, :), 'Color', [1 0.8 0.8]);  % Light red color for individual transients
% end

% Plot the mean of all central portions in red
meanCentralTransient = nanmean(centralTransients, 1);  % Compute mean ignoring NaN values
plot(meanCentralTransient, 'Color', [0 1 0], 'LineWidth', 2);  % Plot mean in red with thicker line

% Add labels and title
xlabel('Central Time Points (5% of total)');
ylabel('Magnitude of Drop from Baseline');
title('Visualization of Central 5% of Aligned Transients from Baseline');


% Define folder where text files are located
folderPath = 'C:\Users\PhysioUser\Desktop\Safeboosc\New folder\transients\injury';  % Change to your folder path
files = dir(fullfile(folderPath, '*.txt'));  % Get all .txt files in the folder

allTransients = {};  % To store all the transients from all files

% Step 1: Extract transients (drops) from all files
for i = 1:length(files)
    % Read each text file
    filePath = fullfile(folderPath, files(i).name);
    data = load(filePath);
    
    % Compute the baseline (mode of the data)
    baseline = mode(data);
    
    % Find values that drop below the baseline
    belowBaseline = find(data < baseline);
    
    % Find distinct transients (drops) by checking for gaps between indices
    if length(belowBaseline) > 1
        diffBelowBaseline = diff(belowBaseline);
        dropStartIndices = [belowBaseline(1); belowBaseline(find(diffBelowBaseline > 1) + 1)];
        dropEndIndices = [belowBaseline(find(diffBelowBaseline > 1)); belowBaseline(end)];
        
        % Collect each transient (drop)
        for j = 1:length(dropStartIndices)
            transient = data(dropStartIndices(j):dropEndIndices(j)) - baseline;  % Shift drop to baseline = 0
            allTransients{end+1} = transient;  % Store the transient
        end
    end
end

% Step 2: Align transients by their center point (minimum value)
maxLength = max(cellfun(@length, allTransients));  % Find the longest transient

alignedTransients = nan(length(allTransients), maxLength);  % Initialize matrix with NaNs

for i = 1:length(allTransients)
    transient = allTransients{i};
    dropLength = length(transient);
    
    % Find the center of the transient (the minimum point)
    [~, minIdx] = min(transient);  % Find index of minimum value (center point)
    
    % Align the transient around its center
    centerIdx = round(maxLength / 2);  % The center index of the matrix row
    startIdx = max(1, centerIdx - (minIdx - 1));  % Ensure startIdx is positive
    
    % Adjust end index to ensure it fits within the matrix bounds
    endIdx = min(startIdx + dropLength - 1, maxLength);
    
    % Place the aligned transient into the matrix (handling different lengths)
    alignedTransients(i, startIdx:endIdx) = transient(1:(endIdx - startIdx + 1));
end

% Step 3: Extract the central 5% of each aligned transient
alignedLength = size(alignedTransients, 2);  % Get the total length of aligned transients
centralPortionLength = round(0.05 * alignedLength);  % 5% of the total length
halfPortionLength = floor(centralPortionLength / 2);

centralTransients = nan(size(alignedTransients, 1), centralPortionLength);  % Preallocate for central data

for i = 1:size(alignedTransients, 1)
    % Extract the central portion around the center of each aligned transient
    centerIdx = round(alignedLength / 2);  % Center of the aligned data
    startIdx = centerIdx - halfPortionLength;
    endIdx = startIdx + centralPortionLength - 1;
    
    % Extract the central 5% and store it
    centralTransients(i, :) = alignedTransients(i, startIdx:endIdx);
end

% Step 4: Visualization of central 5% of each transient
% figure;
hold on;

% % Plot individual central portions with light red color
% for i = 1:size(centralTransients, 1)
%     plot(centralTransients(i, :), 'Color', [1 0.8 0.8]);  % Light red color for individual transients
% end

% Plot the mean of all central portions in red
meanCentralTransient = nanmean(centralTransients, 1);  % Compute mean ignoring NaN values
plot(meanCentralTransient, 'Color', [1 0 0], 'LineWidth', 2);  % Plot mean in red with thicker line

% Add labels and title
xlabel('Central Time Points (5% of total)');
ylabel('Magnitude of Drop from Baseline');
title('Visualization of Central 5% of Aligned Transients from Baseline');

hold on;
