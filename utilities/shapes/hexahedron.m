function mesh = hexahedron
mesh = pyramid(3);
p = get0(mesh,4);
p(3) = -p(3);
view = RView(mesh,2:4,2);
pyramid(view,p);
mesh = copy(view);
end