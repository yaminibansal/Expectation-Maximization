function[xData, yData]=createGaussianInput(noRows, noCols, K, hiddenParams, sigma, hiddenPriors, noDataPoints)
%This function creates a dataset with datapoints = noDataPoints
% noRows, noCols: Rows and columns of the input pixels
% hiddenParams: Centre of the gaussian for all K latent variables
% hiddenPriors: Prior probability of each K latent variable
% sigma: Standard Dev of the gaussian input produced

hiddenPriorsCDF=cumsum(hiddenPriors);
noPixels=noRows*noCols;
sigmaSq=sigma^2;
NoOn=200;

xData=zeros(noPixels, noDataPoints);
yData=zeros(noDataPoints, 1);

for i=1:noDataPoints
    hiddenVar=rand(1);
    for k=1:K
        if(hiddenVar<=hiddenPriorsCDF(k))
            yData(i)=k;
            break
        end
    end
    
    pixRand=rand(noRows, noCols);
    pixVal=zeros(noRows, noCols);
    [X, Y]=meshgrid(1:noCols, 1:noRows); %[1 2 3...; 1 2 3; ..]
    
    pixProb=exp(-((X-hiddenParams(yData(i), 2)).^2+(Y-hiddenParams(yData(i), 1)).^2)/(2*sigmaSq));
%    pixProbNorm=(1/(2*pi*sigmaSq))*pixProb;
%    pixProbNorm2=NoOn*pixProbNorm/sum(sum(pixProbNorm, 1));
    pixVal([pixRand<=pixProb])=1;
    
    xData(:,i)=reshape(pixVal, noPixels, 1);
    
end

end