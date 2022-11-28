function [n_val,x0_val] = valid_plane(mesh,n,x0)
it = 0;
maxit = 1000;
TF = false;
h = meshsize(mesh);
x0_val = x0;
n_val = n;
while it < maxit && not(TF)
	switch it
        case 0
            theta = 0; % max new angle difference
            H = 0; % mean x0 difference
        case 1
            theta = deg2rad(10); 
            H = h*0.1;
	end
    
    x0_val = x0 + H*randn(1,3);
    np = randn(1,3); % random vector
    np = np - dot(np,n)*n; % on the plane
    np = tan(theta)*rand*np/norm(np); 
    n_val = n + np;
    n_val = n_val/norm(n_val);
        
%         if dot(n_val,n) < cos(theta)
%             error('angle!')
%         end
        
%         plot3(n(1),n(2),n(3),'o')
%         hold on
%         plot3(n_val(1),n_val(2),n_val(3),'^')
%         plot3(0,0,0,'x')
%         axis equal
%         ok = 1;
%     end
    
    [n_val,x0_val] = adjust_plane(mesh,n_val,x0_val);
    TF = can_cut(mesh,n_val,x0_val);
    it = it + 1;
end
if not(TF)
    warning('No valid cut found')
end
