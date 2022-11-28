function failed = test_Euler(mesh)
failed = [];
for i = 1:mesh.elem_num(4)
    elem = RView(mesh,i,3);
    F = elem.elem_num(3);
    E = elem.elem_num(2);
    V = elem.elem_num(1);
    if not(F+V-E==2)
        failed = [failed,i];
    end
end
end