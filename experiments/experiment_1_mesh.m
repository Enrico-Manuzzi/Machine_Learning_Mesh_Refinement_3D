clear, clc, close all
rng('default')

%% Delaunay
N = 3;
[X,Y,Z] = meshgrid(linspace(0,1,N));
coord = [X(:),Y(:),Z(:)];
tria = delaunay(coord);
mesh = tria2mesh(coord,tria);
save([path2('meshes'),'mesh_Delaunay'],'mesh')
disp('Created mesh Delaunay')

%% cubes
mesh = prism(4);
for i = 1:2
    mesh = reflections(mesh);
end
disp('Created mesh cubes')
save([path2('meshes'),'mesh_cubes'],'mesh')

%% prisms
mesh = prism(4);
cut(mesh,[1 1 0],[0 0.5 0]) 
cut(mesh,[1 -1 0],[0 0.5 0])
cut(mesh,[1 1 0],[1 0.5 0])
cut(mesh,[1 -1 0],[1 0.5 0])
cut(mesh,[0 1 0],[0 0.5 0])
cut(mesh,[0 0 1],[0.5 0.5 0.5])
disp('Created mesh prisms')
save([path2('meshes'),'mesh_prisms'],'mesh')

%% voronoi mesh
N = 3;
seeds = rand(N^3,3);
mesh = voromesh(prism(4),seeds);
disp('Created mesh Voronoi')
save([path2('meshes'),'mesh_Voronoi'],'mesh')

%% Centroidal Voronoi Tessellation (CVT)
N = 3;
L = 1/N;
x = linspace(0+L/2,1-L/2,N);
[X,Y,Z] = meshgrid(x);
seeds = [X(:),Y(:),Z(:)];
seeds = seeds + randn(size(seeds))*L/20;
mesh = voromesh(prism(4),seeds);
disp('Created mesh CVT')
save([path2('meshes'),'mesh_CVT'],'mesh')

%% concave
load('mesh_cubes','mesh');
new_elem = cell(1,4);
N = mesh.elem_num(end);
n = nthroot(N,3);
lims = linspace(0,1,n+1);
for i = 1:mesh.elem_num(4)
    elem = RView(mesh,i,3);
    vert = vertices(elem);
    m = max(mean(vert));
    for j = 1:n
        if m > lims(j) &&  m < lims(j+1)
            new_elem{j}(end+1) = i;
        end
    end
end
mesh = agglomerate(mesh,new_elem);
mesh.convex = false;
disp('Created mesh concave')
save([path2('meshes'),'mesh_concave'],'mesh')

%% plot all

close all
mesh_names = {'Delaunay','cubes','prisms','Voronoi','CVT','concave'};
N = length(mesh_names);
meshes = cell(1,N);
for i = 1:length(mesh_names)
    load(['mesh_',mesh_names{i}])
    meshes{i} = mesh;
end

R = round(sqrt(N));
C = ceil(N/R);
meshes = reshape(meshes,R,C);
mesh_names = reshape(mesh_names,R,C);

boom = false;
figure('Name','initial_meshes')
plot_meshes(meshes,boom);

for i = 1:R
    for j = 1:C
        nexttile((i-1)*C+j)
        title(mesh_names{i,j})
    end
end

boom = true;
figure('Name','initial_meshes_exploded')
plot_meshes(meshes,boom);

for i = 1:R
    for j = 1:C
        nexttile((i-1)*C+j)
        title(mesh_names{i,j})
    end
end

save_all_figures