%% EM Algorithm: Mixture of Multinollis
clear all

%% Network Parameters
K=10;
noRows=28;
noCols=28;
noPixels=noRows*noCols;

% MNIST
load('MNIST.mat');
%indices=(find(trainLabels==0 | trainLabels==1 | trainLabels==2 | trainLabels==3));
noDataPoints=size(trainImages,2);%length(indices);
xData=trainImages;%trainImages(:,indices);
yData=trainLabels;%trainLabels(indices);
xData(find(xData))=1;

xTest=testImages;
xTest(find(xTest))=1;
noTestPoints=size(xTest, 2);

noRuns=100;
piVals=zeros(K, noRuns);
muVals=zeros(noPixels, K, noRuns);
outVals=zeros(noTestPoints, noRuns);

for run=1:noRuns
    
    %% Initialization
    pi_k=rand(K,1);                       %pi needs to be a valid probability vector such \sum pi = 1
    pi_k=pi_k/sum(pi_k);
    
    mu=rand(noRows, noCols, K);
    
    r=zeros(noDataPoints, K);
    logr=zeros(noDataPoints, K);
    
    Q=0;
    
    %% Simulation parameters
    noMaxIters=100;
    iter=0;
    epsilon=1e-10;                      %Is added to mu in places where we take log to prevent NaN
    
    
    
    
    
    for iter=1:noMaxIters
        tic
        %iter
        % E-step
        for i=1:noDataPoints
            for k=1:K
                %TODO: Get new datapoint
                x=reshape(xData(:,i), noRows, noCols);
                
                %Update responsibility without normalization
                logr(i,k)=log10(pi_k(k))+sum(sum(x.*log10(mu(1:noRows, 1:noCols, k)+epsilon)+(1-x).*log10(1+epsilon-mu(1:noRows, 1:noCols, k))));
                %r(i, k)=(pi(k)*prod(prod(mu(1:noRows, 1:noCols, k).^(x).*(1-mu(1:noRows, 1:noCols, k)).^(1-x))));
            end
        end
        
        % Normalize r
        normFactor=log10(sum(10.^(logr+30), 2))-30;
        normMatrix=normFactor*ones(1, K);
        logr=logr-normMatrix;
        r=10.^(logr);
        
        % M-step
        pi_k=sum(r, 1)/noDataPoints;
        mu_temp=zeros(noPixels, K);
        for i=1:noDataPoints
            %TODO: Get new datapoint
            x_temp=xData(:,i);
            mu_temp=mu_temp+x_temp*r(i, :);
        end
        mu=reshape(mu_temp./(ones(noPixels,1)*sum(r, 1)), noRows, noCols, K);
        
        Q(iter)=sum(r*log(pi_k')+sum(xData'*reshape(log(mu+epsilon), noRows*noCols, K)+(1-xData')*reshape(log(1+epsilon-mu), noRows*noCols, K),2));
        
        %TODO: Add a break condition
        if(iter>1 && abs((Q(iter)-Q(iter-1))/Q(iter-1))<0.001)
            iter, Q(iter)
            break
        end
        
    toc    
    end
    
    %% Testing
    
    
    testDist=(normc(reshape(mu, noPixels, K))'*normc(xTest));
    [mVal, outLabel]=max(testDist);
    outLabel=outLabel';
    
    piVals(:,run)=pi_k;
    muVals(:,:,run)=reshape(mu, noPixels,K);
    outVals(:,run)=outLabel;
    
end

toc

figure(1)
subplot(2, 5, 1)
imagesc(mu(:,:,1))
subplot(2, 5, 2)
imagesc(mu(:,:,2))
subplot(2, 5, 3)
imagesc(mu(:,:,3))
subplot(2, 5, 4)
imagesc(mu(:,:,4))
subplot(2, 5, 5)
imagesc(mu(:,:,5))
subplot(2, 5, 6)
imagesc(mu(:,:,6))
subplot(2, 5, 7)
imagesc(mu(:,:,7))
subplot(2, 5, 8)
imagesc(mu(:,:,8))
subplot(2, 5, 9)
imagesc(mu(:,:,9))
subplot(2, 5, 10)
imagesc(mu(:,:,10))
%
% subplot(2, 2, 1)
% imagesc(mu(:,:,1))
% subplot(2, 2, 2)
% imagesc(mu(:,:,2))
% subplot(2, 2, 3)
% imagesc(mu(:,:,3))
% subplot(2, 2, 4)
% imagesc(mu(:,:,4))
colormap gray

% Generating histogram of labels obtained for every digit
figure(2)
for i=0:9
check=find(testLabels==i);
output=outVals(check, 1);
subplot(2,5,i+1)
hist(output)
end
print('MNISTLabel.png', '-dpng', '-r300');

% Generating histograms of the digits for every output neuron
figure(3)
for i=1:10
check=find(outVals(:,1)==i);
output=testLabels(check);
subplot(2,5,i)
hist(output)
end
print('MNISTCluster.png', '-dpng', '-r300');




