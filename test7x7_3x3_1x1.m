%% 0.6956
% Input Layer: 28x28 K=2 | x
% Non-overlapping patches of 7x7 
% Hidden Layer 1: 4x4 K=60 | y1
% Overlapping patches of 2x2
% Hidden Layer 2: 3x3 K=30
% All neuron
% Output Layer: 1 K=10

cd ../../
load('/home/Guest/Documents/MATLAB/Yamini DDP/Expectation-Maximization/Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer2_Overlapping_4x4_2x2_3x3_Kin60_Kout30_eps1neg50_run2_Params.mat')
load('/home/Guest/Documents/MATLAB/Yamini DDP/Expectation-Maximization/Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer1_nonOverlapping_28x28_7x7_4x4_Kin2_Kout60_eps1neg50_run2_Output.mat')
[y2]=winnerTakeAll(y, 4, 4, muAll, 2, 2, 60, piAll, 3, 3);
[muAll3, piAll3, noRowsOut, noColsOut, Q]=batchEMLayers(y2, 30, 3, 3, 3, 3, 10);
[y3]=winnerTakeAll(y2, 3, 3, muAll3, 3, 3, 30, piAll3, 1, 1);
y3=permute(y3, [3 2 1]);
load('/home/Guest/Documents/MATLAB/Yamini DDP/Expectation-Maximization/Experiments/MNIST_TrainLabels.mat')
[neuronHist, digitHist, neuronLabel]=neuronLabelling(trainLabels, y3, (0:9)');

load('/home/Guest/Documents/MATLAB/Yamini DDP/Expectation-Maximization/Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer1_nonOverlapping_28x28_7x7_4x4_Kin2_Kout60_eps1neg50_run2.mat')
load('Experiments/MNIST_TestImages.mat')
load('Experiments/MNIST_TestLabels.mat')
muAll=muAll(:,:,200,:);
muAll=permute(muAll, [1 2 4 3]);
muAll(:,:,:,2)=1-muAll(:,:,:,1);
muAll=permute(muAll, [1 4 2 3]);
muAll=reshape(muAll, 98, 60, 16);

piAll=permute(piAll(:,200,:), [1 3 2]);

y1Test=winnerTakeAllnoOverlap(xTest, 28, 28, muAll, 7, 7, 2, piAll, 4, 4);

load('/home/Guest/Documents/MATLAB/Yamini DDP/Expectation-Maximization/Experiments/Exp 4 Non-Overlapping 7x7 patches/Layer2_Overlapping_4x4_2x2_3x3_Kin60_Kout30_eps1neg50_run2_Params.mat')
[y2Test]=winnerTakeAll(y1Test, 4, 4, muAll, 2, 2, 60, piAll, 3, 3);
[y3Test]=winnerTakeAll(y2Test, 3, 3, muAll3, 3, 3, 30, piAll3, 1, 1);
y3Test=permute(y3Test, [3 2 1]);

noTestPoints=size(y2Test, 3);
for i=1:noTestPoints
    labelAssignment(i)=neuronLabel(find(y3Test(i,:)));
end
labelAssignment=labelAssignment';
errorRate=(size(find((labelAssignment-testLabels)==0), 1))/noTestPoints

