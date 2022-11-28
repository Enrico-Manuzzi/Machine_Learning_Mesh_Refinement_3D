function [n,x0] = adjust_plane(mesh,n,x0)

TOL = meshsize(mesh)*0.1;
V = vertices(mesh);
dist = abs((V-x0)*n');
P = V(dist<TOL,:);

switch rank(P-x0,mesh.tol*mesh.dim)
    case 0
        % do nothing
        return
    case 1
        % x0 and other points line on a line        
        if size(P,1) == 1
            x0 = P;
            return
        else            
            z = P(1,:)-x0;
            z = z/norm(z);
            m = n - dot(z,n)*z;
            m = m/norm(m);
            y0 = x0;
        end
    case 2
        [m,y0] = plane([x0;P]);
    otherwise
        [~,I] = sort(dist(dist<TOL));
        P = P(I,:);
        i = 3;
        N = size(P,1);
        while i < N && rank(P(2:i,:)-P(1,:),mesh.tol*mesh.dim) < 2 
            i = i+1;
        end
        [m,y0] = plane(P(1:i,:));
end

prod = dot(n,m);
if abs(prod) > cos(deg2rad(10))
    n = m*sign(prod);
    x0 = y0;
end
end