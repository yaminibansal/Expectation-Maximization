%% This code finds the label assignment for the test set
%% Error rate is 0.59
clear

load('Experiments/MNIST_TestImages.mat')
load('Experiments/MNIST_TestLabels.mat')
load('Experiments/Results.mat')

%% Pass through Layer 1
load('Experiments/Layer1_nonOverlap_28x28_4x4_7x7_Kin2_Kout10_Parameters.mat')
%[y]=winnerTakeAll(x, noRows, noCols, muAll, noRowsPatch, noColsPatch, Kin, piAll, noRowsOut, noColsOut)
[y1out]=winnerTakeAllnoOverlap(xTest, 28, 28, muAll, 4, 4, 2, piAll, 7, 7);

%% Pass through Layer 2
load('Experiments/Layer2_nonOverlap_7x7_7x7_1x1_Kin10_Kout10_Parameters.mat')
[y2]=winnerTakeAllnoOverlap(y1out, 7, 7, muAll, 7, 7, 10, piAll, 1, 1);

y2=permute(y2, [3 2 1]);

noTestPoints=size(y1out, 3);
for i=1:noTestPoints
    labelAssignment(i)=neuronLabel(find(y2(i,:)));
end

labelAssignment=labelAssignment';
errorRate=(size(find((labelAssignment-testLabels)==0), 1))/noTestPoints;
