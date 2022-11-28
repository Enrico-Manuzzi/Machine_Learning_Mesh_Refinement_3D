function [n,x0] = cut_kmeans(view1)
pixels = 20;
tight = true;
[~,points] = image3D(view1,pixels,view1.convex,tight);
if size(points,1) < 2
    points = vertices(view1);
end
[~,c] = kmeans(points,2);
n = (c(2,:)-c(1,:))/norm(c(2,:)-c(1,:));
x0 = mean(c);
end