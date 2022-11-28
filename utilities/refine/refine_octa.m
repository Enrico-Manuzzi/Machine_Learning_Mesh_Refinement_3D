function n_cut = refine_octa(view1,nmax)
if nargin < 2
    nmax = 3;
end

try
    nvert = 6; nquad = 0;
    shape = meshshape(view1,nvert,nquad);
catch
    n_cut = 0;
    return
end

for i = 1:nvert
    if length(shape.share{1}{i})~=4
        n_cut = 0;
        return 
    end
end

N = zeros(3,3);
X0 = zeros(3,3);
L = zeros(1,3);
couples = opposite_vert(shape);
if any(couples(:) == 0)
    n_cut = 0;
    return
end
vert = vertices(shape);
for i = 1:3
    v12 = vert(couples(i,:),:);
    L(i) = norm(v12(1,:)-v12(2,:));
    v_left = vert(setdiff(1:6,couples(i,:)),:);
    [N(i,:), X0(i,:)] = plane(v_left);
end
[~,I] = sort(L,'descend');
n_cut = 0;
for i = I
    n_cut = n_cut + apply_cuts(view1,N(i,:),X0(i,:));
    if n_cut == nmax
        break
    end
end

end

function couples = opposite_vert(mesh)
N = mesh.elem_num(1);
couples = zeros(1,N);
for i = 1:N-1
    if couples(i) == 0
        for j = i+1:N
            E1 = get_share(mesh,i,0);
            E2 = get_share(mesh,j,0);
            if isempty(intersect(E1,E2))
                couples(i) = j;
                couples(j) = i;
            end
        end
    end
end
couples = unique(sort([1:N;couples])','row');
end