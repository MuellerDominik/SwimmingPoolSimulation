%% Swimming Pool Simulation
% created by Pascal Fankhauser, Nico Canzani and Dominik Mueller

clear all; close all; clc;

% Run time
t_run = 50; % days

% Desired temperature
T_P = 30; % °C
Hysteresis = 2; % °C

% Temperatures
min_temp = T_P - Hysteresis/2 + 273.15;
max_temp = T_P + Hysteresis/2 + 273.15;

% Pool dimensions
l = 8.1; % m
w = 4; % m
h = 1.5; % m

% Pool surfaces
A_water = l*w; % m^2
A_tank = 2*w*h + 2*l*h + l*w; % m^2

% Pool volume
V_pool = l*w*h;

% Water
c_water = 4184;
q_water = 2257e3;

% Water circulation time
circ_time = 48; % h
MFR = 1000*l*w*h/(circ_time*3600); % kg/s

% Heater (Plumbing etc.)
P_Heater = 4707; % W

r = 0.05; % m
Dh = 2*r; % m
PA = r^2 * pi; % m^2
H_length = 0.5; % m

% -------------------------------------------------------------------------
% Environment calculations
% Air temperatures
T_Amin = 8; % °C
T_Amax = 19; % °C

h_pool_air = 8; % W/(m^2 * K)

% Ground temperatures
T_Gmin = (T_Amax + T_Amin)/2 - 1; % °C
T_Gmax = (T_Amax + T_Amin)/2 + 1; % °C
P_air_ground = pi/4; % 3 h delay with respect to the air temperature

% Thermal insulance of soil
Rth_G = 2; % (m^2 * K)/W

% Perpendicular solar power
P_Sperp = 1.36e3; % W

% Absorption coefficient of water (avereaged)
k_water = [0.2 0.2 0.06 0.02 0.025 0.05 0.2 0.32 0.65];
k = mean(k_water);

% Solar power
absorption = 1 - exp(-2*k*h); % ()
P_Smax = absorption*P_Sperp; % W

% Evaporation
% (https://imsc.uni-graz.at/keeling/modI_ss13/projekten/HaschekSteuberBericht.pdf)
m_ev = (109.6 + 3.9) / 50; % kg / d
P_ev = m_ev * ((100-20) * c_water + q_water) / 24 / 3600; % W 

% -------------------------------------------------------------------------
% Simscape model
mdl = 'SwimmingPoolSimulationModel';

% Open model
open(mdl);
% Set start time
set_param(mdl, 'StartTime', '0.0');
% Set stop time
set_param(mdl, 'StopTime', num2str(t_run*24*3600));
% Set max step size (for better accuracy)
set_param(mdl, 'MaxStep', '100');

% Numerical solution
sim(mdl);

% -------------------------------------------------------------------------
% Pool temperature
figure('Name', 'Swimming Pool Temperature');
plot(sim.time/24/3600, sim.data-273.15);
title('Swimming Pool Temperature');
grid on; xlabel('Time t (days)'); ylabel('Temperature T (°C)');

% Environment
figure('Name', 'Environment');
subplot(3,1,1);
plot(solar.time/24/3600, solar.data);
title('Solar Power');
grid on; xlabel('Time t (days)'); ylabel('Solar power P_S (W)');

subplot(3,1,2);
plot(air.time/24/3600, air.data);
title('Air Temperature');
grid on; xlabel('Time t (days)'); ylabel('Air Temperature T_A (°C)');

subplot(3,1,3);
plot(gnd.time/24/3600, gnd.data);
title('Ground Temperature');
grid on; xlabel('Time t (days)'); ylabel('Ground Temperature T_G (°C)');
