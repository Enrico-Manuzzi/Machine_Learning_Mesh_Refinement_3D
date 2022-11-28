function mesh = pyramid(N)
if N > 5
    h = 1;
else
    h = sqrt((2*sin(pi/N))^2-1);
end
poly = polygon(N);
vert = vertices(poly);
v = mean(vert);
point = [v,h*norm(vert(1,:)-v)];
mesh = RMesh(3);
base_view = merge(RView(mesh),poly);
pyramid(base_view,point);
end


