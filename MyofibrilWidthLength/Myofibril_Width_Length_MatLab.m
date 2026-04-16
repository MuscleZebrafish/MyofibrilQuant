%% Sarcomere Manual Measurement Avg

% Choose Folder to process
% Written by Emily Tomak, with later input by Joy-El Talbot

    dirin = uigetdir(title="Select Folder to Process");
    filelist = dir(fullfile(dirin, "*.csv"));

    for f = 1:length(filelist)
        baseFileName{f} = filelist(f).name;
        filePath = fullfile(dirin, baseFileName{f});
        Length_Column = readtable(filePath).Length;
        MeanLength(f,1) = mean(Length_Column);
    end 

  
% Define and create output folder

    filename = datestr(datetime("today"), "yyyy-mmm-dd");
    filename = strcat(filename, "_SarcManualMeasure");

    processedFiles = []; % to store for future reproducibility
 

   for f = 1:length(filelist)

      processedFiles = [processedFiles; convertCharsToStrings(filelist(f).name)]; % store processed filenames

   end
   
%%
% build final table for export...

    results = table(processedFiles, MeanLength);

% CSV export of results table

    writetable(results, fullfile(dirin, strcat(filename, ".csv")));