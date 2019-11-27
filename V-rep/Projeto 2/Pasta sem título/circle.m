function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2pi; 
xp=rcos(ang);
yp=r*sin(ang);
hold on,plot(x+xp,y+yp);
end