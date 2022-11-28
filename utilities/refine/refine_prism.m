function n_cut = refine_prism(view1)

try
    
nvert = 6; nquad = 3;
shape = meshshape(view1,nvert,nquad);

N = zeros(4,3);
X0 = zeros(4,3);

tria12 = RView(shape,[1,2],2);
vert_egs = setdiff(1:shape.elem_num(2),tria12.loc2glob{2});
E = RView(shape,vert_egs,1);
[N(1,:),X0(1,:)] = plane(midpoints(E));


for i = 3:5 % rectangular faces
    quad = RView(shape,i,2);
    V_egs = setdiff(tria12.loc2glob{2},quad.loc2glob{2});
    E = RView(shape,V_egs,1);
    [n,x0] = plane(midpoints(E));
    v = get0(quad,1);
    s = sign((v-x0)*n');
    n = -s*n; % outward normal
    N(i-1,:) = n; X0(i-1,:) = x0;
end

catch
    n_cut = 0;
    return
end

n_cut = 0;
for i = 2:4
    n_cut = n_cut + apply_cuts(RView(view1,1,3),N(i,:),X0(i,:));
end
n_cut = n_cut + apply_cuts(view1,N(1,:),X0(1,:));


end