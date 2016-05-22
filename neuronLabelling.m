function[neuronHist, digitHist, neuronLabel]=neuronLabelling(trainLabels, y, yLabels)
%% This code checks the output performance of the trained network
%% Input: 
% trainLabels: (noDataPoints)x1
% y: Output from the inference on trained network: (noDataPoints)xKout (\sum y along dim 2 = 1 cuz WTA)
% yLabels: Array specifying the digit labels used for training:Koutx1 (0 for digit 0, 1 for digit 1 and so on)

%% Output:
% neuronHist: (KoutxKout): dim 1 represents digit, dim2 represents frequency of output label
% digitHist: (KoutxKout): dim 1 represents output label, dim 1 represents frequency of response for every digit

%% Notation: 
% Neurons are labelled from 1 to Kout
% Digits are numbered as digit+1 (0 is 1, 1 is 2 etc)
Kout=size(yLabels, 1);
neuronHist=zeros(Kout, Kout);
digitHist=zeros(Kout, Kout);
for k=1:Kout
    %Calculate frequency of output neuron for a given digit
    neuronHist(k, :)=sum(y(find(trainLabels==(yLabels(k))), :), 1);
end

digitHist=neuronHist';

[neuronVal, neuronLabel]=max(digitHist');
neuronLabel=neuronLabel-1;
