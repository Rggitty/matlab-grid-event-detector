# MATLAB Grid Event Detector (Project 6A)

Detects power quality events (voltage sag, swell, and transient spikes) from simulated 60 Hz voltage/current waveforms.

## Features
- Generates realistic waveforms with injected events
- Computes sliding window RMS and power metrics (Vrms, Irms, P, S, PF)
- Logs detected events with start and end time, duration, and severity
- Saves plots and event log to results ( a sperate folder in the same project folder)

## How to Run
Open MATLAB in the repo folder and run:

```matlab
run("src/main.m")

or in Git Bash

matlab -batch "run('src/main.m')"