%% analyze fish z images in batch

% in an experiment directory should be two folders, one called "image"
% which contains the image files, and one called "segmented" which contains
% the segmented image files.  The segemented image files should have the
% full name of the image file, and can then be followed by a suffix, such
% as "drawn"

expdir = uigetdir();

pixelspermicron = 10.6; % put appropriate pixels per micron value here. 

if ispc;
    filesystemoffset = 2; 
else
    filesystemoffset = 3;
end


imagefilelist = dir(fullfile(expdir, "image"));
segmentedfilelist = dir(fullfile(expdir, "segmented"));

for i = 1:size(imagefilelist, 1)-filesystemoffset; 
   PositionAnalysis(fullfile(expdir, 'image', imagefilelist(i+filesystemoffset).name), fullfile(expdir, 'segmented', segmentedfilelist(i+2).name), pixelspermicron, expdir);
end
