# Supervise learning for single landing gear with MR damper.
## Structure of Neural Network
![This is the structure of Neural Network](/NN_structure.png)
## Analysis Data
```
clear all;clc;
%% Reshape into input data and label
%% data 1-9 m1=170kg; data 10-37 m1 = 150-190-230kg;
%% data 38-45 m1=210kg
ndata=45;% Number of data
n = 330;% Length of data
n1 = [1446,1216,1308,1285,2224,1396,1242,2067,1603,...
    1232,1081,1203,1304,1925,1445,1246,1700,1488,...
    923,1399,1207,1375,1573,1782,1817,1246,1720,...
    1232,1406,838,1154,1540,1484,2121,1205,1188,...
    983,1904,1024,4337,1280,1378,1515,1218,1692];% Reduce the zero data
input = zeros(4,ndata*n);
output = zeros(1,ndata*n);
s_max = 250;
z1_max = 250;
smax = 3.1;
smin = -1.5;
F_Max = 6000;
dt = 0.001;
%% data 1 h=100
for j=1:1:ndata
filename = sprintf('mat%d.mat',j);   
load(filename,'stroke','z1','z1_vel','s_vel','DACDesired');
nstart = n1(j);
n2 = length(z1_vel);
t=0:dt:n2*dt;
input3 = zeros(n2,2);
input4 = zeros(n2,2);
for i = 1:1:n2
    input3(i,2)=z1_vel(i);
    input3(i,1)=t(i);
    input4(i,2)=s_vel(i);
    input4(i,1)=t(i);
end
tf = 10;
sim('Data_filter')
for i = 1:1:n
    input(1,i+n*(j-1))=     stroke(nstart+i)/s_max;
    input(2,i+n*(j-1))=     poslin(z1(nstart+i))/z1_max;
    input(3,i+n*(j-1))=     z1dot(nstart+i);
    input(4,i+n*(j-1))=     sdot(nstart+i);
    output(i+n*(j-1)) =     poslin(DACDesired(nstart+i))/F_Max;
end
end
save('Data_45.mat','input','output');

```
## Training Neural Network
```
clear all; clc;
%% load data
load('Data_45');
%% describe neural network
hiddenSizes = [5];
trainFcn = 'trainbr';
% trainFcn = 'trainlm';
net = fitnet(hiddenSizes, trainFcn);
net.inputs{1}.processFcns = {'removeconstantrows'};
net.outputs{2}.processFcns = {'removeconstantrows'};
net.layers{2}.transferFcn = 'satlin';
net.divideFcn = 'divideind';
% [trainInd,valInd,testInd] = divideind(14850,2971:11880,1:2970,11881:14850);
[trainInd,valInd,testInd] = divideind(14850,5941:14850,1:2970,2971:5940);
net.divideParam.trainInd=trainInd;
net.divideParam.valInd=valInd;
net.divideParam.testInd=testInd;
net = train(net, input, output);
view(net);
y = net(input);
genFunction(net,'NN15_fun.mat')

```
## Testing Neural Network
```
clear all;clc;
load('mat15.mat','stroke','z1','z1_vel','s_vel','DACDesired');
n = length(stroke);
input1 = zeros(n,2);
input2 = zeros(n,2);
input3 = zeros(n,2);
input4 = zeros(n,2);
dt = 0.001;
t=0:dt:n*dt;
for i = 1:1:n
    input1(i,2)=stroke(i);
    input1(i,1)=t(i);
    input2(i,2)=z1(i);
    input2(i,1)=t(i);
    input3(i,2)=z1_vel(i);
    input3(i,1)=t(i);
    input4(i,2)=s_vel(i);
    input4(i,1)=t(i);
end
tf =n*dt;
sim('Test_neural.slx')
figure(1)
hold on
plot(t(1:tf*1000),0.001*DACDesired(1:tf*1000))
plot(t(1:tf*1000),0.001*Neural_out(1:tf*1000))
xlabel('Time (s)')
xlim([1 2])
% ylim([0 2])
ylabel('Force (kN)')
legend('Hybrid Control','Intelligent Control')
hold off
```


