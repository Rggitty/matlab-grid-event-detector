%%Waveform generators

function [t, v, i] = generate_waveforms(fs, T, f0, V_nom_rms, I_nom_rms, pf_nom, noisePct, events)
N = round(fs*T);
t = (0:N-1)'/fs;

Vpk = V_nom_rms*sqrt(2);
Ipk = I_nom_rms*sqrt(2);

phi = acos(max(min(pf_nom,1),-1)); 

v = Vpk*sin(2*pi*f0*t);
i = Ipk*sin(2*pi*f0*t - phi);

for k = 1:size(events,1)
    t1 = events{k,1}; t2 = events{k,2};
    typ = events{k,3}; mag = events{k,4};

    idx = (t >= t1) & (t <= t2);
    switch typ
        case "sag"
            v(idx) = mag * v(idx);
        case "swell"
            v(idx) = mag * v(idx);
        case "spike"
            tc = (t1+t2)/2;
            sigma = (t2-t1)/6;
            bump = exp(-0.5*((t(idx)-tc)/sigma).^2);
            v(idx) = v(idx) + (mag*Vpk).*bump;
        otherwise
            error("Unknown event type: %s", typ);
    end
end

v = v .* (1 + noisePct*randn(size(v)));
i = i .* (1 + noisePct*randn(size(i)));
end
