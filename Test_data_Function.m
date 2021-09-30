%% data 3 h=300
clear all;clc;
load('v3_230kg_NN_5.mat','stroke','z1','z1_vel','s_vel','DesiredNN','DesiredHyb');
n = length(stroke);
X = [stroke/250;z1/250;z1_vel/3.1;s_vel/3.1];
dt = 0.001;
Neural_out = zeros(1,n);
t=0:dt:n*dt;
for i = 1:n
    Neural_out(i) = 6000*neural_function(X(:,i));
end
tt = n*dt;
tf =floor(1000*n*dt);
figure(1)
hold on
plot(t(1:tf),0.001*DesiredNN(1:tf));
plot(t(1:tf),0.001*Neural_out(1:tf));
plot(t(1:tf),0.001*DesiredHyb(1:tf));
xlabel('Time (s)')
xlim([1 2])
% ylim([0 2])
ylabel('Force (kN)')
legend('Experiment','NNout','DesiredHyb')
hold off