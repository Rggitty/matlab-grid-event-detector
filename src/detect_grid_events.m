%% Detecting grid events
%fix later

function eventTable = detect_grid_events(t, v, metrics, cfg)

tr = metrics.tr;
Vrms = metrics.Vrms;

labels = strings(size(Vrms));
labels(Vrms < cfg.sag_threshold) = "SAG";
labels(Vrms > cfg.swell_threshold) = "SWELL";

events = [];
minDur = cfg.min_event_ms/1000;

events = [events; find_runs(tr, Vrms, labels, "SAG", minDur)];
events = [events; find_runs(tr, Vrms, labels, "SWELL", minDur)];
w = 200; 
v_mu = movmean(v, w);
v_sd = movstd(v, w);
z = (v - v_mu) ./ max(v_sd, 1e-6);

spikeIdx = find(abs(z) >= cfg.spike_z);
if ~isempty(spikeIdx)
  
    spikeT = t(spikeIdx);
    spikeRuns = group_time_runs(spikeT, 0.02); 
    for r = 1:size(spikeRuns,1)
        s = spikeRuns(r,1); e = spikeRuns(r,2);
        severity = max(abs(z(t>=s & t<=e)));
        events = [events; {s, e, e-s, "SPIKE", severity}];
    end
end

if isempty(events)
    eventTable = table([],[],[],[],[], 'VariableNames', ...
        {'startTime_s','endTime_s','duration_s','eventType','severity'});
else
    eventTable = cell2table(events, 'VariableNames', ...
        {'startTime_s','endTime_s','duration_s','eventType','severity'});
    eventTable = sortrows(eventTable, "startTime_s");
end
end

function out = find_runs(tr, Vrms, labels, target, minDur)
out = {};
inRun = false;
s = NaN; e = NaN;
sev = NaN;

for k = 1:length(labels)
    if labels(k) == target && ~inRun
        inRun = true;
        s = tr(k);
        sev = abs(Vrms(k));
    elseif labels(k) ~= target && inRun
        e = tr(k-1);
        dur = e - s;
        if dur >= minDur
            out = [out; {s, e, dur, target, sev}];
        end
        inRun = false;
    end

    if inRun
        sev = max(sev, abs(Vrms(k)));
    end
end

if inRun
    e = tr(end);
    dur = e - s;
    if dur >= minDur
        out = [out; {s, e, dur, target, sev}];
    end
end
end

function runs = group_time_runs(times, gap)
times = sort(times(:));
runs = [];
s = times(1); prev = times(1);
for k = 2:length(times)
    if times(k) - prev > gap
        runs = [runs; s, prev];
        s = times(k);
    end
    prev = times(k);
end
runs = [runs; s, prev];
end
