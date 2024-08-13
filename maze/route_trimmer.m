function simplified_route = simplify_route_xy(route)
    % simplify_route_xy - Simplifies a route by removing unnecessary waypoints
    % along straight lines in the x and y directions.
    %
    % Inputs:
    %   route - Nx3 matrix where each row represents a waypoint [x, y, z].
    %
    % Outputs:
    %   simplified_route - Mx3 matrix of simplified waypoints (M <= N).

    % Initialize the simplified route with the first waypoint
    simplified_route = route(1, :);
    
    % Loop through the route and identify changes in direction
    for i = 2:size(route, 1) - 1
        % Calculate the differences in x, y, and z directions
        delta1 = route(i, :) - route(i-1, :);
        delta2 = route(i+1, :) - route(i, :);
        
        % Check if the direction changes in either x or y
        if ~(isequal(sign(delta1(1:2)), sign(delta2(1:2))))
            % If there's a change in direction, keep the waypoint
            simplified_route = [simplified_route; route(i, :)];
        end
    end
    
    % Add the last waypoint to the simplified route
    simplified_route = [simplified_route; route(end, :)];
end
