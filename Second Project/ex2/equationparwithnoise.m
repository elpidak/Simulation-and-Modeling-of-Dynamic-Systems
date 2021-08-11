function dx=equationparwithnoise(t,x,a,b,h0,f,gamma)

h=h0*sin(2*pi*f*t);
u=5*sin(3*t);

%dx(2) -> da, dx(3) -> db, dx(4)-> dx 
x(1)=x(1)+h;
dx(1)=-a*x(1)+b*u; 
dx(2)=-gamma*(x(1)-x(4))*x(4); 
dx(3)=gamma*(x(1)-x(4))*u;
dx(4)=-x(2)*x(4)+x(3)*u; 

dx=dx';
end