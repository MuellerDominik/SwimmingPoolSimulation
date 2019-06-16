%% Swimming Pool Simulation
% created by Pascal Fankhauser, Nico Canzani and Dominik Mueller

clear all; clc;

% Run time
t_run = 20; % days

% Pool dimensions
l = 8.1; % m
w = 4; % m
h = 1.5; % m

% Pool surfaces
A_water = l*w; % m^2
A_tank = 2*w*h + 2*l*h + l*w; % m^2

% Water circulation time
circ_time = 10; % h
MFR = 1000*l*w*h/(8*3600); % kg/s

% Heater (Plumbing etc.)
P_Heater = 4500; % W

r = 0.05; % m
Dh = 2*r; % m
PA = r^2 * pi; % m^2
H_length = 0.5; % m

% -------------------------------------------------------------------------
% Environment calculations
% Air temperatures
T_Amin = 8; % °C
T_Amax = 19; % °C

h_pool_air = 10; % W/(m^2 * K)

% Ground temperatures
T_Gmin = (T_Amax + T_Amin)/2 - 1; % °C
T_Gmax = (T_Amax + T_Amin)/2 + 1; % °C
P_air_ground = pi/4; % 3 h delay with respect to the air temperature

% Thermal insulance of soil
Rth_G = 0.2; % (m^2 * K)/W

% Perpendicular solar power
P_Sperp = 1.36e3; % W

% Absorption coefficient of water (avereaged)
k_water = [0.2 0.2 0.06 0.02 0.025 0.05 0.2 0.32 0.65];
k = mean(k_water);

% Solar power
absorption = 1 - exp(-2*k*h); % ()
P_Smax = absorption*P_Sperp; % W

% -------------------------------------------------------------------------
% Simscape model
mdl = 'SwimmingPoolSimulationModel';

% Start time
set_param(mdl, 'StartTime', '0.0');
% Stop time
set_param(mdl, 'StopTime', num2str(t_run*24*3600));

% Open model
% open(mdl);
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
