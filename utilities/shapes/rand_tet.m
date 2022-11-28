function mesh = rand_tet
% load('coarse_tetra','mesh')
% ids = 1:mesh.elem_num(4);
% mesh = copy(RView(mesh,ids(randi(length(ids))),3));


mesh = pyramid(3);

if randi(2) == 2
    V = [0 0 0;1 0 0;0.5 0.5 0;0.5 0 0.5];
    vertices(mesh,V)
end

V = vertices(mesh);
h = meshsize(mesh);
V = V + randn(4,3)*h*0.1;
vertices(mesh,V);
end