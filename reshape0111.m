clear all;clc;
%% Reshape into input data and label
ndata=13;% Number of data
n = 315;% Length of data
n1 = [1260, 1240, 1180,1340,1525, 1300,1280,1542,1670,950,1405,1770,1630];% Reduce the zero data
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

%% Test
figure(1)
plot(input(1,:))
figure(2)
plot(input(2,:))
figure(3)
plot(input(3,:))
figure(4)
plot(input(4,:))
figure(5)
plot(output)

save('Data_13_del.mat','input','output');