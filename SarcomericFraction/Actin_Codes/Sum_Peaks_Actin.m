load('WT_6_15jun22_mMac_Slice_Lng_green_with95CI.mat');
data_xes = xes; % same for all files
data_patchxes = patchxes; % same for all files
wt_mean = dataMean;
wt_ci = dataPatch;

load('Mylpfa_6_Slice_Lng_green_with95CI.mat')
mylpfb_mean = dataMean;
mylpfb_ci = dataPatch;


%%


% plot results
figure()
plot(data_xes, wt_mean, 'b', 'linewidth',3)
hold on
plot(data_xes, mylpfb_mean, 'r', 'linewidth',3)

patch(data_patchxes, wt_ci,'b', "FaceAlpha", 0.25, 'LineStyle', 'none')
patch(data_patchxes, mylpfb_ci, 'r', "FaceAlpha", 0.25, 'LineStyle', 'none')

xlabel('Distance between Peaks (micron)', 'FontSize', 14)
ylabel('Fraction of peaks/micron', 'FontSize',14)
xlim([0, 4])
%title('Title', 'FontSize', 16)

legend('WT', ...
    'mylpfa-/-', ...
    "FontSize", 14, "Location", 'NorthEast')
legend('boxoff')
ax = gca;
ax.FontSize = 14
%%
%X-Axis Shading

v1 = [1.55 0; 2.15 0; 2.15 0.4; 1.55 0.4];
f = [1 2 3 4];
p1= patch('Faces',f,'Vertices',v1,'FaceColor','black', 'facealpha', 0.1, 'LineStyle', 'none')
p1.Annotation.LegendInformation.IconDisplayStyle = 'off';

v2 = [0.7 0; 1.0 0; 1.0 0.4; 0.7 0.4];
f = [1 2 3 4];
p2= patch('Faces',f,'Vertices',v2,'FaceColor','black', 'facealpha', 0.1, 'LineStyle', 'none')
p2.Annotation.LegendInformation.IconDisplayStyle = 'off';