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
MAP(xval,yval)=1000;
 plot(xval+.5,yval+.5,'bo');
%--------------------------------------------------------------
%---------------------------START ALGORITHM--------------------
for i = 1:10
    MAP(i,1)=-1;
    MAP(i,10)=-1;
end
for i = 1:10
    MAP(1,i)=-1;
    MAP(10,i)=-1;
end
xcord = xTarget;
ycord = yTarget;
potencial =1;

estrutura = [xcord, ycord, potencial, 0]
pilha = CQueue()
pilha.push(estrutura);
cont = 0;
while((xcord ~= xStart) && (ycord ~=yStart)) 
    aux = pilha.pop();
    xcord = aux(1);
    ycord = aux(2);
    if(MAP(xcord,ycord) ~= -1)
         if(MAP(xcord,ycord) == 0 )
            MAP(xcord,ycord) = aux(3);
         end
        
        if(MAP(xcord+1,ycord) ==0 )
            estrutura = [aux(1)+1, aux(2), aux(3)+1, potencial];
            pilha.push(estrutura);
           
        end
        if(MAP(xcord-1,ycord) == 0 )
            estrutura = [aux(1)-1, aux(2), aux(3)+1, potencial];
            pilha.push(estrutura);
        
        end
         if(MAP(xcord,ycord+1) == 0 )
            estrutura = [aux(1), aux(2)+1, aux(3)+1, potencial];
            pilha.push(estrutura);
            
         end
         if(MAP(xcord,ycord-1) == 0 )
            estrutura = [aux(1), aux(2)-1, aux(3)+1, potencial];
            pilha.push(estrutura);
            
         end    
    end
        
end
