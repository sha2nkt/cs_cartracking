% net = alexnet();
v = VideoReader('clip1_stmarc.mp4');
load('bounding_boxes_strmac');
load('netTransfer.mat');
net = netTransfer;
count = 1;
while hasFrame(v)
    im = readFrame(v);
    imshow(im)
    stats = boundingBoxes{1,count};
    count = count + 1;  
    prediction = cell(size(stats,1),1);
    for i = 1:size(stats,1)
        bbox_x = stats(i).BoundingBox(1);
        bbox_width = stats(i).BoundingBox(3);
        bbox_y = stats(i).BoundingBox(2);
        bbox_height = stats(i).BoundingBox(4);
        bbox_img = im(bbox_y:bbox_y+bbox_height,bbox_x:bbox_x+bbox_width,1:3);
        bbox_img = imresize(bbox_img,[227 227]);
        label = predict(net, bbox_img);
        [label_sorted,I] = sort(label);
        prediction(i,1) = net.Layers(25,1).ClassNames(I(end));
        
        %     prediction = cell(3,1);
        %     rectangle('Position',stats(i).BoundingBox,'EdgeColor','r')
        
        
        %     for i = 0:2
        %         prediction(i+1,1) = net.Layers(41, 1).ClassNames(I(end-i));
        %         text(bbox_x+2,bbox_y+10*i,prediction(i+1,1),'Color','g','FontSize',0.1*bbox_height)
        %     end
        
    end
            hold on;

    for i = 1:size(stats,1)
        bbox_x = stats(i).BoundingBox(1);
        bbox_width = stats(i).BoundingBox(3);
        bbox_y = stats(i).BoundingBox(2);
        bbox_height = stats(i).BoundingBox(4);
            rectangle('Position',stats(i).BoundingBox,'EdgeColor','r')
            text(bbox_x+2,bbox_y+10,prediction(i,1),'Color','g','FontSize',0.1*bbox_height);
    end
            hold off;
            pause(0.5);




end




