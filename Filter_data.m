%% Reshape into input data and label
clear all; clc;
n = 2000;
input = zeros(4,2*n);
output = zeros(1,2*n);
s_max = 250;
z1_max = 250;
svel_max = 3;
v1_max = 3;
F_Max = 3000;
%% data 1 h=100
load('mat1.mat','z1_vel','s_vel');
n1 = length(z1_vel);

input3 = zeros(n1,2);
input4 = zeros(n1,2);
dt = 0.001;
t=0:dt:n1*dt;
for i = 1:1:n1

    input3(i,2)=z1_vel(i);
    input3(i,1)=t(i);
    input4(i,2)=s_vel(i);
    input4(i,1)=t(i);
end
tf = 4;
sim('Data_filter')

%% Test
figure(1)
hold on
plot(t(1000:2000),z1_vel(1000:2000));
plot(t(1000:2000),3.1*z1dot(1000:2000));
title('z1 dot')
xlabel('Time (s)')
ylabel('Z1dot (s)')
xlim([1 2])
legend('Raw data','Kalman Filter')
hold off

figure(2)
hold on
plot(t(1000:2000),s_vel(1000:2000));
plot(t(1000:2000),3.1*sdot(1000:2000));
xlim([1 2])
title('sdot dot')
xlabel('Time (s)')
ylabel('Sdot (s)')
legend('Raw data','Kalman Filter')
hold off
