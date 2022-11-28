function imshow3D(img)
pix = size(img,1);
X = zeros(pix,pix,pix);
Y = zeros(pix,pix,pix);
Z = zeros(pix,pix,pix);

X(2:end,:,:) = img(2:end,:,:)-img(1:end-1,:,:);
Y(:,2:end,:) = img(:,2:end,:)-img(:,1:end-1,:);
Z(:,:,2:end) = img(:,:,2:end)-img(:,:,1:end-1);

view(3)
hold on

for i = 1:pix
    for j = 1:pix
        for k = 1:pix
            if X(i,j,k) ~= 0
                plot_cube(i,j,k,'i')
            end
            if Y(i,j,k) ~= 0
                plot_cube(i,j,k,'j')
            end
            if Z(i,j,k) ~= 0
                plot_cube(i,j,k,'k')
            end
        end
    end
end

axis equal
axis off
xlim([1,pix+1])
ylim([1,pix+1])
zlim([1,pix+1])
end

function plot_cube(x,y,z,ijk)
color = 'w';

switch ijk
    case 'k'
        X = [0 0 1 1];
        Y = [0 1 1 0];
        Z = zeros(1,4);
    case 'j'
        Z = [0 0 1 1];
        X = [0 1 1 0];
        Y = zeros(1,4);
    case 'i'
        Y = [0 0 1 1];
        Z = [0 1 1 0];
        X = zeros(1,4);
end

fill3(X+x,Y+y,Z+z,color)
end


% function imshow3D(img)
% pixels = size(img,1);
% [X,Y,Z] = meshgrid(linspace(0+0.5/pixels,1-0.5/pixels,pixels));
% figure
% plot3(X(:),Y(:),Z(:).*img(:),'o')
% axis equal
% xlim([0,1])
% ylim([0,1])
% zlim([0,1])
% end

