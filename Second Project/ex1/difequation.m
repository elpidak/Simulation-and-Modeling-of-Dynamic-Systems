function dx=difequation(t,x,am,g,a,b)

%dx(2) -> d�1, dx(3) -> d�2, dx(4)-> d�1, dx(5) -> d�2
u=5*sin(3*t);
dx(1)=-a*x(1)+b*u; 
dx(2)=g*(x(1)-x(2)*x(4)-x(3)*x(5))*x(4); 
dx(3)=g*(x(1)-x(2)*x(4)-x(3)*x(5))*x(5); 
dx(4)=-am*x(4)+x(1); 
dx(5)=-am*x(5)+u; 

dx=dx';
end