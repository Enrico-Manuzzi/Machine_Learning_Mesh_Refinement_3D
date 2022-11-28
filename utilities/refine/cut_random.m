function [n,x0] = cut_random(view1)
% function [TF,it] = cut_random(view1)
x0 = mean(vertices(view1));
it = 0;
maxit = 1000;
TF = false;
while it < maxit && not(TF)
    n = randn(1,3);
    n = n/norm(n);
    [n,x0] = adjust_plane(view1,n,x0);
    TF = can_cut(view1,n,x0);
    it = it + 1;
end
% if TF
%     cut(view1,n,x0);
% end
