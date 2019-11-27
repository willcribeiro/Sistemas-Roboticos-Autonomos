function isIn = PointIsIn(O, n, x, y)

    isIn = 0;

    for index = 1:n*2
       if mod(index,2) ~= 0
            % Get the two X Y vectors / corners of the obsticle
            
            %Oi1 = O(index,:); 
            %Oi2 = O(index + 1,:);
            %Oi3 = O(index + 2,:);
            %Oi4 = O(index + 3,:);

            % Calculate the start and end ranges
            
            Start_Y = min([O(:,index+1)]);
            End_Y = max([O(:,index+1)]);

            
            Start_X = min([O(:,index)]);
            End_X = max([O(:,index)]);
            
            % If x or y is in the range of the rectangle x and y
            % break and return 1
            
            if x >= Start_X && x <= End_X && y >= Start_Y && y <= End_Y
               isIn = 1;
               break;
            end
 
       end
    end

end