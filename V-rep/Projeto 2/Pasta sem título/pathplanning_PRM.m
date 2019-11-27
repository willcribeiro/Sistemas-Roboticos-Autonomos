function yourpath = pathplanning_PRM(S, G, n, O)
    % Walter Manger -  CIS 4939 - Introduction to Robotics
    % Assignment 6
    % S = Start(x,y) Point
    % G = Goal(x,y) Point
    % n = Number of obsticals
    % O = Obstacle points (x1 y1; x2 y2)
    % Returns a list of XY coords that is the shortest path from start to goal
    
    % Call Like This
    % With 2 obsticles
    %S = [1,1];
    %G = [7,7]; 
    %n = 2; 
    %O = [[2 2; 4 4]', [6 6; 8 5]'];
    %yourpath = pathplanning_PRM(S, G, n, O);
    
    yourpath = 0;


    % Settings
    TotalNumberOfNodes = 10; %60;
    roomWidth = 5;
    roomLength = 5;
    MinDistanceBetweenNodes = 1;
    MaxDistanceBetweenNodes = 3;
    
    %1. R = (N, E)  begins empty
    %2. A random free configuration c is generated and added to N
    %3a. Candidate neighbors to c are partitioned from N
    %3b. Edges are created between these neighbors and c, such that acyclicity is preserved
    %4. Repeat 2-3 until “done”

    k = 5; % Number of neighbors evaluated
    N = []; % Nodes (Coords)
    E = []; % Edges (Lines)
    %R = (N, E); % I am assuming this is going to be a list of nodes' coords
    AdjacencyMatrix = zeros(roomWidth + 2, roomLength + 2);
    

    %% 5.4.1 Sampling the Configuration Space

    X_Coordinates = zeros(TotalNumberOfNodes + 2);
    Y_Coordinates = zeros(TotalNumberOfNodes + 2);
    
    % Generate Random Nodes
    nodeCount = 1;
    
    % Add the start
    X_Coordinates(1) = S(2); 
    Y_Coordinates(1) = S(1);
    
    N(nodeCount, :) = [S(2), S(1)];
    
    while nodeCount < TotalNumberOfNodes + 1
       
        x = randi(roomWidth);
        y = randi(roomWidth);
        
        if PointIsInObsticles(O, n, x, y) == 0 
            if PointInCollection(N, x, y) == 0
                if IsStartOrGoal(x, y, S(2), S(1), G(2), G(1))  == 0
                    nodeCount = nodeCount + 1;
                    X_Coordinates(nodeCount) = x; 
                    Y_Coordinates(nodeCount) = y;
                    N(nodeCount, :) = [x, y];
                end
            end
        end
        
    end

    X_Coordinates(TotalNumberOfNodes + 2) = G(2);
    Y_Coordinates(TotalNumberOfNodes + 2) = G(1);

    N(TotalNumberOfNodes + 2, :) = [G(2), G(1)];
    
    %% 5.4.2 Connecting Pairs of Configurations
 
    for q = 1:TotalNumberOfNodes + 2

        % Select a Random c from the list of nodes
        p = randi(TotalNumberOfNodes, 1);

        % Random configuration from nodes
        c = [X_Coordinates(p), Y_Coordinates(p)];

        % Check against all other existing nodes
        for i = 1:TotalNumberOfNodes + 2

            if(i ~= p)

                y1 = c(1);
                y2 = Y_Coordinates(i);
                x1 = c(2);
                x2 = X_Coordinates(i);
                
                % Check distance
                % Only nodes whose distance is within the min/max are added
                d = sqrt((y2-y1)^2 + (x2-x1)^2);

                if d <= MaxDistanceBetweenNodes && d >= MinDistanceBetweenNodes

                    % Check if there is an obsticle
                    % For each obsticle, check to see if the line is connected
                    if LineIsInObsticles(O, n, x1, y1, x2, y2) == 0 
                        AdjacencyMatrix(p, i) = 1;
                        AdjacencyMatrix(i, p) = 1;
                        
                        x = x1:.001:x2;
                        y = y1:.01:y2;

                        plot(x,y);
                    end 
                end
            end
        end

    end

    disp(AdjacencyMatrix);
    disp(N);

%% Query Phase

    % Attempted bfs
    
    % Start Node
    visited = [];
    open = [];
    openIndex = 1;
    visitedIndex = 1;
    
    visited(visitedIndex, :) = [1, 1]; % Start Node
    
    [rows, cols] = size(AdjacencyMatrix);
    
    % Fill First Neighbors
    for col = 1:cols
        if AdjacencyMatrix(1,col) == 1
            open(openIndex, :) = [1, col];
            openIndex = openIndex + 1;
        end
    end
    
    
    
    while isempty(open) == 0
        
       current = open(1, :); % First element
       openIndex = openIndex - 1;
       open(1, :) = []; % remove the first element
       
       visitedIndex = visitedIndex + 1;
       visited(visitedIndex, :) = current;
       
       for col = current(1)+1:cols
           if AdjacencyMatrix(current(2), col) == 1
                open(openIndex, :) = [current(2), col];
                openIndex = openIndex + 1;
            end
       end
        
    end

    %disp(visited);
    %disp(open);
    
    for i = 1:visitedIndex
        
        % visited = [1, 4]
        
        disp(N(visited(i, 1)));
        disp(N(visited(i, 2)));
    end
    
    
end

function is = IsStartOrGoal(x, y, sx, sy, gx, gy)
	
    is = 0;
    
    if (x == sx && y == sy) || (x == gx && y == gy) 
        is =1; 
    end
    
    
end

function exists = ElementExists(E, elem)

exists = 0;

[r,~] = size(E);

for i = 1:r
    
    if E(i, 1) == elem(1) && E(i, 2) == elem(2)
        exists = 1;
        break;
    end
    
    if E(i, 3) == elem(1) && E(i, 4) == elem(2)
        exists = 1;
        break;
    end
end
end

function isIn = PointIsInObsticles(O, n, x, y)

    isIn = 0;

    for index = 1:n*2 
        if mod(index,2) ~= 0
            
            % Get the two X Y vectors / corners of the obsticle
            
            Oi1 = O(:,index); 
            Oi2 = O(:,index + 1);

            %  --------
            %  |  .   |
            %  |      |
            %  --------
 
            % Calculate the start and end ranges
            
            Start_Y = min([Oi1(2),Oi2(2)]);
            End_Y = max([Oi1(2),Oi2(2)]);

            
            Start_X = min([Oi1(1),Oi2(1)]);
            End_X = max([Oi1(1),Oi2(1)]);
            
            % If x or y is in the range of the rectangle x and y
            % break and return 1
            
            if x >= Start_X && x <= End_X && y >= Start_Y && y <= End_Y
               isIn = 1;
               break;
            end
 
        end
    end

end

function isIn = PointIsInObsticle(Oi1, Oi2, x, y)

    isIn = 0;

    %  --------
    %  |   .  |
    %  |      |
    %  --------

    % Calculate the start and end ranges

    Start_Y = min([Oi1(2),Oi2(2)]);
    End_Y = max([Oi1(2),Oi2(2)]);


    Start_X = min([Oi1(1),Oi2(1)]);
    End_X = max([Oi1(1),Oi2(1)]);

    % If x or y is in the range of the rectangle x and y
    % break and return 1

    if x >= Start_X && x <= End_X && y >= Start_Y && y <= End_Y
       isIn = 1;
    end


end

function isIn = LineIsInObsticles(O, n, x1, y1, x2, y2)

    isIn = 0;

    [m, b] = SlopeIntercept(x1, y1, x2, y2);

    for index = 1:n*2 
        if mod(index,2) ~= 0
            
            % Get the two X Y vectors / corners of the obsticle
            
            Oi1 = O(:,index); 
            Oi2 = O(:,index + 1);

            %  ------/-
            %  |   /  |
            %  | /    |
            %  /-------
 
            % Calculate the start and end ranges
            
            Start_Y = min([Oi1(2),Oi2(2)]);
            End_Y = max([Oi1(2),Oi2(2)]);

            
            Start_X = min([Oi1(1),Oi2(1)]);
            End_X = max([Oi1(1),Oi2(1)]);
              
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

end

function inCollection = PointInCollection(N, x, y)
    
    inCollection = 0;
    
    [m, n] = size(N);
    
    for i = 1:m
       if N(i,:) == [x, y]
          inCollection = 1; 
          break;
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