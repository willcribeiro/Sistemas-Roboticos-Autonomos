%Pega a matriz da fun��o
simpleMap = obstaculos();

%Gera um mapa a partir da matriz obtida
map = robotics.binaryOccupancyMap(simpleMap,2);
show(map)

%raio do rob�
raioRobo = 0.185;

%Infla os obstaculos do mapa
mapInflado = copy(map);
inflate(mapInflado, raioRobo);
show(mapInflado)

%planejamento de caminho
Amostragem = robotics.PRM

Amostragem.map = mapInflado

%Numeros de n�s da amostragem
Amostragem.NumNodes = 200;

%Definir a distancia max entre dois n�s
Amostragem.ConnectionDistance = 5;

%Pontos iniciais e finais
inicio = [x,y];
final = [x,y];

%Procura por um caminho entre o inicio e o final
path = findpath(Amostragem, inicio, final)
show(Amostragem)

%Caso o n�mero de n�s nao tenha sido o suficiente
while isempty(path)
    Amostragem.NumNodes = Amostragem.NumNodes + 10;
    
    update(Amostragem);
    
    path = findpath(Amostragem, inicio, final);
end
%Mostra o novo caminho
path

%Mostra o planejamento final
show(Amostragem)
