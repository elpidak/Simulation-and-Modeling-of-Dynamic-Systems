%time
step=0.01;
t=0:step:20;
N=length(t);

%Variables
u=5*sin(3*t);
a=2;
b=1;
g=50;
am=3;

%initialization of parameters
p0=[0 0 0 0 0]; 

%dx, dè1,2 dö1,2
[t,p]=ode45(@(t,p)difequation(t,p,am,g,a,b), t, p0);

x=p(:,1); 
x_estim=zeros(N,1); 

theta = [p(:,2) p(:,3)]';
f=[p(:,4) p(:,5)]'; 

%x = è*^(Ô)ö
for i=1:N
    x_estim(i)=theta(:,i)'*f(:,i); 
end

a_real = 2*ones(N,1);
a_estim = am - theta(1,:);
b_real = ones(N,1);
b_estim = theta(2,:);

%errors
error = x-x_estim;
a_error = a-a_estim;
b_error = b-b_estim;
time = 0;
time2 = 0;
time3 = 0;
err_marg = 1e-4;
err_marg2 = 1e-3;

for i=1:N-1
    if abs(error(i)) < err_marg && abs(error(i+1)) < err_marg
        time = i*step;
        break;
    end
end

for i=1:N-1
    if abs(a_error(i)) < err_marg2 && abs(a_error(i+1)) < err_marg2
        time2 = i*step;
        break;
    end
end

for i=1:N-1
    if abs(b_error(i)) < err_marg2 && abs(b_error(i+1)) < err_marg2
        time3 = i*step;
        break;
    end
end


figure(1)
plot(t,x,t,x_estim,'linewidth', 1.5)
title("Real and estimated x")
xlabel("Time samples")
legend("Real x", "Estimated x")
figure(2)
plot(t,error,'linewidth', 1.5)
title("Error of estimated and real output")
xlabel("Time samples")
figure(3)
plot(t,a_estim,t,a_real,'linewidth', 1.5)
title("a estimated and a real")
xlabel("Time samples")
legend("Estimated a","Real a")
figure(4)
plot(t,b_estim,t,b_real,'linewidth', 1.5)
title("b estimated and b real")
xlabel("Time samples")
legend("Estimated b","Real b")
