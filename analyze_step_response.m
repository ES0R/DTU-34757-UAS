function response_info = analyze_step_response(simout)
    % analyze_step_response - Analyze step response characteristics.
    % 
    % Inputs:
    %   simout - Time series data from Simulink output (typically logged to workspace)
    %
    % Outputs:
    %   response_info - Structure containing step response characteristics
    %                   including rise time, settling time, overshoot, and peak time.

    % Ensure the input is a time series object
    if ~isa(simout, 'timeseries')
        error('Input must be a time series object');
    end
    
    % Extract the time and data from the timeseries
    time = simout.Time;
    data = simout.Data;

    % Use MATLAB's stepinfo function to analyze the step response
    response_info = stepinfo(data, time);
    
    % Display the response characteristics
    disp('Step Response Characteristics:');
    disp(response_info);
end
