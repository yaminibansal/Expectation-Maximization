function[y_seq, Hvar_seq, Indices]=y_stoch_orient(barLength, barWidth, flipProb, trivialThresh, N_pixCols, N_pixRows, N_states, NoPatPres)

N= N_pixRows*N_pixCols*N_states;
y_seq=zeros(N, NoPatPres);
Hvar_seq=zeros(NoPatPres, 1);

Indices = removeTrivial(N_pixCols, N_pixRows, barLength, barWidth, trivialThresh);
width=-barWidth:barWidth;

%Orientations=[-81:18:81];

for t=1:NoPatPres
    orient=randi(181)-91;
    %orient=Orientations(randi(10));
    Hvar_seq(t)=orient;
    
    if(orient>=-45 && orient<=45)
        orient=-orient;
        swap=0;
    else if((orient>45 && orient<=90) || (orient>=-90 && orient<-45))
            orient=-(90-orient);
            swap=1;
        end
    end
    image=zeros(N_pixRows, N_pixCols);
    image_neg=zeros(N_pixRows, N_pixCols);
    ind=0;
    len=-abs(round(cos(orient*pi/180)*barLength)):abs(round(cos(orient*pi/180)*barLength));
    y=zeros(length(width), length(len));
    
    
    count=1;
    
    for j=1:length(width)
        y(j,:)=round(tan(orient*pi/180)*len)-width(j);
        y=y+14;
        for i=1:length(len)
            row=len(i)+14;
            if(swap==0)
                ind(count)=28*row+y(j,i);
            else
                ind(count)=28*y(j,i)+row;
            end
            count=count+1;
        end
    end
    
    image(ind)=1;
    h=fspecial('gaussian', [3 3]);
    image_new=imfilter(image, h);
    
    image_new(image_new>=0.75)=1;
    image_new(image_new<1)=0;
    
    image_neg(image_new==1)=0;
    
    %Flipping random pixels
    image_rand=rand(N_pixRows, N_pixCols);
    image_new(image_rand<flipProb)=image_new(image_rand<flipProb)+1;
    image_new(image_new==2)=0;
    image_neg(image_rand<flipProb)=image_neg(image_rand<flipProb)-1;
    image_neg(image_neg==-1)=1;

    %Setting trivial neurons to zero current
    image_new(Indices)=0;
    image_neg(Indices)=0;
    
    temp=[reshape(image_new, N_pixCols*N_pixRows, 1); reshape(image_neg, N_pixCols*N_pixRows, 1)];
    y_seq(:,t)=temp;
end








% 
% 
% 
% 
% 
% 
% 
% 
% %Sample the orientation from a uniform distribution
% image_sum=0;
% image_sum_new=0;
% T=16;
% Indices=ones(28, 28);
% Indices_new=ones(28, 28);
% lengthAll=12;
% width=-2:2;
% orientAll=74:90;
% for time=1:T
%     %orient=randi(181)-91;
%     orient=orientAll(time);
%     orient_seq(time)=orient;
%     
%     if(orient>=-45 && orient<=45)
%         orient=-orient;
%         swap=0;
%     else if((orient>45 && orient<=90) || (orient>=-90 && orient<-45))
%             orient=-(90-orient);
%             swap=1;
%         end
%     end
%     
%     image=zeros(28, 28);
%     ind=0;
%     len=-abs(round(cos(orient*pi/180)*lengthAll)):abs(round(cos(orient*pi/180)*lengthAll));
%     y=zeros(length(width), length(len));
%     
%     
%     count=1;
%     
%     for j=1:length(width)
%         
%         y(j,:)=round(tan(orient*pi/180)*len)-width(j);
%         y=y+14;
%         for i=1:length(len)
%             row=len(i)+14;
%             if(swap==0)
%                 ind(count)=28*row+y(j,i);
%             else
%                 ind(count)=28*y(j,i)+row;
%             end
%             count=count+1;
%         end
%     end
%     
%     image(ind)=1;
%     
%     h=fspecial('gaussian', [3 3]);
%     image_new=imfilter(image, h);
%     
%     
%     % figure(3)
%     % subplot(10, 10, time)
%     % imagesc(image_new)
%     % colormap gray
%     % axis equal
%     
%     image_new(image_new>=0.75)=1;
%     image_new(image_new<1)=0;
%     
%     
%     
%     image_sum_new=image_sum_new+image_new;
%     image_sum=image_sum+image;
%     
%     % figure(1)
%     % subplot(10, 10, time)
%     % imagesc(image)
%     % colormap gray
%     % axis equal
%     %
%     figure(2)
%     subplot(4, 4, time)
%     imagesc(image_new)
%     colormap gray
%     axis equal
%     
%     
% end
% 
% % figure(4)
% % image_sum=image_sum/T;
% % Indices(image_sum<0.04)=0;
% % imagesc(Indices)
% % 
% % figure(5)
% % image_sum_new=image_sum_new/T;
% % Indices_new(image_sum_new<0.04)=0;
% % imagesc(Indices_new)
