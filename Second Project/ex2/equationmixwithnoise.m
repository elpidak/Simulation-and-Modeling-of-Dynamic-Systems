function dx=equationmixwithnoise(t,x,a,b,thetam,h0,f,gamma)

u=5*sin(3*t);
h=h0*sin(2*pi*f*t);

%dx(2) -> da, dx(3) -> db, dx(4)-> dx^
x(1)=x(1)+h;
dx(1)=-a*x(1)+b*u; 
dx(2)=-gamma*(x(1)-x(4))*x(1); 
dx(3)=gamma*(x(1)-x(4))*u; 
dx(4)=-x(2)*x(4)+x(3)*u+(thetam*(x(1)-x(4))); 

dx=dx';
end