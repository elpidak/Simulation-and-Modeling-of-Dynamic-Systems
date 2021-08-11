%time
tspan =0:0.00001:2;

%N
N=length(tspan);

%Variables
vr=zeros(N,1);
vc=zeros(N,1);
vr1=zeros(N,1);
vc1=zeros(N,1);

%output value
for i=1:N
    Vout=v(tspan(i));
    vc(i)=  Vout(1);
    vr(i)= Vout(2);
end
for i=1:N
    Vout=v(tspan(i));
    vc1(i)=  Vout(1);
    vr1(i)= Vout(2);
end
%the random values for the part 2 of exercise 2
vc1(2) = vc1(2)+vc1(2)*10;
vc1(5)= vc1(5)+vc1(5)*10;
vc1(6)=vc1(6)+vc1(6)*10; 
vr1(8) = vr1(8)+vr1(8)*10;
vr1(3)= vr1(3)+vr1(3)*10;
vr1(9)=vr1(9)+vr1(9)*10;

figure(1)
plot(tspan,vc,'linewidth', 1.5)
hold on
plot(tspan,vr,'linewidth', 1.5)
title('VR and VC plot');
ylabel('VR (V) and VC (V)');
xlabel('Time');
legend('V_c', 'V_R');

%input value
u1=2*sin(tspan);
% na tsekarw u2=1
u2 = ones(N,1);

%the L(s) filter
L = [1 400 40000];

l1 = L(1, 2);
l2 = L(1, 3);
s1 = tf([-1 0], L);
s2 = tf(-1, L);

%calculate z vector
z1=lsim(s1,vc,tspan);
z2=lsim(s2,vc,tspan);
z3=lsim(s1,u1',tspan);
z4=lsim(s1,u2,tspan);
z5=lsim(s2,u1',tspan);
z6=lsim(s2,u2,tspan);

z7=lsim(s1,vc1,tspan);
z8=lsim(s2,vc1,tspan);
z9=lsim(s1,u1',tspan);
z10=lsim(s1,u2,tspan);
z11=lsim(s2,u1',tspan);
z12=lsim(s2,u2,tspan);

z=[z1 z2 z3 z4 z5 z6]';

zk=[z7 z8 z9 z10 z11 z12]';

%calculate the table sum1 and sum2 (sum1*theta0 = sum2)
sum1 = zeros(6, 6);
sum2 = zeros(6, 1);
sumk1 = zeros(6, 6);
sumk2 = zeros(6, 1);


for i=1:N
    sum1 = sum1 + (1/N)*(z(:, i)*z(:, i)');
    sum2 = sum2 + (1/N)*(z(:, i)*vc(i, 1));
end

for i=1:N
    sumk1 = sumk1 + (1/N)*(zk(:, i)*zk(:, i)');
    sumk2 = sumk2 + (1/N)*(zk(:, i)*vc1(i, 1));
end

%calculate theta0
theta0 = sum1\sum2;

%calculate theta0
theta10 = sumk1\sumk2;

%estimate 1/RC and 1/LC, όπου έχω RC = 1/RC και αντίστοιχα για το LC , για
%ευκολία στις πράξεις
%theta01 = b/m-l1
RC1 = (theta0(1) + l1) ;
RC2 = abs(theta0(3) );
RC3 = abs(theta0(4)) ;

%final 1/RC
RC = (RC1+RC2+RC3)/3;

%theta02 = k/m-l2
LC1 = (theta0(2) + l2) ;
LC2 = abs(theta0(6));

%final 1/LC
LC = (LC1+LC2)/2;

%theta01 = b/m-l
RCk1 = (theta10(1) + l1) ;
RCk2 = abs(theta10(3) );
RCk3 = abs(theta10(4)) ;

%final 1/RC for part 2
RCk = (RCk1+RCk2+RCk3)/3;

%theta02 = k/m-l2
LCk1 = (theta10(2) + l2) ;
LCk2 = abs(theta0(6));

%final 1/LC for part 2
LCk = (LCk1+LCk2)/2;

fprintf('1/RC = %.15f\n',RC);
fprintf('1/LC = %.15f\n',LC);

fprintf('1/RC = %.15f\n',RCk);
fprintf('1/LC = %.15f\n',LCk);

%σφαλμα παραμετροποίησης 
%part 1
errorvc = vc'- theta0'*z;
errorvr = vr'- u1-u2'+theta0'*z;
%part 2
errorkvc = vc1'- theta10'*zk;
errorkvr = vr1'- u1-u2'+theta10'*zk;

%the transfer table
%t_b = [(s*RC)/(s^2+RC*s+LC) (RC*s+LC)/(s^2+RC*s+LC); (s^2+LC)/(s^2+RC*s+LC) (s^2)/(s^2+RC*s+LC)];
%part 1
k1=tf([RC 0],1);
k2 = tf([1 RC LC],1);
k3 = tf([0 RC LC],1);
k4 = tf([1 0 LC],1);
k5 = tf([1 0 0],1);

%part 2
k6=tf([RCk 0],1);
k7 = tf([1 RCk LCk],1);
k8 = tf([0 RCk LCk],1);
k9 = tf([1 0 LCk],1);
k10 = tf([1 0 0],1);

%part1
f1=lsim((k1/k2),u1',tspan);
f2=lsim(k3/k2,u2,tspan);
f3=lsim(k4/k2,u1',tspan);
f4=lsim(k5/k2,u2,tspan);

%part 2
f5=lsim((k6/k7),u1',tspan);
f6=lsim(k8/k7,u2,tspan);
f7=lsim(k9/k7,u1',tspan);
f8=lsim(k10/k7,u2,tspan);

%vr and vc estimated from the transfer table
%part 1
vcnew = f1+f2;
vrnew = f3+f4;

%part 2
vcknew = f5+f6;
vrknew = f7+f8;

figure(2)
plot(tspan,errorvc,'linewidth', 1.5)
xlabel("Time samples");
ylabel("Error ");
title("Error Vc-θο*ζ");

figure(3)
plot(tspan,errorvr)
xlabel("Time samples");
ylabel("Error ");
title("Error Vr με παραμετροποιημένο μοντέλο");

figure(4)
plot(tspan,vc-vcnew,'linewidth', 1.5)
hold on
plot(tspan,vc1-vcknew,'linewidth', 1.5)
xlabel("Time samples");
ylabel("Error ");
title("Σύγκριση σφαλμάτων Vc πραγματικών και εκτιμώμενων τιμών");
legend('Σφάλμα με σωστές μετρήσεις', 'Σφάλμα με λάθος μετρήσεις');

figure(5)
plot(tspan,vr-vrnew,'linewidth', 1.5)
hold on
plot(tspan,vr1-vrknew,'linewidth', 1.5)
xlabel("Time samples");
ylabel("Error ");
title("Σύγκριση σφαλμάτων Vr πραγματικών και εκτιμώμενων τιμών");
legend('Σφάλμα με σωστές μετρήσεις', 'Σφάλμα με λάθος μετρήσεις');

figure(6)
plot(tspan,vc,'linewidth', 1.5)
hold on
plot(tspan, vcnew,'linewidth', 1.5)
title('VC πραγματική τιμή και εκτιμώμενη');
ylabel('VC_{real} and VC_{estimated}');
xlabel("Time samples");
legend('VC_{real}', 'VC_{estimated}');


figure(7)
plot(tspan,vr,'linewidth', 1.5)
hold on
plot(tspan, vrnew,'linewidth', 1.5)
title('VR πραγματική τιμή και εκτιμώμενη');
ylabel('VR_{real} and VR_{estimated}');
xlabel("Time samples");
legend( 'VR_{real}', 'VR_{estimated}');

figure(8)
plot(tspan,vr-vrnew,'linewidth', 1.5 )
title('Σφάλμα πραγματικής και εκτιμώμενης τιμής VR');
ylabel('VR_{real} - VR_{estimated}');
xlabel("Time samples");

figure(9)
plot(tspan,vc-vcnew, 'linewidth', 1.5)
title('Σφάλμα πραγματικής και εκτιμώμενης τιμής VC ');
ylabel('VC_{real} - VC_{estimated}');
xlabel("Time samples");

figure(10)
plot(tspan,vc1,'linewidth', 1.5)
hold on
plot(tspan, vcknew,'linewidth', 1.5)
title('VC πραγματική τιμή και εκτιμώμενη');
ylabel('VC_{real} and VC_{estimated}');
xlabel("Time samples");
legend('VC_{real}', 'VC_{estimated}');

figure(11)
plot(tspan,vr1,'linewidth', 1.5)
hold on
plot(tspan, vrknew,'linewidth', 1.5)
title('VR πραγματική τιμή και εκτιμώμενη');
ylabel('VR_{real} and VR_{estimated}');
xlabel("Time samples");
legend( 'VR_{real}', 'VR_{estimated}');

figure(12)
plot(tspan, vc1-vcknew,'linewidth', 1.5)
title('Σφάλμα πραγματικής και εκτιμώμενης τιμής VC ');
ylabel('VC_{real} - VC_{estimated}');
xlabel("Time samples");

figure(13)
plot(tspan,vr1-vrknew)
title('Σφάλμα πραγματικής και εκτιμώμενης τιμής VR');
ylabel('VR_{real} - VR_{estimated}');
xlabel("Time samples");

figure(14)
plot(tspan,vc1,'linewidth', 1.5)
hold on
plot(tspan,vr1,'linewidth', 1.5)
title('VR and VC plot');
ylabel('VR (V) and VC (V)');
xlabel('Time');
legend('V_c', 'V_R');
