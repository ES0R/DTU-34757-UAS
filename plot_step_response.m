function plot_step_response(position_signal, step)
    % Analyze the step response
    step_response = analyze_step_response(position_signal);
    
    % Extract step info
    rise_time = step_response.RiseTime;
    settling_time = step_response.SettlingTime;
    overshoot = step_response.Overshoot;
    undershoot = step_response.Undershoot;
    % Plot the step response
    
    %data = position_signal.Data(:,3,:);
    data = position_signal.Data(:,2);
    size(data)



    figure;
    plot(position_signal.Time, data, 'b', 'LineWidth', 1.5);
    hold on;
    
    % Mark the rise time, settling time, and overshoot on the plot
    step_line = yline(step, 'r--', 'Step Input', 'LineWidth', 1.5);  % Reference line at step input level
    step_line.LabelVerticalAlignment = 'bottom';
    step_line.LabelHorizontalAlignment = 'right';


    rise_line=xline(rise_time, '--', sprintf('Rise Time: %.2fs', rise_time), 'Color', [0, 0.5, 0], 'LineWidth', 1.5);
    rise_line.LabelVerticalAlignment = 'middle';

    settling_line = xline(settling_time, '--', sprintf('Settling Time: %.2fs', settling_time),'Color', [0.8, 0, 0.6] , 'LineWidth', 1.5);
    settling_line.LabelVerticalAlignment = 'middle';

    if overshoot > 0
        yline(step * (1+overshoot/100), 'r--', sprintf('Overshoot: %.2f%%', overshoot), 'LineWidth', 1.5);
    end
    

    % Set plot labels and title
    xlabel('Time (s)');
    ylabel('Position');
    title('Step Response');
    grid on;
    legend('Response', 'Step Input', 'Rise Time', 'Settling Time', 'Overshoot/Undershoot', 'Location', 'Best');
    
    hold off;
end
