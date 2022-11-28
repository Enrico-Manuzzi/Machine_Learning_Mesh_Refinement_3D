% function coarse_mesh = agglomerate(fine_mesh,new_elem)
% coarse_mesh = RMesh(3);
% view = RView(coarse_mesh);
% N = length(new_elem);
% for i = 1:N
% 	agglom = copy(boundary(RView(fine_mesh,new_elem{i},3)));
%     add_new2(agglom,1:agglom.elem_num(3),3);
%     merge(view,agglom);
% end
% end

function coarse_mesh = agglomerate(fine_mesh,new_elem)
N = length(new_elem);
for i = N:-1:1
%     (N-i+1)/N
	agglom{i} = copy(boundary(RView(fine_mesh,new_elem{i},3)));
    add_new2(agglom{i},1:agglom{i}.elem_num(3),3);
end

all_coord = [];
for i = 1:N
    all_coord = [all_coord;vertices(agglom{i})];
end
[true_coord,~,id_new_coord] = unique(all_coord,"rows");

coarse_mesh = RMesh(3);
for j = 1:size(true_coord,1)
    add_new0(coarse_mesh,true_coord(j,:));
end

all_edges = [];
count_vert = 0;
for i = 1:N
    E = edges(agglom{i});
    E = E + count_vert;
    E = id_new_coord(E);
    all_edges = [all_edges;E];
    count_vert = count_vert + agglom{i}.elem_num(1);
end

all_edges = sort(all_edges,2);
[true_edges,~,id_new_edges] = unique(all_edges,"rows");

for j = 1:size(true_edges,1)
    add_new1(coarse_mesh,true_edges(j,:));
end

all_faces = [];
count_edges = 0;
for i = 1:N
    F = [];
    for j = 1:agglom{i}.elem_num(3)
        F = [F;get2(agglom{i},j,2)];
    end
    F = F + count_edges;
    F = id_new_edges(F);
    all_faces = [all_faces;F];
    count_edges = count_edges + agglom{i}.elem_num(2);
end


all_faces = sort(all_faces,2);
[true_faces,~,id_new_faces] = unique(all_faces,"rows");


for j = 1:size(true_faces,1)
    add_new2(coarse_mesh,true_faces(j,:),2);
end

count_faces = 0;
for i = 1:N
    elem = get2(agglom{i},1,3);
    elem = elem + count_faces;
    elem = id_new_faces(elem)';
    add_new2(coarse_mesh,elem,3);
    count_faces = count_faces + agglom{i}.elem_num(3);
end


end