%time
step=0.01;
t=0:step:25;
N=length(t);

%time
step=0.01;
t2=0:step:25;
N2=length(t2);

%Variables
u=5*sin(3*t);
a_estim=2;
b_estim=1;
a2_estim=2;
b2_estim=1;
a3_estim=2;
b3_estim=1;
a4_estim=2;
b4_estim=1;
thetam =3;
gamma = 20;

%initialization of parameters
p0=[0 0 0 0];
l0=[0 0 0 0];

[t,p]=ode45(@(t,p)equationpar(t,p,a_estim,b_estim,gamma), t, p0);

%x and x^
x=p(:,1);
x_estim=p(:,4);

%a and a^
a_real = 2*ones(N,1);
a_estim=p(:,2);

%b and b^
b_real = ones(N,1);
b_estim=p(:,3);

%error
error = x-x_estim;

%Noise parameters
h0=0.15; %Noise
f=50; %Noise
%with noise
[t2,l]=ode45(@(t2,l)equationparwithnoise(t2,l,a2_estim,b2_estim,h0,f,gamma), t2, l0);

%x and x^
x2=l(:,1);
x2_estim=l(:,4);

%a and a^
a2_real = 2*ones(N2,1);
a2_estim=l(:,2);

%b and b^
b2_real = ones(N2,1);
b2_estim=l(:,3);

%error
error2 = x2-x2_estim;

%Serial-Parallel
[t,k]=ode45(@(t,k)equationmix(t,k,a3_estim,b3_estim,thetam,gamma), t, p0);

%x and x^
x3=k(:,1);
x3_estim=k(:,4);

%a and a^
a3_real = 2*ones(N,1);
a3_estim=k(:,2);

%b and b^
b3_real = ones(N,1);
b3_estim=k(:,3);

%error
error3 = x3-x3_estim;

%Serial-Parallel with noise
[t2,n]=ode45(@(t2,n)equationmixwithnoise(t2,n,a4_estim,b4_estim,thetam,h0,f,gamma), t2, l0);

%x and x^
x4=n(:,1);
x4_estim=n(:,4);

%a and a^
a4_real = 2*ones(N2,1);
a4_estim=n(:,2);

%b and b^
b4_real = ones(N2,1);
b4_estim=n(:,3);

%error
error4 = x4-x4_estim;

%figures

%parallel
figure(1)
plot(t,error,'linewidth', 1)
title("Error of estimated and real output with parallel method")
xlabel("Time samples")
figure(2)
plot(t,x_estim,t,x,'linewidth', 1.5)
title("Real and estimated output with parallel method")
xlabel("Time samples")
legend("Estimated x","Real x")
figure(3)
plot(t,a_estim,t,a_real,'linewidth', 1)
title("a estimated with parallel method")
xlabel("Time samples")
legend("Estimated a","Real a")
figure(4)
plot(t,b_estim,t,b_real,'linewidth', 1)
title("b estimated with parallel method")
xlabel("Time samples")
legend("Estimated b","Real b")

%parallel with noise
figure(5)
plot(t2,error2,'linewidth', 1)
title("Error of estimated and real output with parallel method and with noise")
xlabel("Time samples")
figure(6)
plot(t,x2_estim,t,x2,'linewidth', 1.5)
title("Real and estimated output with parallel method and with noise")
xlabel("Time samples")
legend("Estimated x","Real x")
figure(7)
plot(t2,a2_estim,t2,a2_real,'linewidth', 1)
title("a estimated with parallel method with noise")
xlabel("Time samples")
legend("Estimated a","Real a")
figure(8)
plot(t2,b2_estim,t2,b2_real,'linewidth', 1)
title("b estimated with parallel method with noise")
xlabel("Time samples")
legend("Estimated b","Real b")

%serial - parallel
figure(9)
plot(t,error3,'linewidth', 1)
title("Error of estimated and real output with serial-parallel method")
xlabel("Time samples")
figure(10)
plot(t,x3_estim,t,x3,'linewidth', 1.5)
title("Real and estimated output with serial-parallel method")
xlabel("Time samples")
legend("Estimated x","Real x")
figure(11)
plot(t,a3_estim,t,a3_real,'linewidth', 1)
title("a estimated with serial-parallel method")
xlabel("Time samples")
legend("Estimated a","Real a")
figure(12)
plot(t,b3_estim,t,b3_real,'linewidth', 1)
title("b estimated with serial-parallel method")
xlabel("Time samples")
legend("Estimated b","Real b")

%serial-parallel with noise
figure(13)
plot(t2,error4,'linewidth', 1)
title("Error of estimated and real output with serial-parallel method and with noise")
xlabel("Time samples")
figure(14)
plot(t,x4_estim,t,x4,'linewidth', 1.5)
title("Real and estimated output with serial-parallel method and with noise")
xlabel("Time samples")
legend("Estimated x","Real x")
figure(15)
plot(t2,a4_estim,t2,a4_real,'linewidth', 1)
title("a estimated with serial-parallel method with noise")
xlabel("Time samples")
legend("Estimated a","Real a")
figure(16)
plot(t2,b4_estim,t2,b4_real,'linewidth', 1)
title("b estimated with serial-parallel method with noise")
xlabel("Time samples")
legend("Estimated b","Real b")

%comparison
figure(17)
plot(t,error,t,error3,'linewidth', 1)
title("Error of estimated and real output with parallel vs with serial-parallel")
xlabel("Time samples")
legend("Error with parallel","Error with serial-parallel")

figure(18)
plot(t2,error2,t2,error4,'linewidth', 1)
title("Error of estimated and real output with parallel vs with serial-parallel - with noise")
xlabel("Time samples")
legend("Error with parallel and noise","Error with serial-parallel and noise")

figure(19)
plot(t2,error2,t2,error4,t2,error,t2,error3,'linewidth', 1)
title("Output error with parallel vs with serial-parallel and with noise")
xlabel("Time samples")
legend("Error with parallel noise","Error with serial-parallel noise","Error with parallel","Error with serial-parallel")
