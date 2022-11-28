function mesh = octahedron
mesh = pyramid(4);
p = get0(mesh,5);
p(3) = -p(3);
view = RView(mesh,2:5,2);
pyramid(view,p);
mesh = copy(view);
end