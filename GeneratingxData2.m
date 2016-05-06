clear
load('MNISTPatches4x410KSimulationResults.mat')
load('MNIST.mat')
xTestTemp=trainImages;
xTestTemp(find(xTestTemp))=1;
xTestTemp=reshape(xTestTemp, 28, 28, 60000);
epsilon=1e-10;

xData2=zeros(11, 49, 60000);


for iImg=1:60000
tic
iImg
for nPatch=1:49
    iPatch=(ceil(nPatch/7)-1)*4+1;
    jPatch=((mod(nPatch, 7)==0)*7+(mod(nPatch, 7)~=0)*(mod(nPatch, 7))-1)*4+1;
    %muAll(:,:,nPatch)
    %reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, 1), 16, 1)
    temp1(1:10, nPatch)=muAll(:,:,nPatch)'*reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, iImg), 16, 1);
    temp2(1:10, nPatch)=log10(piAll(:,nPatch))+log10(muAll(:,:,nPatch)'+epsilon)*reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, iImg), 16, 1)+log10(1+epsilon-muAll(:,:,nPatch)')*(1-reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, iImg), 16, 1));
end

normFactor=log10(sum(10.^(temp2+30), 2))-30;
normMatrix=ones(1, 10)*normFactor;
temp2norm=temp2-normMatrix;
temp2fin=10.^(temp2norm);


[temp1Val, temp1Ind]=max(temp1);
[temp2Val, temp2Ind]=max(temp2fin);

for nPatch=1:49
    iPatch=(ceil(nPatch/7)-1)*4+1;
    jPatch=((mod(nPatch, 7)==0)*7+(mod(nPatch, 7)~=0)*(mod(nPatch, 7))-1)*4+1;
    if(sum(reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, iImg), 16, 1))==0)
        xData2(11, nPatch, iImg)=1;
    else
        xData2(temp2Ind(nPatch), nPatch, iImg)=1;
    end
end

recon=zeros(28, 28);
%Reconstruct with patches
for nPatch=1:49
    iPatch=(ceil(nPatch/7)-1)*4+1;
    jPatch=((mod(nPatch, 7)==0)*7+(mod(nPatch, 7)~=0)*(mod(nPatch, 7))-1)*4+1;
    if(temp2Val(nPatch)~=0)
        recon(iPatch:iPatch+3, jPatch:jPatch+3)=reshape(muAll(:,temp2Ind(nPatch), nPatch), 4, 4);
    end
end
toc
end


figure(1)
ax1=subplot(1, 2, 1);
imagesc(xTestTemp(:,:,iImg))
colormap gray
pbaspect([1 1 1])
subplot(1, 2, 2);
imagesc(recon)
colormap gray
pbaspect([1 1 1])



