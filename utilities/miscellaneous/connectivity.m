function graph = connectivity(mesh,dim)
% graph nodes have the same ordering of mesh elements

graph = RMesh(mesh.dim);

for i = 1:mesh.elem_num(dim+1)
    view = RView(mesh,i,dim);
    c = mean(vertices(view));
    add_new0(graph,c);
end

if dim > 0
    for i = 1:mesh.elem_num(dim) % for every sub-element
        % elements sharing that sub-elem are connected 
        connected = get_share(mesh,i,dim-1);
        n = length(connected);
        for j = 1:(n-1)
            for k = (j+1):n
                link = [connected(j),connected(k)];
                add_new1(graph,link);
            end
        end
    end 
end

end