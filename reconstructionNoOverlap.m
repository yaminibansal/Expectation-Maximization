function[]=reconstructionNoOverlap(x, y, muAll, noRows, noCols, noRowsPatch, noColsPatch, noRowsOut, noColsOut, fig)

xRecon=zeros(noRows, noCols);
noPatches=size(y, 1);

for i=1:noPatches
    iPatch=ceil(i/noColsOut);
    jPatch=((mod(i, noColsOut)==0)*noColsOut+(mod(i, noColsOut)~=0)*(mod(i, noColsOut)));
    muInd=find(y((jPatch-1)*noRowsOut+iPatch,:));
    xRecon((iPatch-1)*noRowsPatch+1:(iPatch)*noRowsPatch, (jPatch-1)*noColsPatch+1:(jPatch)*noColsPatch)=reshape(muAll(1:noRowsPatch*noColsPatch, muInd, i), noRowsPatch, noColsPatch);
end

figure(fig)
subplot(1, 2, 1)
imagesc(reshape(x(1:noRows*noCols), noRows, noCols))
colormap gray

subplot(1, 2, 2)
imagesc(xRecon)
colormap gray
