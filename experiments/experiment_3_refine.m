clear, clc, close all
rng('default')

N_ref = 1;
strategies = {'diameter','k-means','CNN'};
mesh_names = {'Delaunay','prisms','CVT','Voronoi'};

%% refine meshes using different strategies

M = length(mesh_names);
S = length(strategies);
finest_meshes = cell(M,S);
for i = 1:M
    for j = 1:S
        display(['Refining mesh ',mesh_names{i},' with strategy ',strategies{j}])
        load(['mesh_',mesh_names{i}])
        refined_meshes = cell(1,N_ref+1);
        refined_meshes{1} = mesh;
        refinement_time = zeros(1,N_ref);
        failed = cell(1,N_ref);
        labels = cell(1,N_ref);
        for k = 1:N_ref
            display(['Refinement level ',num2str(k),' of ',num2str(N_ref)])
            refined_meshes{k+1} = copy(refined_meshes{k});
            [failed{k},refinement_time(k),labels{k}] = ...
                refine(refined_meshes{k+1},strategies{j});
        end
        finest_meshes{i,j} = copy(refined_meshes{end});
        save([path2('meshes'),'refined_',mesh_names{i},'_strategy_',strategies{j}],...
            'refined_meshes','refinement_time','failed','labels');
    end
end

%% plot all

meshes = cell(M,S+1);
for i = 1:M
    load(['mesh_',mesh_names{i}])
    meshes{i,1} = copy(mesh);
end
meshes(:,2:end) = finest_meshes;
row_names = mesh_names;
col_names = [{'initial'},strategies];
boom = false;
figure('Name','refined_meshes')
plot_meshes(meshes,boom,row_names,col_names)