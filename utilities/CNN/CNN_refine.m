function [n_cut,label] = CNN_refine(view1,net)
if view1.elem_num(1) == 4
    label = 'tetrahedron';
else
    label = CNN_classify(view1,net);
end

switch label
    case 'cube'
        n_cut = refine_cube(view1);
    case 'prism'
        n_cut = refine_prism(view1);
    case 'tetrahedron'
        n_cut = refine_tet(view1);
    case 'other'
        n_cut = cutting_strategy(view1,@cut_kmeans);
end

end