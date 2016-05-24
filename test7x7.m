%% This code finds the label assignment for the test set
% Error Rate 0.592
% Unable to assign a label to 8 and 9
clear

load('Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer1_nonOverlap_28x28_7x7_4x4_Kin2_Kout30_Parameters.mat')
load('Experiments/MNIST_TrainImages.mat')
[y1]=winnerTakeAllnoOverlap(x, 28, 28, muAll, 7, 7, 2, piAll, 4, 4);

[muAll, piAll, noRowsOut, noColsOut]=batchEMLayers(y1, 30, 4, 4, 4, 4, 10);
save('Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer2_nonOverlap_4x4_4x4_1x1_Kin30_Kout10_Parameters.mat', 'muAll', 'piAll')
[y2]=winnerTakeAllnoOverlap(y1, 4, 4, muAll, 4, 4, 10, piAll, 1, 1);


[neuronHist, digitHist, neuronLabel]=neuronLabelling(trainLabels, permute(y2, [3 2 1]), (0:9)');
load('Experiments/MNIST_TestImages.mat')
load('Experiments/MNIST_TestLabels.mat')
load('Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer1_nonOverlap_28x28_7x7_4x4_Kin2_Kout30_Parameters.mat')
[y1out]=winnerTakeAllnoOverlap(xTest, 28, 28, muAll, 7, 7, 2, piAll, 4, 4);
load Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer2_nonOverlap_4x4_4x4_1x1_Kin30_Kout10_Parameters.mat
load 'Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer2_nonOverlap_4x4_4x4_1x1_Kin30_Kout10_Parameters.mat'
[y2]=winnerTakeAllnoOverlap(y1out, 4, 4, muAll, 4, 4, 30, piAll, 1, 1);
y2=permute(y2, [3 2 1]);
noTestPoints=size(y1out, 3);
for i=1:noTestPoints
    labelAssignment(i)=neuronLabel(find(y2(i,:)));
end
labelAssignment=labelAssignment';
errorRate=(size(find((labelAssignment-testLabels)==0), 1))/noTestPoints
