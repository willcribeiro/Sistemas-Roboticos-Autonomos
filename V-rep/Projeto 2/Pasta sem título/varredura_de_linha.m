clc;
clear;

polig.n = 2;
p1.p = [1 2; 1 1; 2 1; 2 2];
p1.n = 4;
p2.p = [3.5 2; 4.75 1.3; 4.5 3];
p2.n = 3;

polig.p = [];
polig.p = [polig.p, p1];
polig.p = [polig.p, p2];
polig.np = sum([polig.p(:).n]);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot dos poligonos %%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
xlim([0 5])
ylim([0 5])
for i= 1:polig.n
    hold on,fill(polig.p(i).p(:,1)', polig.p(i).p(:,2)','b');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


S = [];
pontos = [];
for i= 1:polig.n
    pontos = [pontos; polig.p(i).p];
end

for i= 1:length(pontos)-1
    for j= i+1:length(pontos)
        if(pontos(i,1) > pontos(j,1))
            aux = pontos(i,:);
            pontos(i,:) = pontos(j,:);
            pontos(j,:) = aux;
        end
    end
end
   
lin = [];
for i= 1:length(pontos)-1
    for j= i+1:length(pontos)
        xi = pontos(i,1);
        yi = pontos(i,2);
        xj = pontos(j,1);
        yj = pontos(j,2);
        if (xi == xj)
            limites = [yi yj];
            y = min(limites):0.01:max(limites);
            x = ones([1, length(y)])*xi;
        else
            coe = polyfit([xi, xj],[yi, yj],1);
            x = xi:0.01:xj;
            y = polyval(coe,x);
        end
%         hold on, plot(x,y,'gx');
        bool = true;
        for k=1:polig.n
            [in,on] = inpolygon(x, y, polig.p(k).p(:,1), polig.p(k).p(:,2));
            inside = in - on;
            inside = sort(inside, 'descend');
            if find(inside == 1)
                bool = false;
            end            
        end
        if(bool == true)
            hold on, plot(x,y,'r');
        end
    end
end