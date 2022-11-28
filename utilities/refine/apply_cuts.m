function n_cut = apply_cuts(mesh,N,X0)
n_cut = 0;
for i = 1:size(N,1)
    n = N(i,:);
    x0 = X0(i,:);
    [n,x0] = valid_plane(mesh,n,x0);
    if can_cut(mesh,n,x0)
        cut(mesh,n,x0)
        n_cut = n_cut + 1;
    end
end
end