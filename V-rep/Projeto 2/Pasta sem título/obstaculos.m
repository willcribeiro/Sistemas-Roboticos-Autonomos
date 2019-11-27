function [vertices1, vertices2, vertices3] = obstaculos()

%  figure('units','normalized','outerposition',[0 0 1 1])
figure(1)
hold on
title('Mapa de Configuracao');
 grid on
axis([0 4.6 0 4.6])
set(gca,'xtick',0:10:250,'ytick',0:10:150)
ax = gca;
ax.XTick = [0:0.5:4.6];
ax.YTick = [0:0.5:4.6];

raioRobo = 0.185;

% Obstaculo 1
xsquare1= [1.525 + raioRobo; 1.525 + raioRobo; 3.525 + raioRobo; 3.525 + raioRobo];
ysquare1=[0.9 - raioRobo; 1 + raioRobo; 1 + raioRobo; 0.9 - raioRobo];
vertices1 = [xsquare1, ysquare1]

% Obstaculo 2
xsquare2= [0.25 + raioRobo; 0.25 + raioRobo; 2.25 + raioRobo; 2.25 + raioRobo];
ysquare2=[1.775 - raioRobo; 1.875 + raioRobo; 1.875 + raioRobo; 1.775 - raioRobo];
vertices2 = [xsquare2, ysquare2]

% Obstaculo 3
xsquare3= [1.45 + raioRobo; 1.45 + raioRobo; 3.45 + raioRobo; 3.45 + raioRobo];
ysquare3=[2.675 - raioRobo; 2.775 + raioRobo; 2.775 + raioRobo; 2.675 - raioRobo];
vertices3 = [xsquare3, ysquare3]

% Obstaculo 4
%xsquare4= [-0.35,-0.35,1.5,1.5] +2.3;
%ysquare4=[1.62,1.32,1.32,1.62] +2.3;

% Draw

%plot(xsquare1,ysquare1,'b');
%plot(xsquare2,ysquare2,'b');
fill(xsquare1,ysquare1,'b');
fill(xsquare2,ysquare2,'b');
fill(xsquare3,ysquare3,'b');
%fill(xsquare4,ysquare4,'b');

end