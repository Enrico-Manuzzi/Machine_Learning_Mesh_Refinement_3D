function mesh = tria2mesh(coord,tria)

mesh = RMesh(3);
for j = 1:size(coord,1)
    add_new0(mesh,coord(j,:));
end

all_edges = [tria(:,[1 2]);tria(:,[1 3]);tria(:,[1 4]);...
             tria(:,[2 3]);tria(:,[2 4]);tria(:,[3 4])];

all_edges = sort(all_edges,2);
[true_edges,~,id_new_edges] = unique(all_edges,"rows");

for j = 1:size(true_edges,1)
    add_new1(mesh,true_edges(j,:));
end

N_tet = size(tria,1);
edges = zeros(N_tet,6);
for j = 1:6
    edges(:,j) = id_new_edges((j-1)*N_tet+(1:N_tet));
end

all_faces = [edges(:,[1 3 5]);
             edges(:,[4 5 6]);
             edges(:,[2 3 6]);
             edges(:,[1 2 4])];

all_faces = sort(all_faces,2);
[true_faces,~,id_new_faces] = unique(all_faces,"rows");

for j = 1:size(true_faces,1)
    add_new2(mesh,true_faces(j,:),2);
end

faces = zeros(N_tet,4);
for j = 1:4
    faces(:,j) = id_new_faces((j-1)*N_tet+(1:N_tet));
end

for j = 1:N_tet
    add_new2(mesh,faces(j,:),3);
end