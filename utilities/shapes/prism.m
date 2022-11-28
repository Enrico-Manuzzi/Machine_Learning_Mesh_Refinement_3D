function mesh = prism(N)
vert = vertices(polygon(N));
vert = [vert,zeros(N,1);vert,ones(N,1)];
faces = cell(1,N+2);
faces{end} = 1:N; % bottom face
faces{end-1} = (N+1):(2*N); % top face
% add side faces
for i = 1:N
    i_plus = mod(i,N)+1; % N-cyclic index
    faces{i} = [i,i_plus,i_plus+N,i+N];
end
mesh = RMesh(3);
add_poly3D(mesh,vert,faces);
end


function add_poly3D(mesh,vertices,faces)
    Nv = size(vertices,1);
    for i = 1:Nv
        add_new0(mesh,vertices(i,:));
    end
    Nf = length(faces);
    view = RView(mesh,1:Nv,0);
    for i = 1:Nf
        add_poly2D(view,faces{i});
    end
    add_new2(mesh,1:Nf,3);
end