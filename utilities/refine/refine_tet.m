function n_cut = refine_tet(view1)
% try
%     nvert = 4; nquad = 0;
%     shape = meshshape(view1,nvert,nquad);
% catch
%     n_cut = 0;
%     return
% end

try
    V = farthest_robust(vertices(view1),4);
    shape = pyramid(3);
    vertices(shape,V)
catch
    n_cut = 0;
    return
end

% L = length_edges(shape);
% if min(L)/max(L) < 0.5
%     n_cut = cutting_strategy(view1,@cut_tet);
%     return
% end

N = zeros(6,3);
X0 = zeros(6,3);

for i = 1:4
    E = RView(shape,get_share(shape,i,0),1);
    [n,x0] = plane(midpoints(E));
    v = get0(shape,i);
    s = sign((v-x0)*n');
    n = s*n; % outward normal
    N(i,:) = n; X0(i,:) = x0;
end

n_cut = 0;
for i = 1:4
    n_cut = n_cut + apply_cuts(RView(view1,1,3),N(i,:),X0(i,:));
end

if n_cut == 4
    nmax = 2;
    n_cut = n_cut + refine_octa(RView(view1,1,3),nmax);
end

end