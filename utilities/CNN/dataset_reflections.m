function  [X,Y] = dataset_reflections(X,Y)
% Add refelections (new dataset is 8 times the original dataset!)
X(:,:,:,:,end+1:end+size(X,5)) = X(end:-1:1,:,:,:,:);
X(:,:,:,:,end+1:end+size(X,5)) = X(:,end:-1:1,:,:,:);
X(:,:,:,:,end+1:end+size(X,5)) = X(:,:,end:-1:1,:,:);

if nargout == 2
    Y(end+1:end+size(Y,1)) = Y;
    Y(end+1:end+size(Y,1)) = Y;
    Y(end+1:end+size(Y,1)) = Y;
end

end