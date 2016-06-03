function[muAll, piAll, noRowsOut, noColsOut, Q]=batchEMLayers(x, Kin, noRows, noCols, noRowsPatch, noColsPatch, Kout)

%% This function performs Expectation Maximization with a Multinolli model
%% Inputs:
% x: Training Data (noRows*noCols)x(Kin)x(noDataPoints) (In dimension 2, exactly one is 1, rest are 0)
% Kin: Multinolli states of the input neurons i.e. No. of input feature maps (for binary data Kin=2)
% Kout: Multinolli states of the out neurons i.e. No. of output feature maps
% noRows: Number of row pixels in the input
% noCols: Number of column pixels in the input
% noRowsPatch: Number of row pixels in a patch (noRowsPatch divides noRows)
% noColsPatch: Number of column pixels in a patch (noColsPatch divides noCols)

%% Outputs:
% muAll: Weights (noRowsPatch*noColsPatch*K1)x(K2)x(noPatches) (In dimension 1, sum=1)
% piAll: Priors  (K2)x(noPatches) (In dimension 1, sum=1)

noDataPoints=size(x, 3);
noPixels=noRows*noCols;

% If non-overlapping patches
% if(ceil(noRows/noRowsPatch)~=floor(noRows/noRowsPatch))
%     error('No. of rows in patch doesnt divide total no. of rows.')
% else
%     noRowsOut=(noRows/noRowsPatch);
% end
%
% if(ceil(noCols/noColsPatch)~=floor(noCols/noColsPatch))
%     error('No. of columns in patch doesnt divide total no. of columns.')
% else
%     noColsOut=(noCols/noColsPatch);
% end

noRowsOut=(noRows-noRowsPatch+1);
noColsOut=(noCols-noColsPatch+1);

noPatches=noRowsOut*noColsOut;

% Initializing output variables
muAll=zeros(noRowsPatch*noColsPatch*Kin, Kout, noPatches);
piAll=zeros(Kout, noPatches);

% Input data manipulation
xTemp=reshape(x, noRows, noCols, Kin, noDataPoints);

% Moving patchwise
count=0;
for iPatch=1:noRows-noRowsPatch+1
    for jPatch=1:noCols-noColsPatch+1
        tic
        iPatch, jPatch
        count=count+1;
        xData=xTemp(iPatch:iPatch+noRowsPatch-1, jPatch:jPatch+noColsPatch-1,:,:);
        
        %% Initialization
        pi_k=rand(1,Kout);                       %pi needs to be a valid probability vector such \sum pi = 1
        pi_k=pi_k/sum(pi_k);
        mu=rand(noRowsPatch, noColsPatch, Kin, Kout);
        %Normalizing mu across dim 3
        mu=permute(mu, [1 2 4 3]);
        mu=reshape(mu, noRowsPatch*noColsPatch*Kout, Kin);
        mu=mu./(sum(mu, 2)*ones(1, Kin));
        mu=reshape(mu, noRowsPatch, noColsPatch, Kout, Kin);
        mu=permute(mu, [1 2 4 3]);
        
        r=zeros(noDataPoints, Kout);
        logr=zeros(noDataPoints, Kout);
        %Q=0;
        
        %% Simulation parameters
        noMaxIters=100;
        iter=0;
        epsilon=1e-50;                      %Is added to mu in places where we take log to prevent NaN
        
        for iter=1:noMaxIters
            % E step:
%            iter
%             for i=1:noDataPoints
%                 for k=1:Kout
%                     xPatch=xData(:,:,:,i);
%                     %Update responsibility without normalization
%                     logr(i,k)=log10(pi_k(k))+sum(sum(sum(xPatch.*log10(mu(:, :, :, k)+epsilon))));
%                 end
%             end
            logr=ones(noDataPoints, 1)*log10(pi_k)+reshape(xData, noRowsPatch*noColsPatch*Kin, noDataPoints)'*log10(reshape(mu, noRowsPatch*noColsPatch*Kin, Kout)+epsilon);
            
            % Normalize r
            normFactor=log10(sum(10.^(logr+30), 2))-30;
            normMatrix=normFactor*ones(1, Kout);
            logr=logr-normMatrix;
            r=10.^(logr);
            
            % M-step
            pi_k=sum(r, 1)/noDataPoints;
            mu_temp=reshape(xData, noRowsPatch*noColsPatch*Kin, noDataPoints)*r;
            mu=reshape(mu_temp./(ones(noRowsPatch*noColsPatch*Kin,1)*sum(r, 1)), noRowsPatch, noColsPatch, Kin, Kout);

            %Break condition
            Q(count, iter)=sum(r*log(pi_k'))+sum(sum(r'*(reshape(xData, noRowsPatch*noColsPatch*Kin, noDataPoints)'*reshape(log(mu+epsilon), noRowsPatch*noColsPatch*Kin, Kout))));
%             if(iter>1 && abs((Q(count, iter)-Q(count, iter-1))/Q(count, iter-1))<0.001)
%                 break
%             end
            toc
            
        end
        
        muAll(:, :, count)=reshape(mu, noRowsPatch*noColsPatch*Kin, Kout);
        piAll(:, count)=pi_k;
        iterConv(count)=iter;
        
        
    end
end
toc



