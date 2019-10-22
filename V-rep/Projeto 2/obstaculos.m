function [] = DesenhoDeObstaculos()

%  figure('units','normalized','outerposition',[0 0 1 1])
hold on
title('Mapa de Configuracao');
 grid on
axis([-2.3 2.3 -2.3 2.3])
% set(gca,'xtick',0:10:250,'ytick',0:10:150)
ax = gca;
ax.XTick = [-2.3:0.5:2.3];
ax.YTick = [-2.3:0.5:2.3];


% Obstaculo 1
xsquare1= [-1.4,-1.4,0.42,0.42];
ysquare1=[-1.32,-1.62,-1.62,-1.32];

% Obstaculo 2
xsquare2= [0.22,0.22,2.07,2.07];
ysquare2=[-0.62,-0.92,-0.92,-0.62];

% Obstaculo 3
xsquare3= [-1.42,-1.42,0.42,0.42];
ysquare3=[0.12,-0.17,-0.17,0.12];

% Obstaculo 4
xsquare4= [-0.35,-0.35,1.5,1.5];
ysquare4=[1.62,1.32,1.32,1.62];

% Draw


fill(xsquare1,ysquare1,'b');
fill(xsquare2,ysquare2,'b');
fill(xsquare3,ysquare3,'b');
fill(xsquare4,ysquare4,'b');







end