function [zpos] = PositionAnalysis(image, segmentation, pixelspermicron, outputdir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


drawnfilename = segmentation;
imagefilename = image


% pixelspermicron = 10.6;


pixelsize = 1/pixelspermicron; 

[~,filesavename,~] = fileparts(imagefilename);


drawn = imread(drawnfilename);
image = imread(imagefilename);

drawng = rgb2gray(drawn);

% imagesc(drawng)

linemask = drawng ==255;

% imagesc(linemask)

wholemask = imfill(linemask, 'holes');

% imagesc(wholemask)

countmask = bwlabel(~linemask & wholemask);

% imagesc(countmask)


[drdist, distidx] = bwdist(countmask > 0);

% imagesc(distidx)

dist_ids = zeros(size(linemask));
for i = 1: numel(dist_ids);
dist_ids(i) = countmask(distidx(i));
end

% imagesc(dist_ids)

countmaskfused = dist_ids .* double(wholemask);

% imagesc(countmaskfused)

%% Analyze image with countmask

red = image(:,:,1);
green = image(:,:,2);
blue = image(:,:,3);

% generate distance transforms for each object in countmask

cmaskdist = zeros(size(countmaskfused));

for i = 1:max(countmask, [], 'all');
    currmask = [];
    currdist = [];
    currmask = ~(countmaskfused == i);
    currdist = bwdist(currmask);
    cmaskdist = cmaskdist + currdist.*double(~currmask);
end

% measure values at each distance

greendist= [];
reddist = [];
bluedist = [];

zpos = struct('greendist_bycell', [], 'reddist_bycell', [], 'bluedist_bycell', [], 'greendist_overall', [], 'reddist_overall', [],'bluedist_overall', []);

for i = 1:max(cmaskdist, [], 'all')
    currdistmask = cmaskdist == i;
    greendist(i,1) = mean(green(currdistmask), "all");
    reddist(i,1) = mean(red(currdistmask), "all");
    bluedist(i,1) = mean(blue(currdistmask), "all");
end
zpos(1).greendist_overall = greendist;
zpos(1).reddist_overall = reddist;
zpos(1).bluedist_overall = bluedist;
zpos(1).xes = (1:1:size(greendist,1))*pixelsize;

for c = 1:max(countmaskfused, [], 'all');
    currmask = countmaskfused == c;
    for i = 1:max(cmaskdist(currmask), [], 'all');
        currdistmask = cmaskdist == i;
        zpos(1).greendist_bycell{c,1}(i,1) = mean(green(currmask & currdistmask));
        zpos(1).reddist_bycell{c,1}(i,1) = mean(red(currmask & currdistmask));
        zpos(1).bluedist_bycell{c,1}(i,1) = mean(blue(currmask & currdistmask));
    end
end



%% Plotting

fig1 = figure()

plot(zpos(1).xes, reddist, 'r')
hold on
plot(zpos(1).xes, greendist, 'g')
plot(zpos(1).xes, bluedist, 'b')
xlabel('Distance from Edge of Cell (μm)')
ylabel('Average Fluorescence Intensity')
title([filesavename, 'average intensity']);

fig2 = figure()
hold on
for i = 1:size(zpos(1).greendist_bycell, 1)
    plot(zpos(1).greendist_bycell{i,1}, 'g');
    plot(zpos(1).reddist_bycell{i,1}, 'r');
    plot(zpos(1).bluedist_bycell{i,1}, 'b');
    
end
xlabel('Distance from Edge of Cell (pixel#)')
ylabel('Average Fluorescence Intensity')
title([filesavename, 'average intensity per cell']);


fig3 = figure()
imagesc(countmaskfused)
title([filesavename, 'countmask']);
%% Save outputs

[~,filesavename,~] = fileparts(imagefilename);

output_table = table(zpos(1).xes', zpos(1).reddist_overall, zpos(1).greendist_overall, zpos(1).bluedist_overall, 'VariableNames', {'distance','red', 'green', 'blue'});

writetable(output_table, fullfile(outputdir, [filesavename, '_table.xls']), 'FileType','spreadsheet')

save(fullfile(outputdir, [filesavename, '_analysis.mat']), 'zpos')

savefig(fig1, fullfile(outputdir, [filesavename,'_fig1.fig']), 'compact' );
savefig(fig2, fullfile(outputdir, [filesavename,'_fig2.fig']), 'compact' );

imwrite(uint16(countmaskfused),fullfile(outputdir, [filesavename,'_countmask.png']), "png");

end