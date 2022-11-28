function images = rotation_images(view1,pixels,nrotx)
images = zeros(pixels,pixels,pixels,1,nrotx^3);
idx = 1;
for jx=linspace(360/nrotx,360,nrotx)
    for jy = linspace(360/nrotx,360,nrotx)
        for jz = linspace(360/nrotx,360,nrotx)
            tmp = copy(view1());
            V = vertices(tmp);
            vertices(tmp,V*(rotx(jx)')*(roty(jy)')*(rotz(jz)'));
%             plot(tmp)
%             axis on
            images(:,:,:,:,idx) = image3D(tmp,pixels);
%             imshow3D(X(:,:,:,:,idx))
%             close
            idx = idx + 1;
        end
    end
end
end
