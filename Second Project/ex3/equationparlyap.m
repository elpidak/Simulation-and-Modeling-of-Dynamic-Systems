function dx=equationparlyap(t,x,gamma)

u=10*sin(2*t)+5*sin(7.5*t);
a11=-0.25;
a12=3;
a21=-5;
a22=-1;
b1=1;
b2=2.2;

%x(1) -> x ,dx(1)-> dx, dx(2) -> dx, dx(3) -> d(a^11), dx(4)-> d(a^12),dx(5)->d(a^21) 
%dx(6)->d(a^22), dx(7)->d(b^1), dx(8)->d(b^2),dx(9)->dx^1, dx(10)-> dx^2 

error = x(1)-x(9);
error2 = x(2)-x(10);

dx(1)=a11*x(1)+a12*x(2)+b1*u; 
dx(2)=a21*x(1)+a22*x(2)+b2*u; 
dx(3)=gamma*error*x(9)'; 
dx(4)=gamma*error*x(10)';  
dx(5)=gamma*error2*x(9)'; 
dx(6)=gamma*error2*x(10)';  
dx(7)=gamma*error*u;  
dx(8)=gamma*error2*u;  
dx(9)=x(3)*x(9)+x(4)*x(10)+x(7)*u;  
dx(10)=x(5)*x(9)+x(6)*x(10)+x(8)*u; 

dx=dx';
end

