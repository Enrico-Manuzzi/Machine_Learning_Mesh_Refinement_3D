function ref_mesh = reflections(mesh)
mesh_list = reflections_fun(mesh);
ref_mesh = RMesh(3);
view = RView(ref_mesh);
for i = 1:length(mesh_list)
    merge(view,mesh_list{i});
end
end

function list = reflections_fun(mesh)
% mesh in [0,1]^3
list = cell(1,8);
list{1} = copy(mesh);
for i = 1:3
    list{i+1} = copy(mesh);
    vert = vertices(mesh);
    vert(:,i) = -vert(:,i);
    vertices(list{i+1},vert)
end
for i = 5:8
    list{i} = copy(list{i-4});
end
for i = 5:8
    scale(list{i},-1);
end
for i = 1:8 % [-1,1]^3 --> [0,1]^3 
    scale(list{i},0.5);
    move(list{i},0.5);
end
end