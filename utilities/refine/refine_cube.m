function n_cut = refine_cube(view1)
try
    nvert = 8; nquad = 6;
    shape = meshshape(view1,nvert,nquad);
catch
    n_cut = 0;
    return
end

N = zeros(3,3);
X0 = zeros(3,3);
couples = opposite(shape);
if any(couples(:) == 0)
    n_cut = 0;
    return
end
for i = 1:3
    f12 = RView(shape,couples(i,:),2);
    E = RView(shape,setdiff(1:12,f12.loc2glob{2}),1);
    [N(i,:),X0(i,:)] = plane(midpoints(E));
end

n_cut = apply_cuts(view1,N,X0);

end