function mesh = rand_cube
mesh = prism(4);
skew_dir = eye(3); %[eye(3);rand(3,3)];
skew_min = 0.75;
skew_max = 1/skew_min;
N_skew = size(skew_dir,1);
n = skew_dir(randi(N_skew),:);
h = skew_min + (skew_max-skew_min).*rand;
skew(mesh,h,n)
end