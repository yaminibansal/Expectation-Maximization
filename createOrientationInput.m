function[xData, yData]=createOrientationInput(noDataPoints, noRows, noCols, K, barLength, barWidth, flipProb)
%This function creates a dataset with datapoints = noDataPoints
% noRows, noCols: Rows and columns of the input pixels
% barLength, barWidth: Dimension of bar
% Assumption: 28x28 pixel input

noPixels=noRows*noCols;
width=-barWidth:barWidth;

xData=zeros(noPixels, noDataPoints);
yData=zeros(noDataPoints, 1);

for iter=1:noDataPoints
    orient=randi(181)-91;
    %orient=iter-91;
    
    yData(iter)=orient;
    
    if(orient>=-45 && orient<=45)
        orient=-orient;
        swap=0;
    else if((orient>45 && orient<=90) || (orient>=-90 && orient<-45))
            orient=-(90-orient);
            swap=1;
        end
    end
    
    image=zeros(noRows, noCols);
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
    
    
    %Flipping random pixels
    image_rand=rand(noRows, noCols);
    image_new(image_rand<flipProb)=image_new(image_rand<flipProb)+1;
    image_new(image_new==2)=0;
    
    xData(:,iter)=reshape(image_new, noCols*noRows, 1);    
end