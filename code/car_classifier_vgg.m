% net = alexnet();

im = imread('../img1.png');
load('../bounding_box1.mat');
imshow(im);
for i = 1:size(stats,1)
    bbox_x = stats(i).BoundingBox(1);
    bbox_width = stats(i).BoundingBox(3);
    bbox_y = stats(i).BoundingBox(2);
    bbox_height = stats(i).BoundingBox(4);
    bbox_img = im(bbox_y:bbox_y+bbox_height,bbox_x:bbox_x+bbox_width,1:3);
    bbox_img = imresize(bbox_img,[224 224]);   
    label = predict(net, bbox_img);
    [label_sorted,I] = sort(label);
    prediction = cell(3,1);
    rectangle('Position',stats(i).BoundingBox,'EdgeColor','r')

    for i = 0:2
        prediction(i+1,1) = net.Layers(41, 1).ClassNames(I(end-i));
        text(bbox_x+2,bbox_y+10*i,prediction(i+1,1),'Color','g','FontSize',0.1*bbox_height)
    end
    pause(2)
end




