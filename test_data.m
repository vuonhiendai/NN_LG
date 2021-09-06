%% data 3 h=300
clear all;clc;
load('mat12.mat','stroke','z1','z1_vel','s_vel','DACDesired');
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
legend('Desired Damping Force','Neural output')
hold off