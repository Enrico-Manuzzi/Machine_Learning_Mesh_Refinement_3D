function [img,points] = image3D(view1,pix,convex,tight)
if nargin < 3
    convex = view1.convex;
end
if nargin < 4
    tight = false;
end

vert = vertices(view1);

if not(tight)
    c = conv_centr(vertices(view1));
    R = max(vecnorm(vert-c,2,2)); % R = max(vecnorm(vert-c,inf,2));
    R = R*(1-1/pix); % to center pixels with linspace
    x = linspace(c(1)-R,c(1)+R,pix);
    y = linspace(c(2)-R,c(2)+R,pix);
    z = linspace(c(3)-R,c(3)+R,pix);
else
    m = min(vert);
    M = max(vert);
    x = linspace(m(1),M(1),pix);
    y = linspace(m(2),M(2),pix);
    z = linspace(m(3),M(3),pix);
end

if convex
    [X,Y,Z] = meshgrid(x,y,z);
    points = [X(:),Y(:),Z(:)];
    img = is_inside(view1,points,convex);
    points = points(img,:);
    img = 1*reshape(img,[pix,pix,pix]);
else
    [X,Y]= meshgrid(x,y);
    points = [X(:),Y(:),z(3)*ones(pix^2,1)];
    [~,~,t_list] = inside_fun(view1,points);
    img = zeros(pix,pix,pix);
    for j = 1:pix
        for i =1:pix
            t = t_list(i+(j-1)*pix,:);
            t(isnan(t)) = [];
            t = uniquetol(t,view1.tol);
            line = zeros(1,pix);
            a = t(1:end-1)+z(3);
            b = t(2:end)+z(3);
            line(any(a<=z' & z'<=b,2)) = 1;
            img(i,j,:) = line;
        end
    end

    [X,Y,Z]= meshgrid(x,y,z);
    points = [X(:),Y(:),Z(:)];
    points = points(logical(img(:)),:);
end
end

function [TFin,TFon,t_list] = inside_fun(view1,points)
% view1 must contain only ONE element

dim = manifold(view1);
if dim == 0
    TFin = vecnorm(points - get0(view1,1),inf,2) < view1.tol;
    TFon = TFin;
    return
end

N = size(points,1);
done = false(1,N);
TFin = false(1,N);
TFon = false(1,N);
toldim = view1.tol*view1.dim;
vert =  vertices(view1);
v0 = vert -  vert(1,:);
p0 = points - vert(1,:);
rv0 = rank(v0,toldim);
if dim < 3
    for j = 1:N
        % if point is not on element plane
        done(j) =  rv0 < rank([v0;p0(j,:)],toldim);
    end

    if all(done)
        return
    end
end

I = find(not(done));
N = length(I);

if dim == 3
    v = [0 0 1];
else
    % find random direction from point inside the element plane
    w = rand(1,view1.elem_num(1));
    v = w/sum(w)*v0;
    % should check that v is not zero and not parallel to any element face
    % but these events have 0 probability
end

t_list = nan(N,view1.elem_num(dim)); % line = t*v+point

for i = 1:view1.elem_num(dim) % for each element face
    face = RView(view1,i,dim-1);
    vert = vertices(face);

    % face on the new origin --> face plane = vertices combination
    p0 = points(I,:) - vert(1,:);
    v0 = vert(2:end,:) - vert(1,:);

    % v-line from p0 : t*v + p0 = v0'*x : face plane
    % p0 = [vert;v]'*[x;-t] = A*y

    if rank([v0;v],toldim) == dim
        q = nan(N,view1.dim);
        for j = 1:N
            y = [v0;v]'\p0(j,:)';
            t_list(j,i) = -y(end);
            q(j,:) = t_list(j,i)*v + points(I(j),:); % intersection line-plane
        end
        t_list(not(inside_fun(face,q)),i) = nan;
    end
    uon = abs(t_list(:,i)) < view1.tol;
    TFon(I(uon)) = true;
    TFin(I(uon)) = true;
    done(I(uon)) = true;
end

if all(done)
    return
end

for j = find(not(done(I)))
    % using the list of intersections along the line
    % find if the point is inside the element
    t = t_list(j,:);
    t(isnan(t)) = [];
    if not(isempty(t_list(j,:)))
        t = uniquetol(t,view1.tol);
        ID = find(t > 0, 1, 'first');
        TFin(I(j)) = not(isempty(ID)) && (mod(ID,2)==0);
    end
end

end
