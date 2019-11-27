%function Amostragem(map, nos);

clear
clc

numNodes = 70; %numeros totais de nos
nodes.px = [];
nodes.py = [];
i=1;
r = [];
n = 3; %quantidade de obstaculos

roomWidth = 1;
roomLength = 1;
AdjacencyMatrix = zeros(roomWidth + 2, roomLength + 2);

%Pega o mapa de obstaculos
M = [];
N = [];
O = [];
[M N O] = obstaculos();
map = [M, N, O];

%Vetores pra guardar os pontos
X_Coordenadas = zeros(numNodes + 2);
Y_Coordenadas = zeros(numNodes + 2);

Nx = [];
Ny = [];
No = [Nx; Ny];
 
inicio = [0.91479, 0.47715]; %coordenadas iniciais (x,y)
final = [0.775, 2.875]; %coordenadas finais (x,y)

%Guardar os pontos iniciais no vetor
X_Coordenadas(1) = inicio(1);
Y_Coordenadas(1) = inicio(2);
 
Nx(i, :) = [inicio(1)];
Ny(i, :) = [inicio(2)];

%Guardar os pontos finais no vetor
X_Coordenadas(numNodes) = final(1);
Y_Coordenadas(numNodes) = final(2);

Nx(numNodes, :) = [final(1)];
Ny(numNodes, :) = [final(2)];

i= i+1;
while(i < numNodes)
    %Gerar n�s aleat�rios nos limites [0, 4.5]
      a = 0.5;
      b = 3.5;
      % r = (b-a).*rand(1000,1) + a;
      nodes(i).px = (b-a).*rand(1,1) + a;
      nodes(i).py = (b-a).*rand(1,1) + a;  
     
      %Ver se o n� gerado esta dentro do obstaculo
    if PointIsIn(map, n, nodes(i).px, nodes(i).py) == 0
        %Guarda os n�s em vetores auxiliares
        X_Coordenadas(i) = nodes(i).px; 
        Y_Coordenadas(i) = nodes(i).py;
        Nx(i, :) = [nodes(i).px];
        Ny(i, :) = [nodes(i).py];
  
        xlim([0.25 4])
        ylim([0.25 3.5])
        hold on, plot(Nx(i,:), Ny(i,:), 'ro')
        
        i = i+1;
    end
end

for q = 1:numNodes + 2

    p = randi(numNodes, 1); %Pega um n� aleatorio

    c = [X_Coordenadas(p), Y_Coordenadas(p)]; %Acha as coordenadas desse n�
    
    for j = 1:numNodes + 2 %checa todos os n�s existentes

        if(j ~= p)
           y1 = c(2);
           y2 = Y_Coordenadas(j);
           x1 = c(1);
           x2 = X_Coordenadas(j);
           d = sqrt((y2-y1)^2 + (x2-x1)^2); %distancia entre os n�s
           
              if d <= 1.2 && d >= 0.5             
                  if (x1 == x2)
                       limites = [y1 y2];
                       y = min(limites):0.01:max(limites);
                       x = ones([1, length(y)])*x1;
                  elseif(x1 < x2)
                       coe = polyfit([x1, x2],[y1, y2],1);
                       x = x1:0.01:x2;
                       y = polyval(coe,x);
                  else
                       coe = polyfit([x1, x2],[y1, y2],1);
                       x = x2:0.01:x1;
                       y = polyval(coe,x);
                  end         
                        
                  bool = true;
                 for index = 1:n*2 
                     if mod(index,2) ~= 0
                        [in,~] = inpolygon(x, y, map(:,index), map(:,index+1));
                         in = sort(in, 'descend');
                         if find(in == 1)
                            bool = false;
                         end
                     end
                  end
                  if(bool == true)
                     AdjacencyMatrix(p, j) = 1;
                     AdjacencyMatrix(j, p) = 1;
                        
                     hold on, plot(x,y,'k');
                  end
                  
              end
        end
    end

end

xlim([0.25 4])
ylim([0.25 3.5])
hold on, plot(inicio(1), inicio(2), 'bo')

xlim([0.25 4])
ylim([0.25 3.5])
hold on, plot(final(1), final(2), 'bo')

%Start Node
%     visited = [];
%     open = [];
%     openIndex = 1;
%     visitedIndex = 1;
%     
%     visited(visitedIndex, :) = [1, 1]; % Start Node
%     
%     [rows, cols] = size(AdjacencyMatrix);
%     
%     % Fill First Neighbors
%     for col = 1:cols
%         if AdjacencyMatrix(1,col) == 1
%             open(openIndex, :) = [1, col];
%             openIndex = openIndex + 1;
%         end
%     end
%     
%     
%     
%     while isempty(open) == 0
%         
%        current = open(1, :); % First element
%        openIndex = openIndex - 1;
%        open(1, :) = []; % remove the first element
%        
%        visitedIndex = visitedIndex + 1;
%        visited(visitedIndex, :) = current;
%        
%        for col = current(1)+1:cols
%            if AdjacencyMatrix(current(2), col) == 1
%                 open(openIndex, :) = [current(2), col];
%                 openIndex = openIndex + 1;
%             end
%        end
%         
%     end
% 
%     %disp(visited);
%     %disp(open);
%    No = [Nx, Ny];
%     
%     Q = [1 0 heuristic(No(1,:),final) 0+heuristic(No(1,:),final) -1];
%     
%     for i = 1:visitedIndex
%         
%        
%         xval = Nx(visited(i,1));
%         yval = Ny(visited(i,1));
%         xval2 = Nx(visited(i,2));
%         yval2 = Ny(visited(i,2));
%        if (xval == xval2)
%                   limites = [yval yval2];
%                   y_path = min(limites):0.01:max(limites);
%                   x_path = ones([1, length(y_path)])*xval;
%                   elseif(xval < xval2)
%                        coe = polyfit([xval, xval2],[yval, yval2],1);
%                        x_path = xval:0.01:xval2;
%                        y_path = polyval(coe,x_path);
%                   else
%                        coe = polyfit([xval, xval2],[yval, yval2],1);
%                        x_path = xval2:0.01:xval;
%                        y_path = polyval(coe,x_path);
%                   end   
%         
%         hold on, plot(x_path, y_path, 'rx' );
%         
%  end
