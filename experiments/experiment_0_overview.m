clear, clc, close all
rng('default')

%% classical refinement strategies

meshes = cell(2,3);
meshes{1,1} = pyramid(3);
meshes{1,2} = prism(3);
meshes{1,3} = prism(4);
strategies = {'tetrahedron','prism','cube'};

for i = 1:size(meshes,2)
    meshes{2,i} = copy(meshes{1,i});
    refine(meshes{2,i},strategies{i});
end

row_names = {'initial','refined'};
col_names = {'tetrahedron','prism','cube'};
boom = true;

figure('Name','classic_refinement')
my_title = 'Classical refinement strategies';
plot_meshes(meshes,boom,row_names,col_names,my_title)

%% CNN refinement strategy based on shape classification
meshes = cell(2,4);

% pyramid with chopped corner
meshes{1,1} = pyramid(3);
cut(meshes{1,1},[0 0 1],[0 0 0.7])
meshes{1,1} = copy(RView(meshes{1,1},1,3));

% prism with sliced face
meshes{1,2} = prism(3);
face = RView(meshes{1,2},3,2);
vertices_face = vertices(face);
normal = vertices_face(1,:)-vertices_face(4,:);
x0 = mean(vertices_face);
cut(face,normal,x0)

% Centroidal Voronoi Tesselation (CVT): cube-like element
load('mesh_CVT') 
meshes{1,3} = copy(RView(mesh,14,3));

% Voronoi with random seeds location: random element
load('mesh_Voronoi')
meshes{1,4} = copy(RView(mesh,2,3));

for i = 1:size(meshes,2)
    meshes{2,i} = copy(meshes{1,i});
    refine(meshes{2,i},'CNN');
end

row_names = {'initial','refined'};
col_names = {'"tetrahedron"','"prism"','"cube"','"other"'};
boom = true;
figure('Name','CNN_refinement')
my_title = 'CNN refinement based on shape';
plot_meshes(meshes,boom,row_names,col_names,my_title)


%% CNN image
figure('Name','polyhedron_image_3D')
meshes = cell(1,2);
meshes{1,1} = pyramid(3);
boom = false;
col_names = {'initial polyhedron','3D image'};
row_names = {'',''};
my_title = {'CNN input transformation'};
plot_meshes(meshes,boom,row_names,col_names,my_title)
nexttile(2);
img = image3D(meshes{1,1},10);
imshow3D(img)

%% comparison on tetrahderon

meshes = cell(2,3);
for i = 1:size(meshes,2)
    meshes{1,i} = pyramid(3);
    meshes{2,i} = meshes{1,i};
end
refine(meshes{1,1},'diameter');
refine(meshes{1,2},'k-means');
refine(meshes{1,3},'CNN');

row_names = {'refined','exploded'};
col_names = {'diameter','k-means','CNN'};
boom = [false([1,3]);true([1,3])];

figure('Name','strategies_comparison')
my_title = 'Comparison of different refinement strategies';
plot_meshes(meshes,boom,row_names,col_names,my_title)

save_all_figures