function route = findRouteDFS(map, A, B)
    % Initialize the start and end points
    startNode = A;
    endNode = B;
    
    % Initialize visited matrix for each layer
    visited = false(size(map));
    
    % Initialize the route
    route = [];
    
    % Call DFS
    [found, route] = DFS(map, startNode, endNode, visited, route);
    if ~found
        route = []; % No route found
    end
end

function [found, route] = DFS(map, currentNode, endNode, visited, route)
    % Mark the current node as visited
    visited(currentNode(1), currentNode(2), currentNode(3)) = true;
    
    % Add the current node to the route
    route = [route; currentNode];
    
    % Check if the current node is the end node
    if isequal(currentNode, endNode)
        found = true;
        return;
    end
    
    % Direction vectors for moving in 4 directions on the same layer
    directions = [0 1 0; 1 0 0; 0 -1 0; -1 0 0];
    
    % Explore neighbors
    for i = 1:size(directions, 1)
        neighbor = currentNode + directions(i, :);
        
        % Check if the neighbor is within the map bounds and not an obstacle
        if isValid(neighbor, map, visited)
            [found, route] = DFS(map, neighbor, endNode, visited, route);
            if found
                return;
            end
        end
    end
    
    % Backtrack if no route is found
    route(end, :) = [];
    found = false;
end

function valid = isValid(node, map, visited)
    [rows, cols, layers] = size(map);
    valid = node(1) > 0 && node(1) <= rows && ...
            node(2) > 0 && node(2) <= cols && ...
            node(3) > 0 && node(3) <= layers && ...
            map(node(1), node(2), node(3)) == 0 && ...
            ~visited(node(1), node(2), node(3));
end

layer1 = [0 0 0 0 0 0 0 0 0 0;
          0 1 0 1 1 1 1 1 1 0;
          1 1 0 1 1 0 0 0 1 0;
          0 0 0 0 1 0 1 0 1 0;
          0 1 1 0 0 0 1 0 0 0;
          0 0 1 1 1 1 1 1 1 0;
          1 0 0 0 1 0 0 0 1 0;
          1 1 1 0 0 0 1 0 1 0;
          1 1 1 1 1 1 1 0 1 0;
          0 0 0 0 0 0 0 0 0 0];

map = [0 0 0 0 0 0 0 0 0 0;
       0 1 0 1 1 1 1 1 1 0;
       1 1 0 1 1 0 0 0 1 0;
       0 0 0 0 1 0 1 0 1 0;
       0 1 1 0 0 0 1 0 0 0;
       0 0 1 1 1 1 1 1 1 0;
       1 0 0 0 1 0 0 0 1 0;
       1 1 1 0 0 0 1 0 1 0;
       1 1 1 1 1 1 1 0 1 0;
       0 0 0 0 0 0 0 0 0 0];


map = zeros(10, 10, 3);
map(:, :, 1) = ~layer1;

A = [1, 1, 1];
B = [4, 6, 1];

route = findRouteDFS(map, A, B);
disp(route);
