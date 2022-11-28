function tria = meshtria(mesh,alpha)

% triangulate polygons
tria = cell(mesh.elem_num(3),1);
for i = 1:mesh.elem_num(3)
    polyview = RView(mesh,i,2);
    [ids,loc_vert] = RM_2poly(polyview);
    tria{i} = triangulation(polyshape(loc_vert,'KeepCollinearPoints',true));
    tria{i} = polyview.loc2glob{1}(ids(tria{i}.ConnectivityList)); % loc2poly = ids
end

if manifold(mesh) > 2
    % triangulate polyhedra
    T_2D = tria;
    tria = cell(1,mesh.elem_num(4));
    for i = 1:mesh.elem_num(4)
    	elem = get2(mesh,i,3);
        T_surf = cell2mat(T_2D(elem));
        h = meshsize(RView(mesh,i,3));
        xyz = vertices(mesh)';
        tria{i} = createpde();
        geometryFromMesh(tria{i},xyz,T_surf');
        generateMesh(tria{i},'GeometricOrder','linear','Hmax',h*alpha);
    end
end

end