function[]=reconsPatches(muAll, piAll, x, y, n, noRowsOut, noColsOut, noRowsPatch, noColsPatch)
%% This function plots the selected filters from the second layer for a given digit for each patch

%% Inputs:
% x: Input to first layer (noRows*noCols)x(Kin)x(noDataPoints) (In dimension 2, exactly one is 1, rest are 0)
% muAll: Weights (noRowsPatch*noColsPatch*K1)x(K2)x(noPatches) (In dimension 1, sum=1)
% piAll: Priors  (K2)x(noPatches) (In dimension 1, sum=1)
% y: Output from second layer (noRowsOut*noColsOut)x(Kout)x(noDataPoints) (In dimension 2, exactly one is 1, rest are 0)
% n: DataPoint index

count=0;

for i=1:noRowsOut
    for j=1:noColsOut
        count=count+1;
        subplot(noRowsOut, noColsOut, count)
        imagesc(reshape(muAll(1:noRowsPatch*noColsPatch, find(y(noRowsOut*(j-1)+i,:,n)), count), noRowsPatch, noColsPatch))
        colormap gray
    end
end



