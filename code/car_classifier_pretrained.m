function car_classifier_pretrained(net,images)





%% Network specification - Transfer is effected here 

[trainingImages,validationImages] = splitEachLabel(images,0.7,'randomized');
layersTransfer = net.Layers(2:end-3);
numClasses = numel(categories(trainingImages.Labels));
% random fliplr applied to input layer in vgg.net
inputLayer = imageInputLayer([224,224,3],'Name','input','DataAugmentation','randfliplr',...
    'Normalization','zerocenter');
    
layers = [
    inputLayer
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];
miniBatchSize = 10;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',4,...
    'InitialLearnRate',1e-4,...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',validationImages,...
    'ValidationFrequency',numIterationsPerEpoch);
%% Training
netTransfer = trainNetwork(trainingImages,layers,options);

%% Prediction on the validation set
predictedLabels = classify(netTransfer,validationImages);
idx = [1 5 10 15];
figure
for i = 1:numel(idx)
    subplot(2,2,i)
    I = readimage(validationImages,idx(i));
    label = predictedLabels(idx(i));
    imshow(I)
    title(char(label))
end
%% Classification Accuracy
valLabels = validationImages.Labels;
accuracy = mean(predictedLabels == valLabels)