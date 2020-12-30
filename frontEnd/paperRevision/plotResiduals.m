%% Plot residual histogram for hangar data
clr = get(gca,'colororder');
close all;
s=10;
figure('Position',[500,500,85*s,30*s])
hold on
fprintf('\nVT Hangar\n')
allPoints = [];
for i=0:57
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\hangarOld\\x_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end

subplot(1,3,1)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',[0.5,0.5,0.5])
xlim([0,0.2])
title('x axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('X axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])




% points = load('G:\\PythonCode_Winter\\code\\residualValues\\yW_regions-res.mat');
% allPoints = points.res;
% 
% 
% subplot(1,3,2)
% histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(1,:),'BinWidth',0.005)
% xlim([0,0.2])
% title('y axis regions')
% xlabel('Residual Value (m)')
% ylabel('Count')
% fprintf('Y axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])



allPoints = [];
for i=0:25
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\hangarOld\\z_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end

subplot(1,3,3)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(2,:))
xlim([0,0.2])
title('z axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('Z axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])


set(gcf,'color','w');
% legend('x axis regions', 'z axis regions')
% title('VT Hangar Residual Distribution by Axis')
hold off
%% Plot average residual
% clear;
% close all;
% 
% for i=8
%     points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\hangarOld\\z_cg_regionLine_%i.mat',i));
%     points = points.pointRes;
% 
% end
% histogram(points)


%% Plot residual histogram for IBHS G
close all;
s=10;
figure('Position',[500,500,85*s,30*s])
hold on
fprintf('\nIBHS G\n')


allPoints = [];
for i=0:3
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\ibhs_G\\y_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end
subplot(1,2,1)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(1,:))
xlim([0,0.2])
title('y axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('Y axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])

allPoints = [];
for i=0:8
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\ibhs_G\\z_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end
subplot(1,2,2)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(2,:))
xlim([0,0.2])
title('z axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('Z axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])

set(gcf,'color','w');
% legend('z axis regions','y axis regions')
% suptitle('IBHS G Residual Distribution by Axis')

hold off

%% Plot residual histogram for IBHS D
close all;
s=10;
figure('Position',[500,500,85*s,30*s])
hold on

fprintf('\nIBHS D\n')




allPoints = [];
for i=0:11
    if i == 10
        continue
    end
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\ibhs_D\\x_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end
subplot(1,3,1)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',[0.5,0.5,0.5])
xlim([0,0.2])
title('x axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('X axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])


allPoints = [];
for i=0:5
    if i == 3 || i == 5
        continue
    end
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\ibhs_D\\y_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end
subplot(1,3,2)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(1,:))
xlim([0,0.2])
title('y axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('Y axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])


allPoints = [];
for i=0:13
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\ibhs_D\\z_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end
subplot(1,3,3)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(2,:))
xlim([0,0.2])
title('z axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('Z axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])





% xlim([0,0.2])

set(gcf,'color','w');
% legend('y axis regions', 'x axis regions','z axis regions')
% title('IBHS D Residual Distribution by Axis')
hold off



%% Plot residual histogram for Tennis
% close all;
s=10;
figure('Position',[500,500,85*s,30*s])
hold on
fprintf('\nBBTC\n')



allPoints = [];
for i=0:27
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\tennis\\x_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end

subplot(1,2,1)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',[0.5,0.5,0.5],'BinWidth',0.003)
xlim([0,0.2])
title('x axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('X axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])


allPoints = [];
for i=0:24
    if ismember(i,[2,4,6,9,10,12,15,17,18,19,21])
        continue
    end
    points = load(sprintf('G:\\PythonCode_Winter\\code\\residualValues\\tennis\\y_cg_regionLine_%i.mat',i));
    points = points.pointRes;
    if i == 0
        allPoints = points;
    else
        allPoints = horzcat(allPoints,points);
    end
end
subplot(1,2,2)
histogram(allPoints,'facealpha',0.5,'edgecolor','k','facecolor',clr(1,:))
xlim([0,0.2])
title('y axis regions')
xlabel('Residual Value (m)')
ylabel('Count')
fprintf('Y axis std: %3.4f, average: %3.4f\n',[std(allPoints),mean(allPoints)])




% xlim([0,0.2])

set(gcf,'color','w');
% legend('y axis regions','x axis regions')
% title('VT Tennis Residual Distribution by Axis')
hold off

%% something new!
% close all
% hold on
% data = load('G:\PythonCode_Winter\hangarCAD\W-horz-res.mat');
% res = data.res/39.37;
% subplot(4,1,1)
% histogram(res)
% xlim([0,1])
% title(sprintf('Z-axis Prismatic I-shape Columns (average = %3.4f m)',mean(res)))
% ylabel('Count')
% 
% data = load('G:\PythonCode_Winter\hangarCAD\W-vert-res.mat');
% res = data.res/39.37;
% subplot(4,1,2)
% histogram(res)
% xlim([0,1])
% title(sprintf('Z-axis Non-Prismatic I-shape Columns (average = %3.4f m)',mean(res)))
% ylabel('Count')
% 
% data = load('G:\PythonCode_Winter\hangarCAD\xS-res.mat');
% res = data.res/39.37;
% subplot(4,1,3)
% histogram(res)
% xlim([0,1])
% title(sprintf('X-axis S-shape Purlins (average = %3.4f m)',mean(res)))
% ylabel('Count')
% 
% % data = load('G:\PythonCode_Winter\hangarCAD\xW-res.mat');
% % res = data.res/39.37;
% % subplot(5,1,4)
% % histogram(res)
% % xlim([0,1])
% % title(sprintf('xW average = %3.4f m',mean(res)))
% % ylabel('Count')
% 
% data = load('G:\PythonCode_Winter\hangarCAD\yParabola-res.mat');
% res = data.res/39.37;
% subplot(4,1,4)
% histogram(res)
% xlim([0,1])
% title(sprintf('Y-axis Non-Prismatic Piecewise Frames (average = %3.4f m)',mean(res)))
% 
% 
% xlabel('Error Value (m)')
% ylabel('Count')
% set(gcf,'color','w');