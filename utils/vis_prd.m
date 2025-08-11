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

% Step 3: Visualization
figure;
hold on;

% Plot individual transients with light red color
for i = 1:size(alignedTransients, 1)
    plot(alignedTransients(i, :), 'Color', [1 0.8 0.8]);  % Light red color for individual transients
end

% Plot the mean of all transients in red
meanTransient = nanmean(alignedTransients, 1);  % Compute mean ignoring NaN values
plot(meanTransient, 'Color', [1 0 0], 'LineWidth', 2);  % Plot mean in red with thicker line

% Add labels and title
xlabel('Aligned Time Points');
ylabel('Magnitude of Drop from Baseline');
title('Visualization of Aligned Transients from Baseline');

hold off;



