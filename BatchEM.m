%% EM Algorithm: Mixture of Multinollis
clear all

load CompleteOrientationInputs.mat
%% Network Parameters
K=10;
noRows=28;
noCols=28;
noPixels=noRows*noCols;
DataPoints=[500, 1000, 2000, 5000, 10000];
noRuns = 50;
piVals=zeros(K, noRuns, length(DataPoints));
muVals=zeros(noRows*noCols*K, noRuns, length(DataPoints));
initPi=zeros(K, noRuns, length(DataPoints));
initMu=zeros(noRows*noCols*K, noRuns, length(DataPoints));
classAcc=zeros(noRuns, length(DataPoints));
outputDist=zeros(181*K, noRuns, length(DataPoints));

for iData=1:length(DataPoints)
    for run = 1:noRuns
        tic
        noDataPoints=DataPoints(iData);
        run, noDataPoints
        
        %% Initialization
        pi_k=rand(K,1);                       %pi needs to be a valid probability vector such \sum pi = 1
        pi_k=pi_k/sum(pi_k);
        initPi(:,run, iData)=pi_k;
        
        mu=rand(noRows, noCols, K);
        initMu(:,run, iData)=reshape(mu, noRows*noCols*K, 1);
        
        r=zeros(noDataPoints, K);
        logr=zeros(noDataPoints, K);
        
        Q=0;
        
        %% Simulation parameters
        noMaxIters=100;
        iter=0;
        epsilon=1e-10;                      %Is added to mu in places where we take log to prevent NaN
        
        %% Create data
        % Gaussian
%         hiddenParams=[14, 8;
%             16, 22;
%             9, 15;
%             20, 14];
%         hiddenPriors=[0.1;
%             0.2;
%             0.3;
%             0.4];
%         sigma=10^0.5;
%         [xData, yData]=createGaussianInput(noRows, noCols, K, hiddenParams, sigma, hiddenPriors, noDataPoints);
%         
        
        %% Orientation
        barLength=8;
        barWidth=3;
        flipProb=0.01;
        
        [xData, yData]=createOrientationInput(noDataPoints, noRows, noCols, K, barLength, barWidth, flipProb);
        
        % % MNIST
        % load('MNIST.mat');
        % xData=reshape(trainImages(1:noDataPoints,:,:), noDataPoints, size(trainImages, 2)*size(trainImages, 3))';
        % yData=trainLabels(1:noDataPoints);
        % xData(find(xData))=1;
        
        
        for iter=1:noMaxIters
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
            normFactor=log10(sum(10.^(logr+300), 2))-300;
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
                %iter, Q(iter)
                break
            end
            
            
        end
        
        QVals(run, iData)=Q(end);
        piVals(:,run, iData)=pi_k;
        muVals(:,run, iData)=reshape(mu, noRows*noCols*K, 1);
        itersForConv(run, iData)=iter;
        piTemp=sort(piVals(:,run,iData));
        if(((piTemp(1)-0.1)^2+(piTemp(2)-0.1)^2+(piTemp(3)-0.1)^2+(piTemp(4)-0.1)^2+(piTemp(5)-0.1)^2+(piTemp(6)-0.1)^2+(piTemp(7)-0.1)^2+(piTemp(8)-0.1)^2+(piTemp(9)-0.1)^2+(piTemp(10)-0.1)^2)<1e-3)
            classAcc(run,iData)=1;
        end
        
        for inOrient=1:181
            for kx=1:K
                outputDist((inOrient-1)*K+kx, run, iData)=reshape(mu(:,:,kx),1,noPixels)*xDataTest(:,inOrient)/(norm(reshape(mu(:,:,kx),1,noPixels))*norm(xDataTest(:,inOrient)));
            end
        end
        
        toc
        
    end
end

errorRate=sum(classAcc, 1)/noRuns;

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

% subplot(2, 2, 1)
% imagesc(mu(:,:,1))
% subplot(2, 2, 2)
% imagesc(mu(:,:,2))
% subplot(2, 2, 3)
% imagesc(mu(:,:,3))
% subplot(2, 2, 4)
% imagesc(mu(:,:,4))
colormap gray





