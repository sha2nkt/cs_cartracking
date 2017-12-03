function [dp_x,dp_y] = LucasKanade(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.
% load('../data/carseq.mat');
% It = frames(:,:,1);
% It = im2double(It);
% It1 = frames(:,:,1);
% It1 = im2double(It1);
% rect = [60;117;146;152];


threshold = 0.01;
nIter = 1000;

%Template
bb_rows_guess = (floor(rect(2)):floor(rect(4)));
bb_columns_guess = (floor(rect(1)):floor(rect(3)));
[t_idx_x, t_idx_y] = meshgrid(bb_columns_guess,bb_rows_guess); 
T = interp2(It,t_idx_x,t_idx_y); %Should apply W(p) after this but since p = 0 no need
%Initial guess
p = [0;0]; %initial guess
 %Calculate gradient in image frame
 [grad_x, grad_y] = gradient(It1);
% imshow(grad_x./(max(grad_x)-min(grad_x))); imshow(grad_y);
dp_y=0; dp_x =0;
for i = 1:nIter
    
    Y = bb_rows_guess+p(2);
    X = bb_columns_guess+p(1);
    [X_interp,Y_interp] = meshgrid(X,Y);
    T_guess = interp2(It1,X_interp,Y_interp); %Guess in template frame  
%     figure,
%     imshow(T_guess);
    D = numel(T_guess);
    glue = eye(2);
    glue = repmat(glue,D,1); 
    %gradient in template frame, then warped   
    
    grad_x_t = interp2(grad_x,X_interp,Y_interp);
%     figure,
%     imshow(grad_x_t./(max(grad_x_t)-min(grad_x_t)))
    
    grad_y_t = interp2(grad_y,X_interp,Y_interp);
%     imshow(grad_y_t./(max(grad_y_t)-min(grad_y_t)))
    grad_x_diag = diag(grad_x_t(:));
    grad_y_diag = diag(grad_y_t(:));
    grad =  grad_x_diag(:,[1;1]*(1:size(grad_x_diag,2)));
    grad(:,2:2:end) = grad_y_diag;
    A = grad*glue;
    b = T-T_guess;
    dp = A\b(:);
    norm(dp)
    p(2) = p(2) + dp(2);
    p(1) = p(1) + dp(1);
    if (norm(dp) < threshold)
        dp_x = p(1);
        dp_y = p(2);
        break;
    end
end



%Generalise D for any p, Edit b to add p