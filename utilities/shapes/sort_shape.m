function I_sort = sort_shape(shape)
is_cube = false(1,shape.elem_num(3));
for i = 1:shape.elem_num(3)
    face = RView(shape,i,2);
    is_cube(i) = face.elem_num(1) == 4;
end
[~,I_sort] = sort(is_cube); 
end