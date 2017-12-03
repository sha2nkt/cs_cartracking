frames = [];
% for i = 1:9
%     im = imread(['../frames/img000',num2str(i),'.jpg']);
%     im = rgb2gray(im);
%     frames = cat(3,frames,im);
% end
for i = 20:60
    im = imread(['../frames/img00',num2str(i),'.jpg']);
    im = rgb2gray(im);
    frames = cat(3,frames,im);
end
save('frames.mat','frames');
