clear, clc, close all

strategies = {'diameter','k-means','CNN'};
mesh_names = {'Delaunay','prisms','CVT','Voronoi'};
font = 14;
S = length(strategies);
M = length(mesh_names);

%% compute quality

for i = 1:M
    for j = 1:S
        disp(['Computing quality of mesh ',mesh_names{i},' refined with strategy ',strategies{j}])
        load(['refined_',mesh_names{i},'_strategy_',strategies{j},'.mat'])
        [Uniformity_Factor,Ball_Ratio] = quality(refined_meshes{end});
        save([path2('quality'),'quality_',mesh_names{i},'_',strategies{j}],...
            'Uniformity_Factor','Ball_Ratio');
    end
end

%% plot quality histograms

bins = 10;
figure('Name','quality_historgrams','Position',[450 100 650 650])
for i = 1:M
    subplot(M,2,2*(i-1)+1)
    ylabel(mesh_names{i},'fontweight','bold','fontsize',font)
    for j = 1:S
        load(['quality_',mesh_names{i},'_',strategies{j}])
        subplot(M,2,2*(i-1)+1)
        hold on
        histogram(Uniformity_Factor,bins,'BinLimits',[0,1],...
            'Normalization','probability')
        subplot(M,2,2*(i-1)+2)
        hold on
        histogram(Ball_Ratio,bins,'BinLimits',[0,1],...
            'Normalization','probability')
    end
end

subplot(M,2,1)
title('Uniformity Factor','fontweight','bold','fontsize',font)
subplot(M,2,2)
title('Ball Ratio','fontweight','bold','fontsize',font)

legend({'diameter','k-means','CNN'},...
    'Orientation','horizontal',...
    'fontsize',font,...
    'Position',[0.25 0.02 0.5 0.05]);

%% plot complexity statistics

figure('Name','complexity_statistics','Position',[400 100 750 650])
sgtitle('complexity statistics','fontweight','bold','fontsize',font)
statistics = {'mesh vertices','mesh edges','mesh faces','mesh elements',...
    'total time [min]',{'average time','per element [sec]'}};

count = zeros(M,S,5);
for i = 1:M
    for j = 1:S
        load(['refined_',mesh_names{i},'_strategy_',strategies{j}])
        for k = 1:4
        	count(i,j,k) = refined_meshes{end}.elem_num(k);
        end
        count(i,j,5) = sum(refinement_time)/60;
        count(i,j,6) = sum(refinement_time)/refined_meshes{end}.elem_num(4);
    end
end

x = categorical(mesh_names);
x = reordercats(x,mesh_names);
for k = 1:6
    y = count(:,:,k);
    subplot(3,2,k)
    h = bar(x,y);
    ylabel(statistics{k},'fontsize',font)
end
set(h, {'DisplayName'}, strategies')
L = legend('Orientation','horizontal',...
    'fontsize',font,...
    'Position',[0.3 0.01 0.4 0.05]);

save_all_figures
