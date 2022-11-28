function n_cut = cutting_strategy(view1,cut_fun,nmax,TOL)
dim = manifold(view1);
h0 = meshsize(view1);
if nargin < 3
    nmax = dim;
end
if nargin < 4
    TOL = h0/2;
end

to_cut = zeros(1,2^nmax);
to_cut(1) = 1;
n_cut = 0;
for i = 1:nmax
    [~,hvect] = meshsize(view1);
    big_to_cut = intersect(to_cut,find(hvect > TOL));
    if isempty(big_to_cut)
        break
    end
    for j = big_to_cut 
        elem = RView(view1,j,dim);
        [n,x0] = cut_fun(elem);
        ok = apply_cuts(elem,n,x0);
        if ok
            n_cut = n_cut + 1;
            to_cut(n_cut+1) = view1.elem_num(dim+1); 
        else
            to_cut(j) = [];
        end
         
    end
end
end