clear
load('MNISTPatches4x410KSimulationResults.mat')
load('MNIST.mat')
xTestTemp=trainImages;
xTestTemp(find(xTestTemp))=1;
xTestTemp=reshape(xTestTemp, 28, 28, 60000);


iImg=randi(60000, 1, 1);

for nPatch=1:49
    nPatch
    iPatch=(ceil(nPatch/7)-1)*4+1;
    jPatch=((mod(nPatch, 7)==0)*7+(mod(nPatch, 7)~=0)*(mod(nPatch, 7))-1)*4+1;
    %muAll(:,:,nPatch)
    %reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, 1), 16, 1)
    temp1(1:10, nPatch)=muAll(:,:,nPatch)'*reshape(xTestTemp(iPatch:iPatch+3, jPatch:jPatch+3, iImg), 16, 1);
end

[temp2Val, temp2Ind]=max(temp1);

recon=zeros(28, 28);
%Reconstruct with patches
for nPatch=1:49
    iPatch=(ceil(nPatch/7)-1)*4+1;
    jPatch=((mod(nPatch, 7)==0)*7+(mod(nPatch, 7)~=0)*(mod(nPatch, 7))-1)*4+1;
    if(temp2Val(nPatch)~=0)
        recon(iPatch:iPatch+3, jPatch:jPatch+3)=reshape(muAll(:,temp2Ind(nPatch), nPatch), 4, 4);
    end
    
end


figure(1)
imagesc(xTestTemp(:,:,iImg))
colormap gray

figure(3)
imagesc(recon)
colormap gray