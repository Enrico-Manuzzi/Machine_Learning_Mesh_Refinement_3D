function mesh = rand_prism(angle)
% load('coarse_hybrid','mesh')
% ids = setdiff(1:10,[5,10]);
% mesh = copy(RView(mesh,ids(randi(length(ids))),3));

if nargin == 0
%     min_angle = 30;
%     max_angle = 120;
%     angle = min_angle + (max_angle-min_angle).*rand;

    angles_list = [60 70 80 90]; % linspace(30,120,4);
    N_angle = length(angles_list);
    angle = angles_list(randi(N_angle));
end
    
mesh = prism(3);
alpha = (180-angle)/2;
t = tan(deg2rad(alpha));
V_tria = [0 0;
          1 t;
         -1 t];

L = norm(V_tria(2,:));
V_tria = V_tria/L;
V = vertices(mesh);
V(1:3,1:2) = V_tria;
V(4:6,1:2) = V_tria;

vertices(mesh,V)
end