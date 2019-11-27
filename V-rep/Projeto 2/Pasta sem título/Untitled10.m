clear
clc


M = [];
N = [];
O = [];
[M N O] = obstaculos();
map = [M, N, O];

nos = 50;

inicio = [0.91479, 0.47715]; %coordenadas iniciais (x,y)
final = [0.775, 2.875]; %coordenadas finais (x,y)

Amostragem(map, nos);

