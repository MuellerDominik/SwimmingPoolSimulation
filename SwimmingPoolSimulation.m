%% Swimming Pool Simulation
% created by Pascal Fankhauser, Nico Canzani and Dominik Mueller

clear all; close all; clc;

% -------------------------------------------------------------------------
% Parameters --------------------------------------------------------------
% -------------------------------------------------------------------------

% Run time
t_run = 30; % days

% Desired temperature
T_P = 30; % °C
Hysteresis = 1; % °C

% Air temperature
% (determines ground temperature)
T_Amin = 8; % °C
T_Amax = 19; % °C

% Pool dimensions
l = 8.1; % m
w = 4; % m
h = 1.5; % m

% Water circulation time
circ_time = 48; % h

% Heater (Power and Plumbing)
P_Heater = 3530; % W
R_Heater = 15; % Ohm

r = 0.05; % m
H_length = 0.5; % m

% -------------------------------------------------------------------------
% Calculations ------------------------------------------------------------
% -------------------------------------------------------------------------

% Temperatures (Controller)
min_temp = T_P - Hysteresis/2 + 273.15; % K
max_temp = T_P + Hysteresis/2 + 273.15; % K

% Pool surfaces
A_water = l*w; % m^2
A_tank = 2*w*h + 2*l*h + l*w; % m^2

% Pool volume
V_pool = l*w*h; % m^3

% Mass flow rate
MFR = 1000*V_pool/(circ_time*3600); % kg/s

% Heater (Power and Plumbing)
U_Heater = sqrt(P_Heater*R_Heater);

Dh = 2*r; % m
PA = r^2 * pi; % m^2

% Used constants (Water)
c_water = 4184;
q_water = 2257e3;

% -------------------------------------------------------------------------
% Environment calculations ------------------------------------------------
% -------------------------------------------------------------------------

% Heat transfer coefficient (Convection)
h_pool_air = 8; % W/(m^2 * K)

% Ground temperature (derived from the air temperature)
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
m_ev = (109.6 + 3.9)/50; % kg/day

% -------------------------------------------------------------------------
% Simscape ----------------------------------------------------------------
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
% Plots -------------------------------------------------------------------
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
grid on; xlabel('Time t (days)'); ylabel('Solar Power P_S (W)');

subplot(3,1,2);
plot(evap.time/24/3600, evap.data);
title('Evaporation Power');
grid on; xlabel('Time t (days)'); ylabel('Evaporation Power P_E (W)');

subplot(3,1,3);
plot(air.time/24/3600, air.data, 'DisplayName','Air Temperature'); hold on;
plot(gnd.time/24/3600, gnd.data, '--', 'DisplayName','Ground Temperature');
hold off; title('Temperatures'); legend;
grid on; xlabel('Time t (days)'); ylabel('Temperature T (°C)');

% Heater
figure('Name', 'Heater Power');
plot(heater.time/24/3600, heater.data);
title('Heater Power');
grid on; xlabel('Time t (days)'); ylabel('Heater Power P_H (W)');
