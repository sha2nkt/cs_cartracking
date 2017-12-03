clc
clear all
close all

% your code here
load('frames.mat');
im = frames(:,:,2);
figure, imshow(im);
rect = getrect(figure(1)); 
rectangle('Position',[rect],'EdgeColor','y','LineWidth',2);
rect(3) = rect(1)+rect(3);
rect(4) = rect(2)+rect(4);
rect1 = rect;
w = rect(3)-rect(1);
h = rect(4)-rect(2);

I1 = frames(:,:,1);
I1 = im2double(I1);
carseqrects_wcrt = zeros(size(frames,3),4);
for i = 1:size(frames,3)-1
    carseqrects_wcrt(i,:) = rect; 
    It = frames(:,:,i);
    It = im2double(It);
    It1 = frames(:,:,i+1);
    It1 = im2double(It1);
    %run Lukas Kanade using strategy 2 to get pn
    [M] = LucasKanadeAffine(It, It1, rect);
    p_n = [dp_x;dp_y];
    % Correct the template out of strategy 2 by feeding it to strategy 1
    % and correcting
    rect = [rect(1)+dp_x;rect(2)+dp_y;rect(3)+dp_x;rect(4)+dp_y];
    % This takes rect updated by LK strategy 2
    [dp_star_x, dp_star_y] = LucasKanade_strategy1(I1, It1, rect, rect1); 
    rect = [rect(1)+dp_star_x;rect(2)+dp_star_y;rect(3)+dp_star_x;rect(4)+dp_star_y];
          
        w = rect(3)-rect(1);
        h = rect(4)-rect(2);        
        hold on;
        imshow(It1);
        rectangle('Position',[rect(1),rect(2),w,h],'EdgeColor','y','LineWidth',2);
        pause(1);
        hold off;
   
end
carseqrects_wcrt(i+1,:) = rect;
save('carseqrects-wcrt.mat','carseqrects_wcrt');