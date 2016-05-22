%% This code finds the label assignment for the test set
%% Error rate is 0.6

% load('MNIST_TrainImages.mat')
% [muAll, piAll, noRowsOut, noColsOut]=batchEMLayers(x, 2, 28, 28, 28, 28, 10);
% save 'Layer1_noPatches_28x28_28_28_1x1_Kin2_Kout10_Parameters.mat'
% [y]=winnerTakeAllnoOverlap(x, 28, 28, muAll, 28, 28, 2, piAll, 1, 1);
% y=permute(y, [3 2 1]);
% load('MNIST_TrainLabels.mat')
% [neuronHist, digitHist, neuronLabel]=neuronLabelling(trainLabels, y, (0:9)');
% testNoPatches

load('Experiments/MNIST_TestImages.mat')
load('Experiments/MNIST_TestLabels.mat')
load('Experiments/ResultsNoPatches.mat')

%% Pass through Layer 1
load('Experiments/Layer1_noPatches_28x28_28_28_1x1_Kin2_Kout10_Parameters.mat')
%[y]=winnerTakeAll(x, noRows, noCols, muAll, noRowsPatch, noColsPatch, Kin, piAll, noRowsOut, noColsOut)
[y1out]=winnerTakeAllnoOverlap(xTest, 28, 28, muAll, 28, 28, 2, piAll, 1, 1);

y1out=permute(y1out, [3 2 1]);

noTestPoints=size(xTest, 3);
for i=1:noTestPoints
    labelAssignment(i)=neuronLabel(find(y1out(i,:)));
end

labelAssignment=labelAssignment';
errorRate=(size(find((labelAssignment-testLabels)==0), 1))/noTestPoints;
