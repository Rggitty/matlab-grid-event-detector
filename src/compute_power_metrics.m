%% Power metrics

function metrics = compute_power_metrics(t, v, i, fs, win_ms, step_ms)

win = round((win_ms/1000)*fs);
step = round((step_ms/1000)*fs);

idxStarts = 1:step:(length(t)-win+1);
M = length(idxStarts);

tr = zeros(M,1);
Vrms = zeros(M,1);
Irms = zeros(M,1);
P = zeros(M,1);   
S = zeros(M,1);   
PF = zeros(M,1);

for m = 1:M
    a = idxStarts(m);
    b = a + win - 1;

    vw = v(a:b);
    iw = i(a:b);

    tr(m) = mean(t(a:b));
    Vrms(m) = sqrt(mean(vw.^2));
    Irms(m) = sqrt(mean(iw.^2));

    p_inst = vw .* iw;
    P(m) = mean(p_inst);

    S(m) = Vrms(m) * Irms(m);
    if S(m) > 0
        PF(m) = P(m) / S(m);
    else
        PF(m) = NaN;
    end
end

metrics = table(tr, Vrms, Irms, P, S, PF);
end
