function [failed,ref_time,labels] = refine(mesh,method,elem_ids)
if nargin < 3
    elem_ids = 1:mesh.elem_num(4);
end

if strcmp(method,'CNN')
	load('CNN_16pix','net');
end

N = length(elem_ids);
labels = categorical([]);
failed = false(1,N);
tic
for j = 1:N
    % fprintf('%4.2f \n',j/N)
    elem = RView(mesh,elem_ids(j),3);
    switch method
        case 'cube'
            n_cut = refine_cube(elem);
        case 'prism'
            n_cut = refine_prism(elem);
        case 'tetrahedron'
            n_cut = refine_tet(elem);
        case 'diameter'
            n_cut = cutting_strategy(elem,@cut_diameter);
        case 'k-means'                
            n_cut = cutting_strategy(elem,@cut_kmeans);
        case 'CNN'
            [n_cut,labels(j)] = CNN_refine(elem,net);
    end
        
    if n_cut == 0
        failed(j) = true;
        n_cut = cutting_strategy(elem,@cut_kmeans);
%         n_cut = cutting_strategy(elem,@cut_random);
        if n_cut == 0
%         if not(cut_random(elem))
            error('Cannot refine')
        end
    end
end
ref_time = toc;
% figure
% histogram(labels)
end