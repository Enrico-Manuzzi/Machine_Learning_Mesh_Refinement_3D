function [mesh,ids_clust] = voromesh(view1,seeds)
% view1 must contain only 1 element
mesh = RMesh(view1.dim);
N_seeds = size(seeds,1);
ids_clust = 1:N_seeds;
dim = manifold(view1);
dtol = view1.tol*view1.dim;
% voro_view = RView(voro_mesh);
for i = 1:N_seeds
    elem = copy(view1);   
    s1 = seeds(i,:);
    for j = setdiff(1:N_seeds,i)
        s2 = seeds(j,:);
        n = (s2-s1)/norm(s2-s1);
        x0 = (s1+s2)/2;
        if all((vertices(elem)-x0)*n' > -dtol)
            elem = RMesh(view1.dim);
            ids_clust(i) = 0;
            break
        end
        cut(elem,n,x0);
        new_elem = RView(elem,1,dim);
        elem = copy(new_elem);  
    end
    voro_view = boundary(mesh);
    merge(voro_view,elem);
end
ids_clust(ids_clust == 0) = [];
end