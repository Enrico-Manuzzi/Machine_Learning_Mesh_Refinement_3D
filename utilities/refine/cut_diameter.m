function [n,x0] = cut_diameter(view1)
[n,x0] = plane(farthest_first(vertices(view1),2));
end