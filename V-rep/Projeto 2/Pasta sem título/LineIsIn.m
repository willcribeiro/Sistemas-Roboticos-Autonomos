function isIn = LineIsIn(O, n, x1, y1, x2, y2)

    isIn = 0;

    [m, b] = SlopeIntercept(x1, y1, x2, y2);

    for index = 1:n*2 
        if mod(index,2) ~= 0
            
            % Get the two X Y vectors / corners of the obsticle
           
            Oi1 = O(:,index); 
            Oi2 = O(:,index+1);
            % Calculate the start and end ranges
            
            Start_Y = min([Oi2]);
            End_Y = max([Oi2]);

            
            Start_X = min([Oi1]);
            End_X = max([Oi1]);
              
            if abs(m) >= 0 && abs(m) <= 1 % Traverse the line by x and check each point.
                for x_val = min(x1, x2):max(x1, x2)
                    [x, y] = Intercepts(m, b, x_val);
                    if PointIsInObsticle(Oi1, Oi2, x, y) == 1
                       isIn = 1;
                       break; 
                    end
                end
            else
                for y_val = min(y1, y2):max(y1, y2)
                    [x, y] = Intercepts(m, b, y_val);
                    if PointIsInObsticle(Oi1, Oi2, x, y) == 1
                       isIn = 1;
                       break; 
                    end
                end
            end
        end
    end
    
function [m, b] = SlopeIntercept(x1, y1, x2, y2)
    m = (y2-y1) / (x2-x1);
    b = y1 - m*x1;
end

function [x, y] = Intercepts(m, b, val)
    y = m*val + b;
    x = (val - b) / m;
end

function isIn = PointIsInObsticle(Oi1, Oi2, x, y)

    isIn = 0;

    % Calculate the start and end ranges

    Start_Y = min([Oi2]);
    End_Y = max([Oi2]);


    Start_X = min([Oi1]);
    End_X = max([Oi1]);

    % If x or y is in the range of the rectangle x and y
    % break and return 1

    if x >= Start_X && x <= End_X && y >= Start_Y && y <= End_Y
       isIn = 1;
    end


end

end