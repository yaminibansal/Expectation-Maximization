%% Assuming:
% Square patches
% Square feature maps

clear
load('MNISTPatches5x510K576patchesWeightsPriors.mat')
load('MNIST.mat')

noRows=28;
noCols=28;

indices=(find(trainLabels==0 | trainLabels==1 | trainLabels==2 | trainLabels==3 | trainLabels==4));
noDataPoints=length(indices);
xTestTemp=trainImages(:,indices);
xTestTemp(find(xTestTemp))=1;
xTestTemp=reshape(xTestTemp, noRows, noCols, noDataPoints);
epsilon=1e-10;

patchSize=size(muAll, 1)^0.5;
K1=size(piAll, 1);            %Number of feature maps: 11
N1=size(muAll, 3);              %Number of neurons per feature map: 576
N1sqrt=N1^0.5;
xData2=zeros(K1, N1, noDataPoints);


for iImg=1:noDataPoints
tic
iImg
for nPatch=1:N1
    iPatch=ceil(nPatch/N1sqrt);
    jPatch=((mod(nPatch, N1sqrt)==0)*N1sqrt+(mod(nPatch, N1sqrt)~=0)*(mod(nPatch, N1sqrt)));
    %muAll(:,:,nPatch)
    %reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, 1), 16, 1)
    temp2(1:(K1), nPatch)=log10(piAll(:,nPatch))+log10(muAll(:,:,nPatch)'+epsilon)*reshape(xTestTemp(iPatch:iPatch+patchSize-1, jPatch:jPatch+patchSize-1, iImg), patchSize*patchSize, 1)+log10(1+epsilon-muAll(:,:,nPatch)')*(1-reshape(xTestTemp(iPatch:iPatch+patchSize-1, jPatch:jPatch+patchSize-1, iImg), patchSize*patchSize, 1));
end

normFactor=log10(sum(10.^(temp2+30), 2))-30;
normMatrix=ones(1, 10)*normFactor;
temp2norm=temp2-normMatrix;
temp2fin=10.^(temp2norm);


[temp2Val, temp2Ind]=max(temp2fin);

for nPatch=1:N1
    iPatch=ceil(nPatch/N1sqrt);
    jPatch=((mod(nPatch, N1sqrt)==0)*N1sqrt+(mod(nPatch, N1sqrt)~=0)*(mod(nPatch, N1sqrt)));
    %if(sum(reshape(xTestTemp(iPatch:iPatch+patchSize-1, jPatch:jPatch+patchSize-1, iImg), patchSize*patchSize, 1))==0) %This is incorrect
     %   xData2(K1, nPatch, iImg)=1;
    %else
        xData2(temp2Ind(nPatch), nPatch, iImg)=1;
    %end
end

recon=zeros(28, 28);
%Reconstruct with patches
for nPatch=1:N1
    iPatch=ceil(nPatch/N1sqrt);
    jPatch=((mod(nPatch, N1sqrt)==0)*N1sqrt+(mod(nPatch, N1sqrt)~=0)*(mod(nPatch, N1sqrt)));
    if(temp2Val(nPatch)~=0)
        recon(iPatch:iPatch+patchSize-1, jPatch:jPatch+patchSize-1)=reshape(muAll(:,temp2Ind(nPatch), nPatch), patchSize, patchSize);
    end
end
toc
end

xData2=permute(xData2, [2 1 3]);

figure(1)
ax1=subplot(1, 2, 1);
imagesc(xTestTemp(:,:,iImg))
colormap gray
pbaspect([1 1 1])
subplot(1, 2, 2);
imagesc(recon)
colormap gray
pbaspect([1 1 1])



