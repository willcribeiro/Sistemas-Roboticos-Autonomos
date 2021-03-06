clear
clc
%-----------------Definicao de tamanho do mapa-----------------
MAX_X=10;
MAX_Y=10;
%This array stores the coordinates of the map and the 
%Objects in each coordinate
MAP=zeros(MAX_X,MAX_Y);
%--------------------------------------------------------------
j=0;
x_val = 1;
y_val = 1;
axis([1 MAX_X+1 1 MAX_Y+1])
grid on;
hold on;
n=0;%Number of Obstacles

for i = 1:10
    MAP(i,1)=-1;
    a = floor(i);
    b = floor(1);
    plot(a+.5,b+.5,'rx');
    MAP(i,10)=-1;
    a = floor(i);
    b = floor(10);
    plot(a+.5,b+.5,'rx');
end
for i = 1:10
    MAP(1,i)=-1;
    a = floor(1);
    b = floor(i);
    plot(a+.5,b+0.5,'rx')
    MAP(10,i)=-1;
    a = floor(10);
    b = floor(i);
    plot(a+.5,b+0.5,'rx')
    
end

% --------Iniciaizacao de conf de alvo---------------------
pause(1);
h=msgbox('Selecione o alvo com o botão esquerdo');
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('Selecione o alvo com o botão esquerdo','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
end
xval=floor(xval);
yval=floor(yval);
xTarget=xval;% Cordenada X do alvo
yTarget=yval;% Cordenada Y do alvo

MAP(xval,yval)=1;%Preenchimento da matriz com o valor do ALVO
plot(xval+.5,yval+.5,'gd');
text(xval+1,yval+.5,'Alvo')
%--------------------------------------------------------------

% --------Iniciaizacao de conf dos obstaculos ---------------------
pause(2);
h=msgbox('Slecione o obstáculo com o botao Esquerdo e o ultimo com o Direito');
  xlabel('Slecione o obstáculo com o botao Esquerdo e o ultimo com o Direito','Color','blue');
uiwait(h,10);
if ishandle(h) == 1
    delete(h);
end
while but == 1
    [xval,yval,but] = ginput(1);
    xval=floor(xval);
    yval=floor(yval);
    MAP(xval,yval)=-1;%Preenchimento da matriz com o valor dos OBSTACULOS
    plot(xval+.5,yval+.5,'ro');
end
%--------------------------------------------------------------
% --------Iniciaizacao de conf do ponto INICIAL ---------------------
pause(1);

h=msgbox('Selecione a posicao inicial com o botao Direito');
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('Selecione a posicao inicial com o botao Direito ','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
xStart=xval;%Starting Position
yStart=yval;%Starting Position
MAP(xval,yval)=0;
 plot(xval+.5,yval+.5,'bo');


%--------------------------------------------------------------
%---------------------------START ALGORITHM--------------------

xcord = xTarget;
ycord = yTarget;
potencial =1;

estrutura = [xcord, ycord, potencial]
fila = CQueue();%criar fila
pilha = CQueue();%criar pilha
fila.push(estrutura);
cont = 0;
while ((xcord ~= xStart) || (ycord ~=yStart))
    if(fila.size() == 0)
        disp('Caminho nao possivel')
        break
    end
    aux = fila.pop();
    xcord = aux(1);
    ycord = aux(2);
    if(MAP(xcord,ycord) ~= -1)
         if(MAP(xcord,ycord) == 0 )
            MAP(xcord,ycord) = aux(3);
         end
        
        if(MAP(xcord+1,ycord) ==0 )
            estrutura = [aux(1)+1, aux(2), aux(3)+1];
            fila.push(estrutura);
           
        end
        if(MAP(xcord-1,ycord) == 0 )
            estrutura = [aux(1)-1, aux(2), aux(3)+1];
            fila.push(estrutura);
        
        end
         if(MAP(xcord,ycord+1) == 0 )
            estrutura = [aux(1), aux(2)+1, aux(3)+1];
            fila.push(estrutura);
            
         end
         if(MAP(xcord,ycord-1) == 0 )
            estrutura = [aux(1), aux(2)-1, aux(3)+1];
            fila.push(estrutura);
            
         end    
    end
        
end
fila.remove()

while MAP(xcord,ycord) ~= 1
   
   if((MAP(xcord,ycord) > MAP(xcord +1,ycord)) && (MAP(xcord+1,ycord) > 0)) 
       estrut = [xcord, ycord];
       pilha.push(estrut);
       xcord = xcord + 1;
       plot(xcord+.5,ycord+.5,'gx'); 
       
   elseif((MAP(xcord,ycord) > MAP(xcord -1,ycord)) && (MAP(xcord-1,ycord) > 0))
       estrut = [xcord, ycord];
       pilha.push(estrut);
       xcord = xcord - 1;
       plot(xcord+.5,ycord+.5,'gx'); 
   
   elseif((MAP(xcord,ycord) > MAP(xcord,ycord+1)) && (MAP(xcord,ycord+1) > 0))
       estrut = [xcord, ycord];
       pilha.push(estrut);
       ycord = ycord + 1;
       plot(xcord+.5,ycord+.5,'gx'); 
   elseif((MAP(xcord,ycord) > MAP(xcord,ycord-1)) && (MAP(xcord,ycord-1) > 0))
       estrut = [xcord, ycord];
       pilha.push(estrut);
       ycord = ycord - 1;      
       plot(xcord+.5,ycord+.5,'gx'); 
   end
          
end
inicial = pilha.pop();
J = 1;
K =1;
while pilha.size() > 0
    final = pilha.pop();
    for ix = inicial(1):0.05:final(1)
        Xaux(J) = ix;
        J = J+1;
    end
     for iy = inicial(2):0.05:final(2)
        Yaux(K) = iy;
        K = K+1;
    end
    inicial = final;
end
tamanho_matriz_x = size(Xaux);
tamanho_matriz_y = size(Yaux);

Y = zeros(1,tamanho_matriz_x(2));


if(tamanho_matriz_x(2) > tamanho_matriz_y(2))
    X = Xaux;
    Y = zeros(1,tamanho_matriz_x(2));
    for i=1:size(Yaux)
        Y(1,i) = Yaux(1,i);  
    end
    Z = ones(1,tamanho_matriz_x(2))*0.5;
else
    X = zeros(1,tamanho_matriz_y(2));
    for i=1:size(Xaux)
        X(1,i) = Xaux(1,i);  
    end
    Y = Yaux;
    Z = ones(1,tamanho_matriz_y(2))*0.5;
end
MAT = [X' Y' Z'];

