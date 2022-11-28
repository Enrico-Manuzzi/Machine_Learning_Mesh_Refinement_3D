function label = CNN_classify(view1,net)
if nargin < 2
    load('CNN_16pix.mat','net')
end

tmp = copy(view1);
V = rotatepoint(randrot,vertices(tmp));
vertices(tmp,V)

pixels = net.Layers(1).InputSize(1);
img = image3D(tmp,pixels,true);
label = classify(net,img);
end