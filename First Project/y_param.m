%Variables
k=2;
b=0.2;
m=15;

%time 
tspan=0:0.1:10;

%N
N=length(tspan);
u=5*sin(2*tspan)+10.5;

%initial state
 x0(1) = 0;
 x0(2) = 0;

%Real y
[t,state]=ode45(@(t,state)model(t,state,b,k,m), tspan, x0);
y=state(:,1);

%the L(s) filter
L = [1 0.7 0.5];

l1 = L(1, 2);
l2 = L(1, 3);
s1 = tf([-1 0], L);
s2 = tf(-1, L);
s3 = tf(1, L);

%calculate z vector
z1=lsim(s1,y,tspan);
z2=lsim(s2,y,tspan);
z3=lsim(s3,u',tspan);

z=[z1 z2 z3]';
  
%calculate the table sum1 and sum2 (sum1*theta0 = sum2)
sum1 = zeros(3, 3);
sum2 = zeros(3, 1);

for i=1:N
    sum1 = sum1 + (1/N)*(z(:, i)*z(:, i)');
    sum2 = sum2 + (1/N)*(z(:, i)*y(i, 1));
end

%calculate theta0
theta0 = sum1\sum2;

%estimate m,b,k
%theta03 = 1/m
m1 = 1/theta0(3);
%theta01 = b/m-l
b1 = (theta0(1) + l1) * m1;
%theta02 = k/m-l2
k1 = (theta0(2) + l2) * m1;

fprintf('m = %.7f\n',m1);
fprintf('b = %.7f\n',b1);
fprintf('k = %.7f\n',k1);

e=abs(k-k1)+abs(b-b1)+abs(m-m1); 
fprintf('e = %.7f\n',e);

ek = (abs(k-k1)/k1)*100;
eb = (abs(b-b1)/b1)*100 ;
em = (abs(m-m1)/m1)*100;

fprintf('ek = %.7f\n',ek);
fprintf('eb = %.7f\n',eb);
fprintf('em = %.7f\n',em);

error=abs(y'-(theta0'*z));

%the state with the new m,k,b ->y1
[t,state]=ode45(@(t,state)model(t,state,b1,k1,m1), tspan, x0);
y1=state(:,1);
error2=(y-y1);

figure(1)
plot(tspan,error)
xlabel("Time samples");
ylabel("Error ");
title("Error of y-ип*ж");

figure(2)
plot(tspan, error2)
xlabel("Time samples");
ylabel("Error ");
title("Error of y-y^");
