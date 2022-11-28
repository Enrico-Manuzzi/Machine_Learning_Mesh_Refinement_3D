function couples = opposite(mesh,dim)
if nargin == 1
    dim = manifold(mesh)-1;
end
N = mesh.elem_num(dim+1);
couples = zeros(1,N);
for i = 1:N-1
    if couples(i) == 0
        for j = i+1:N
            face1 = RView(mesh,i,dim);
            face2 = RView(mesh,j,dim);
            if isempty(intersect(face1.loc2glob{1},face2.loc2glob{1}))
                couples(i) = j;
                couples(j) = i;
            end
        end
    end
end
couples = unique(sort([1:N;couples])','row');
end