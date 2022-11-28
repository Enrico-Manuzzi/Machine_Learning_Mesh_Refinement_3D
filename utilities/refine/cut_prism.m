function [n,x0] = cut_prism(view1)
try
    nvert = 6; nquad = 3;
    shape = meshshape(view1,nvert,nquad);
catch
    [n,x0] = cut_random(view1);
    return
end

N = zeros(3,3);
X0 = zeros(3,3);
L = zeros(1,4);

tria12 = RView(shape,[1,2],2);
vert_egs = setdiff(1:shape.elem_num(2),tria12.loc2glob{2});
E = RView(shape,vert_egs,1);
[N(1,:),X0(1,:)] = plane(midpoints(E));
L(1) = max(length_edges(E));

for i = 3:5 % rectangular faces
    quad = RView(shape,i,2);
    I_egs = intersect(tria12.loc2glob{2},quad.loc2glob{2});
    eg1 = setdiff(1:9,[tria12.loc2glob{2},quad.loc2glob{2}]);
    E = RView(shape,I_egs,1);
    E1 = RView(shape,eg1,1);
    L(i-1) = max(length_edges(E));
    [N(i-1,:),X0(i-1,:)] = plane([midpoints(E);vertices(E1)]);
end
[~,I] = max(L);
n = N(I,:); x0 = X0(I,:);
end