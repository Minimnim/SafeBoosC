%to upload the file with probabilities and outcome
all = readtable("Results.xlsx", 'Sheet', 'safeboosc exc 78')
data = table2array(all)
%outcome = readtable("MRI outcome for xgb_58ver.csv")
% outcome = readtable("IVH_spo2.csv")
%outcome = readtable("gray injury outcome for xgb_58ver.csv")
% outcome = table2array(outcome)
%mri = outcome(:,2)
hie = data(2:94,2)
%gray = outcome(:,2)
%to have AUC and 95% confidence interval
a = data(2:94,3) %since it has NaN values, before going further, we have to delete them 
%a(29,:) = []
%a(39,:) = []
[aauc,aauc_ci]=bootstrap_aucs(a,hie)
%to have specificity and sensitivity 
thresh = 0.5
b = zeros(93,1)
for x = 1:93
    if a(x,:) > thresh
        b(x,:) = 1
    else 
        b(x,:) = 0
    end
end 
C = confusionmat(outcome,b)
TP = C(2, 2);
TN = C(1, 1);
FP = C(1, 2);
FN = C(2, 1);
Accuracy = (TP + TN) / (TP + TN + FP + FN)
Sensitivity = TP / (FN + TP)
specificity = TN / (TN + FP)
mcc = (TP * TN - FP * FN) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));
aauc
aauc_ci
% for plotting the AUC curve
[X,Y,T,AUC] = perfcurve(hie, data(:,6), 1);
plot(X, Y);
% for finding the best cut-off for MCC
%z = 1-X
%p = z + Y -1 and then find the max p, then look at the index, and then use
%the index to find the best sensitivity and specificty, change the
%threshold till you have that values
%t-test between variables
group0 = data(data(:,2) == 0, 19);  
group1 = data(data(:,2) == 1, 19); 
[h, p, ci, stats] = ttest2(group0, group1);
mean_group0 = nanmean(group0);
mean_group1 = mean(group1);
sem_group0 = nanstd(group0) / sqrt(length(group0));  % Standard error of the mean
sem_group1 = std(group1) / sqrt(length(group1));  % Standard error of the mean
subplot(1,3,3);
% bar([1, 2], [mean_group0, mean_group1], 'FaceColor', [0.7 0.7 0.9]); 
b = bar([1, 2], [mean_group0, mean_group1]);  % Create the bar chart
b.FaceColor = 'flat';  % Allows different colors for each bar
b.CData(1,:) = [11 102 35]/255;  % Set first bar (group 0) to green [R G B]
b.CData(2,:) = [210 43 43]/255;  % Set second bar (group 1) to red [R G B]
hold on;
errorbar([1, 2], [mean_group0, mean_group1], [sem_group0, sem_group1], '.k', 'LineWidth', 1.5);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Non-Injury', 'Injury'});
ylabel('Mean Amplitude');
title('Mean and STD of PRD Mean Amplitude for Both Groups');
grid on;
% text(1.5, max(mean_group0, mean_group1) + 0.5*max(sem_group0, sem_group1), ...
%     sprintf('p = %.4f', p), 'HorizontalAlignment', 'center', 'FontSize', 12);
%two-way anova on injury and age
Injury = data(:, 2);  % Categorical variable: 0 or 1
Age = data(:, 9);     % Continuous or categorical variable
Response = data(:, 23);% Dependent variable (outcome measure)
Age = categorical(Age);
Injury = categorical(Injury);
[p, tbl, stats] = anovan(Response, {Injury, Age}, 'model', 'interaction', 'varnames', {'Injury', 'Age'});
