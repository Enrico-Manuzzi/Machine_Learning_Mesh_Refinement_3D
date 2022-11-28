function [n,x0] = cut_tet(tet)
shape = pyramid(3);
V = farthest_robust(vertices(tet),4);
vertices(shape,V)
[~,I] = max(length_edges(shape));
E = RView(shape,I,1);
left_vert = setdiff(1:4,E.loc2glob{1});
P = [midpoints(E);V(left_vert,:)];
[n,x0] = plane(P);
end