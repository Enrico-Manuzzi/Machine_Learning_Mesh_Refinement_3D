clear, clc, close all
rng('default')

%% dataset generation
pix = 16;
class_samples = 1000;
labels = {'tetrahedron','prism','cube','other'};
version = [num2str(pix),'pix'];
N_classes = length(labels);
N_samples = N_classes * class_samples;

% labels generation
Y = cell(N_samples,1);
for i = 1:N_classes
    idx = (i-1)*class_samples;
    Y(idx+(1:class_samples)) = labels(i);
end
Y = categorical(Y);

% 3D images generation
X = zeros(pix,pix,pix,1,N_samples);
for i = 1:N_classes
    display(['Generating samples for class ',labels{i}])
    switch labels{i}
        case 'tetrahedron'
            mesh_list = cell(2,1);
            load('mesh_Delaunay.mat')
            mesh_list{1} = copy(mesh);
            mesh_list{2} = copy(pyramid(3));
        case 'prism'
            mesh_list = cell(2,1);
            load('mesh_prisms.mat')
            mesh_list{1} = copy(mesh);
            mesh_list{2} = copy(prism(3));
        case 'cube'
            mesh_list = {copy(prism(4))};
        case 'other'
            load('mesh_Voronoi.mat')
            mesh_list = {copy(mesh)};
    end
    N_meshes = length(mesh_list);
    for j = 1:class_samples
        mesh = mesh_list{randi(N_meshes)};
        elem = copy(RView(mesh,randi(mesh.elem_num(end)),3));
        n = rand(1,3); n = n/norm(n);
        h = 0.4*rand+0.8;
        skew(elem,h,n);
        V = rotatepoint(randrot,vertices(elem));
        vertices(elem,V);
        X(:,:,:,:,(i-1)*class_samples+j) = image3D(elem,pix);
    end
end

%%  Partition dataset
idx = splitlabels(Y,[0.6 0.2],'randomized');
XTrain = X(:,:,:,:,idx{1});
YTrain = Y(idx{1});
XValidation = X(:,:,:,:,idx{2});
YValidation = Y(idx{2});
XTest = X(:,:,:,:,idx{3});
YTest = Y(idx{3});

save([path2('CNN'),'Data_',version],'labels',...
    'XTrain','YTrain','XValidation','YValidation','XTest','YTest')

%% network architecture

feature_maps = 8;
layers = [
    image3dInputLayer([pix pix pix 1])
    %%%
    convolution3dLayer(8,feature_maps,'Padding','same')
    batchNormalizationLayer
    reluLayer
    averagePooling3dLayer(2,'Stride',2)
    %%%
    convolution3dLayer(4,feature_maps,'Padding','same')
    batchNormalizationLayer
    reluLayer
    averagePooling3dLayer(2,'Stride',2)
    %%%
    convolution3dLayer(2,feature_maps,'Padding','same')
    batchNormalizationLayer
    reluLayer
    averagePooling3dLayer(2,'Stride',2)
    %%%
    fullyConnectedLayer(N_classes)
    softmaxLayer
    classificationLayer];

%% train and test the network

options = trainingOptions('adam', ...
    'OutputNetwork','best-validation-loss',...
    'MaxEpochs',100, ...
    'Shuffle','every-epoch', ...
    'Plots','none',... % none, training-progress
    'Verbose',true, ...
    'ValidationData',{XValidation,YValidation});

[net,info] = trainNetwork(XTrain,YTrain,layers,options);
save([path2('CNN'),'CNN_',version],'net','info')

output = classify(net,XTest);
target = YTest;
fig = plotconfusion(target,output);
fig.Name = 'confusion_matrix';
save_all_figures
