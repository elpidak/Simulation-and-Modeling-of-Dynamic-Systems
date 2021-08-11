%time
step=0.01;
t=0:step:50;
N=length(t);

%Variables
u=10*sin(2*t)+5*sin(7.5*t);
a11=-0.25;
a12=3;
a21=-5;
a22=-1;
b1=1;
b2=2.2;
gamma = 20;

%initialization of parameters
p0=zeros(10,1);

[t,x]=ode45(@(t,x)equationparlyap(t,x,gamma), t, p0);

%x and x^
x1_real=x(:,1);
x2_real=x(:,2);
x1_estim=x(:,9);
x2_estim=x(:,10);

%a and a^
a11_real = a11*ones(N,1);
a11_estim=x(:,3);
a12_real = a12*ones(N,1);
a12_estim=x(:,4);
a21_real = a21*ones(N,1);
a21_estim=x(:,5);
a22_real = a22*ones(N,1);
a22_estim=x(:,6);

%b and b^
b1_real = b1*ones(N,1);
b1_estim=x(:,7);
b2_real = b2*ones(N,1);
b2_estim=x(:,8);

%errors
error1 = x1_real-x1_estim;
error2 = x2_real-x2_estim;

%figures

figure(1)
plot(t,x1_real,t,x1_estim)
title("Real and estimated output x1")
xlabel("Time samples")
legend("Real x1", "Estimated x1")
figure(2)
plot(t,error1)
title("Error of estimated and real output x1")
xlabel("Time samples")
figure(3)
plot(t,x2_real,t,x2_estim)
title("Real and estimated output x2")
xlabel("Time samples")
legend("Real x2", "Estimated x2")
figure(4)
plot(t,error2)
title("Error of estimated and real output x2")
xlabel("Time samples")
figure(5)
plot(t,a11_real,t,a11_estim)
title("Real and estimated parameter a11")
xlabel("Time samples")
legend("Real a11", "Estimated a11")
figure(6)
plot(t,a12_real,t,a12_estim)
title("Estimation of parameter a12")
xlabel("Time samples")
legend("Real a12", "Estimated a12")
figure(7)
plot(t,a21_real,t,a21_estim)
title("Real and estimated parameter a21")
xlabel("Time samples")
legend("Real a21", "Estimated a21")
figure(8)
plot(t,a22_real,t,a22_estim)
title("Real and estimated parameter a22")
xlabel("Time samples")
legend("Real a22", "Estimated a22")
figure(9)
plot(t,b1_real,t,b1_estim)
title("Real and estimated parameter b1")
xlabel("Time samples")
legend("Real b1", "Estimated b1")
figure(10)
plot(t,b2_real,t,b2_estim)
title("Real and estimated parameter b2")
xlabel("Time samples")
legend("Real b2", "Estimated b2")