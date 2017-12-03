images = imageDatastore('../train',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');
net = vgg16();
inputSize = net.Layers(1).InputSize(1:2)
images.ReadFcn = @(loc)imresize(imread(loc),inputSize);
car_classifier_pretrained(net,images)