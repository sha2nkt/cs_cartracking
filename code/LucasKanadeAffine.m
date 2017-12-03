function M = LucasKanadeAffine(It, It1, rect)

% input - image at time t, image at t+1 
% output - M affine transformation matrix

threshold = 0.7;
nIter = 30;

%Template
T_rows = (floor(rect(2)):floor(rect(4)));
T_columns = (floor(rect(1)):floor(rect(3)));
[t_idx_x, t_idx_y] = meshgrid(T_columns,T_rows); 
T = interp2(It,t_idx_x,t_idx_y);
%Initial guess
p = zeros(6,1); 
%Calculate gradient in image frame
[grad_x, grad_y] = gradient(It1);
dp = zeros(6,1);
for i = 1:nIter   
    A=[];
    M = [1+p(1),p(2),p(3);p(4),1+p(5),p(5);0,0,1];
    rect1 = M*[rect(1),rect(3);rect(2),rect(4);1,1];
    rect1 = rect1./rec1(3,:);
    rect1 = rect1(:);
    Tguess_rows = (floor(rect1(2)):floor(rect1(4)));
    Tguess_columns = (floor(rect1(1)):floor(rect1(3)));
    [tguess_idx_x, tguess_idx_y] = meshgrid(Tguess_columns,Tguess_rows); 
    Tguess = interp2(It1,tguess_idx_x,tguess_idx_y);
    Y = 1:size(It1,1);
    X = 1:size(It1,2);
    [X_interp,Y_interp] = meshgrid(X,Y);
    px_warped = M*[X_interp(:)';Y_interp(:)';ones(1,size(X_interp(:),1))];
    px_warped = px_warped./px_warped(3,:);
    X_warped = reshape(px_warped(1,:),size(It1));
    Y_warped = reshape(px_warped(2,:),size(It1));
    It1_warped = interp2(It1,X_warped,Y_warped);
    grad_x_w = interp2(grad_x,X_warped,Y_warped);
    grad_y_w = interp2(grad_y,X_warped,Y_warped);

    
    T_guess = It1_warped(~isnan(It1_warped));
    T_vec = T(~isnan(It1_warped));
    T_vec = T_vec(:);
    X_warped_vec = X_warped(~isnan(It1_warped));
    Y_warped_vec = Y_warped(~isnan(It1_warped));

    T_guess_vec = T_guess(:);
    grad_x_w_vec = grad_x_w(~isnan(grad_x_w));
    grad_x_w_vec = grad_x_w_vec(:);
    grad_y_w_vec = grad_y_w(~isnan(grad_y_w));
    grad_y_w_vec = grad_y_w_vec(:);
           
    grad_vec =  [grad_x_w_vec,grad_y_w_vec];
%     glue_1_row = [X_warped(:),Y_warped(:),ones(size(X_warped(:),1),1),zeros(size(X_warped(:),1),3)];
%     glue_2_row = [zeros(size(X_warped(:),1),3),X_warped(:),Y_warped(:),ones(size(X_warped(:),1),1)];
%     glue = glue_1_row([1;1]*(1:size(glue_1_row,1)),:);
%     glue(2:2:end,:) = glue_2_row;
    A = [grad_vec(:,1).*X_warped_vec,grad_vec(:,1).*Y_warped_vec,grad_vec(:,1),...
        grad_vec(:,2).*X_warped_vec,grad_vec(:,2).*Y_warped_vec,grad_vec(:,2)];
%     for j = 1:size(grad_vec,1)
%         A(j,:) = grad_vec(j,:)*glue((2*j-1):(2*j),:);
%     end
    b = T_vec-T_guess_vec;
    dp = A\b;
    norm(dp)
    p = p + dp;    
    if (norm(dp) < threshold)
        M = [1+p(1),p(2),p(3);p(4),1+p(5),p(5);0,0,1];
        break;
    end
end
M = [1+p(1),p(2),p(3);p(4),1+p(5),p(5);0,0,1];


%Generalise D for any p, Edit b to add p