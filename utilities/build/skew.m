function skew(mesh,h,n)
V = vertices(mesh);
c = conv_centr(V);
V = V - c;
%%%
n = n/norm(n);
v1 = rand(1,3);
v1 = v1-dot(n,v1)*n;
v1 = v1/norm(v1);
v2 = cross(n,v1);
v2 = v2/norm(v2);
%%%
Q = [n',v1',v2'];
A = Q*diag([h 1 1])*Q';
vertices(mesh,V*A'+c)
end