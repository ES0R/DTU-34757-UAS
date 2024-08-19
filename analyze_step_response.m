
function response_info = analyze_step_response(simout)
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
    data = simout.Data(:,3,:);
    data = reshape(simout.Data(:,3,:), [126, 1]);
    size(data)
    size(time)
    % Preallocate a structure to hold the response information for each dimension
    response_info = struct();

    response_info = stepinfo(data, time);

   
end

