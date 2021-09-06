clear all; clc;
%% load data
load('Data_13_del');
%% describe neural network
hiddenSizes = [20];
trainFcn = 'trainbr';
net = fitnet(hiddenSizes, trainFcn);
net.inputs{1}.processFcns = {'removeconstantrows'};
net.outputs{2}.processFcns = {'removeconstantrows'};
net.layers{2}.transferFcn = 'poslin';
net.divideFcn = 'divideind';
[trainInd,valInd,testInd] = divideind(4095,601:3480,1:600,3481:4095);
net.divideParam.trainInd=trainInd;
net.divideParam.valInd=valInd;
net.divideParam.testInd=testInd;
net = train(net, input, output);
view(net);
y = net(input);
% figure(1)
% plot(input(1,:))
% figure(2)
% plot(input(2,:))
% figure(3)
% plot(input(3,:))
% figure(4)
% plot(input(4,:))
figure(5)
plot(output)
hold on
plot(y)
plot(output)
% save('NN51','net')
% gensim(net)
%% Test 