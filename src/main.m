%% Main stuff

fs = 5000;          
T  = 10;            
f0 = 60;            

V_nom_rms = 120;    
I_nom_rms = 8;      
pf_nom    = 0.90;   
noisePct  = 0.01;   



events = {
    2.0  2.7  "sag"   0.75;   
    5.0  5.6  "swell" 1.20;   
    7.2  7.25 "spike" 2.5;    
};

%generating data
[t, v, i] = generate_waveforms(fs, T, f0, V_nom_rms, I_nom_rms, pf_nom, noisePct, events);


win_ms = 100; 
step_ms = 10; 
metrics = compute_power_metrics(t, v, i, fs, win_ms, step_ms);


cfg.sag_threshold   = 0.90 * V_nom_rms;  
cfg.swell_threshold = 1.10 * V_nom_rms;  
cfg.min_event_ms    = 30;                
cfg.spike_z         = 6;                 

[eventTable] = detect_grid_events(t, v, metrics, cfg);


if ~exist("results","dir"), mkdir("results"); end
writetable(eventTable, fullfile("results","event_log.csv"));

plot_results(t, v, i, metrics, eventTable);

saveas(gcf, fullfile("results","summary_plots.png"));

disp("Done. Outputs saved to results folder");
disp(eventTable);
