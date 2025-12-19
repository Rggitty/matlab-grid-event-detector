%% Plotting

function plot_results(t, v, i, metrics, eventTable)

figure('Position',[100 100 1200 800]);

subplot(3,1,1);
plot(t, v); grid on;
ylabel('Voltage (V)');
title('Waveforms and Detected Events');

subplot(3,1,2);
plot(t, i); grid on;
ylabel('Current (A)');

subplot(3,1,3);
plot(metrics.tr, metrics.Vrms); grid on;
ylabel('V_{RMS} (V)');
xlabel('Time (s)');

% Overlay event windows on all subplots
for r = 1:height(eventTable)
    s = eventTable.startTime_s(r);
    e = eventTable.endTime_s(r);
    typ = string(eventTable.eventType(r));

    for sp = 1:3
        subplot(3,1,sp); hold on;
        yL = ylim;
        patch([s e e s],[yL(1) yL(1) yL(2) yL(2)], [0.9 0.9 0.9], ...
            'FaceAlpha',0.2,'EdgeColor','none');
        text(s, yL(2) - 0.05*(yL(2)-yL(1)), typ, 'FontSize',8);
    end
end
end
