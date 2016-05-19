function[y]=winnerTakeAll(x, noRows, noCols, muAll, noRowsPatch, noColsPatch, Kin, piAll, noRowsOut, noColsOut)

noPatches=size(muAll, 3);
Kout=size(piAll, 1);
noDataPoints=size(x, 3);
epsilon=1e-10; %Preventing mu=0 from making logr NaN

%% Inputs:
% x: Input to first layer (noRows*noCols)x(Kin)x(noDataPoints) (In dimension 2, exactly one is 1, rest are 0)
% [noRows, noCols] = Number of row and column pixels in the input layer
% [noRowsPatch, noColsPatch] = Number of row and column pixels in a patch in the input layer (noPatches=noRowsOut*noColsOut)
% [noRowsOut, noColsOut] = Number of row and column pixels in the output layer
% muAll: Weights (noRowsPatch*noColsPatch*K1)x(K2)x(noPatches) (In dimension 1, sum=1)
% piAll: Priors  (K2)x(noPatches) (In dimension 1, sum=1)

%% Outputs:
% y: Output from second layer (noRowsOut*noColsOut)x(Kout)x(noDataPoints) (In dimension 2, exactly one is 1, rest are 0)
y=zeros(noRowsOut*noColsOut, Kout, noDataPoints);

for i=1:noRowsOut %Row index of output neuron
    for j=1:noColsOut %Column Index of output neuron
        i,j
        % Pixels in input layer corresponding to this output neuron
        xInd=reshape(noRows*ones(noRowsPatch, 1)*(0:noColsPatch-1)+repmat((i:noRowsPatch+i-1)', 1, noColsPatch), noRowsPatch*noColsPatch, 1)+(j-1)*(noRows);
        xTemp=reshape(x(xInd, :, :), noRowsPatch*noColsPatch*Kin, noDataPoints);
        muTemp=muAll(:, :, (i-1)*noColsOut+j);
        logr=(log10(piAll(:, (i-1)*noColsOut+j))*ones(1, noDataPoints)+log10(muTemp'+epsilon)*xTemp)';
        
        % Normalize r
        normFactor=log10(sum(10.^(logr+30), 2))-30;
        normMatrix=normFactor*ones(1, Kout);
        logr=logr-normMatrix;
        r=10.^(logr);
        
        [yVal, yInd]=max(r');
        for n=1:noDataPoints
            y(noRowsOut*(j-1)+i, yInd(n), n)=1;
        end
        
    end
end
        
        