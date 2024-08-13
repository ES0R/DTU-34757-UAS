

%%
function response_info = step_response(simout)
    % Analyze step response characteristics for each dimension.
    %
    % Inputs:
    %   simout - Time series data from Simulink output (typically logged to workspace)
    %
    % Outputs:
    %   response_info - Structure containing step response characteristics
    %                   for each dimension including rise time, settling time,
    %                   overshoot, and peak time.

    % Ensure the input is a time series object
    if ~isa(simout, 'timeseries')
        error('Input must be a time series object');
    end
    
    % Extract the time and data from the timeseries
    time = simout.Time;
    data = simout.Data;

    % Preallocate a structure to hold the response information for each dimension
    response_info = struct();

    % Check if the data is multi-dimensional (e.g., 3x1 for [x, y, z])
    if size(data, 2) > 1
        for i = 1:size(data, 2)
            response_info(i) = stepinfo(data(:,i), time);
        end
    else
        % Single dimension case
        response_info = stepinfo(data, time);
    end
    
    % Display the response characteristics
    disp('Step Response Characteristics:');
    disp(response_info);
end

% Step 1: Extract the 'position' signal from logsout
position_signal = out.logsout.getElement('position');

% Step 2: Extract only the 'x' component (assuming x is the first component)
x_data = position_signal.Values.Data(1, :);  % Extract the first column for 'x'
time = position_signal.Values.Time;  % Extract the corresponding time vector

% Step 3: Analyze the step response using the provided function
response_info = stepinfo(x_data, time);

% Step 4: Display the results
disp('Step Response Characteristics for x component:');
disp(response_info);
