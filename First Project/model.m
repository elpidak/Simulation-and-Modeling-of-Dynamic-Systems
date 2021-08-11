%The function of the dynamic model of the system
function dy = model(t,y,b,k,m)

%data
u=5*sin(2*t)+10.5; 

dy(1)=y(2);
dy(2)=(1/m)*u-(k/m)*y(1)-(b/m)*y(2);
dy=dy';

end