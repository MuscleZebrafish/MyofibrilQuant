% Combines outputs of freq_by_peak_*.mlx of the same genotype into a single
% mean frequency + 95% confidence interval

% Load all output files
% ASSUMES: all *.mat files in a folder should be combined
dirin = uigetdir(title="Select Folder to Process");
filelist = dir(fullfile(dirin, "*.mat"));

dataToSummarize = [];
xes = [];

% load histoSums from each image's *.mat file
for f = 1:length(filelist)
    filein = fullfile(filelist(f).folder, filelist(f).name);
    load(filein);
    dataToSummarize = [dataToSummarize histosum];
    xes = [xes; bins];
end

% calculate mean 
dataMean = mean(dataToSummarize, 2, "omitnan"); % mean across row

% calculate confidence intervals via bootstrapping
meanfun = @(x)mean(x, 1, "omitnan"); % mean down column; why not across row?? - because we transpose the matrix in bootci call

% run bootstrapping 95% CI estimation on transposed dataToSummarize
dataCI = bootci(10000, meanfun, dataToSummarize'); % up to 1000 or 10000(Josh's value)

% prepare CI data for plotting
xes = bins(1,1:79); % shorten by one to match dataToSummarize and histosum sizes
patchxes = [xes, fliplr(xes)];
dataPatch = [dataCI(1,:), fliplr(dataCI(2,:))];

% plot results
figure()
plot(xes, dataMean)
hold on
patch(patchxes, dataPatch,'b', "FaceAlpha", 0.25, 'LineStyle', 'none')
xlabel('Distance between Peaks (micron)', 'FontSize', 14)
ylabel('Fraction of peaks/micron', 'FontSize',14)
xlim([0, 4])
%title('Title', 'FontSize', 16)

%legend('Control', '+Rapamycin', "FontSize", 14, "Location", 'NorthWest')
%legend('boxoff')
ax = gca;
ax.FontSize = 14

% save data for later overlay
save([filein(1:end-4), '_with95CI.mat'], 'xes', 'dataMean', 'patchxes', 'dataPatch', '-mat')
% MOVE this *with95CI.mat file outside of the parent folder before
% rerunning this script!