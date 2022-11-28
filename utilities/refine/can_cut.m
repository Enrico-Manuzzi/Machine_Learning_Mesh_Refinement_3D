function TF = can_cut(mesh,n,x0)

dim = manifold(mesh);

% n*(x-x0) = 0
% clust1 -n-> clust2
dtol = mesh.tol*mesh.dim;
vert = vertices(mesh);
clust = zeros(1,mesh.elem_num(1));
clust(n*(vert-x0)' < -dtol) = 1;
clust(n*(vert-x0)' > +dtol) = 2;

% User constraint: a plane must cut something!
% if mesh is already on one side of the plane just return
if not(all(ismember([1,2],clust)))
    TF = false;
    return
end

% no face on the plane
% (I need the normal to decide if it goes into cluter 1 or 2)
for i = 1:mesh.elem_num(3)
    face = RView(mesh,i,2);
    if all(clust(face.loc2glob{1}) == 0)
        TF = false;
        return
    end 
end

% AVOID ILL-SHAPED ELEMENTS by forbidding too small edges
% VEM constraint: no small egdes or faces!

egs = edges(mesh);
ids = find(clust(egs(:,1))~=clust(egs(:,2)));
v1 = get0(mesh,egs(ids,1));
v2 = get0(mesh,egs(ids,2));
% plane: n*(x-x0) = 0
% line: x = (v2-v1)*t + v1
% dot((v2-v1)*t+v1-x0,n) = 0 --> t = dot(x0-v1,n)/dot(v2-v1,n)
t = ((x0-v1)*n') ./ ((v2-v1)*n');
c = (v2-v1).*t + v1;
L = [vecnorm(c-v1,inf,2);vecnorm(c-v2,inf,2)];

L = [L;abs((vert-x0)*n')];
Lmin = meshsize(mesh)*10^-3;
if any(L < Lmin & L > mesh.tol)
   TF = false;
   return
end


TF = true;
if mesh.convex
    return
end


% Geometrical constraint: element boundary must not touch itself!
% points on the plane must be separating 2 clust
% otherwise they touch the cutting plane
egs = edges(mesh);
for i = find(clust == 0)
    links = any(egs==i,2);
    if not(all(ismember([1 2],clust(egs(links,:)))))
       TF = false;
       return
    end
end

% Code constraint: one cut can produce only 2 elements and not 3 or more!
for d = 2:dim
    for i = 1:mesh.elem_num(d+1)
    	view = RView(mesh,i,d);
        view_clust = clust(view.loc2glob{1});
        egs = edges(view);
        for j = 1:2
            c = RView(view,find(all(view_clust(egs) == j,2)),1);
            % lonely points(*): 2-2-(1)-2-2-1-1
            n_lonely = nnz(view_clust == j) - c.elem_num(1);
            [~,n_clust] = clusters(connectivity(c,1));
            if n_lonely + n_clust > 1
                TF = false;
                return
            end
        end
    end
end

end
