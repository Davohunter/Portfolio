clc, clearvars
% WMQ PROJECT EXAM - David Rychly january 2023
tic
%-------------------------------------------------------------------------------------------------------------
% 1) Energy total, energy barriers for changing the spin

% 1.0) INPUT
A = 1 ; % Const for sin theta [-]
H1 = 0 ; % Intensity of magnetic field [A*m^-1]
H2 = 0.3 ; % -//-
H3 = -0.3 ; % -//-
theta = -2:0.0001:2 ; % Orientation of spin [rad] - plotted longer than is the real changing of the spin from -pi/2 to pi/2

%--------------------------------------------------------------------------------------------------------------
% 1.1) Calculation and extremes of function of Total Energy for zero magnetic field

E1 = ((-A*((sin(theta)).^2))- (H1*theta)) ; % E1 = Total energy of particle in zero magnetic field H1

TF1 = islocalmin(E1) ;      % Figuring out local minimum of E1
Xmin_E1 = theta(find(TF1));
Ymin_E1 = E1(find(TF1));

TF2 = islocalmax(E1) ;      % Figuring out local maximum of E1
Xmax_E1 = theta(find(TF2));
Ymax_E1 = E1(find(TF2));

FE1 = @(theta,A,H1)((-A*((sin(theta)).^2))- (H1*theta)) ;
dE1 = abs(FE1(Xmin_E1,A,H1) - FE1(Xmax_E1,A,H1));           %Calculation of dE1, meaning energetic barrier

%----------------------------------------------------------------------------------------------------------------
% 1.2) Calculation and extremes of function of Total energy for non-zero positive magnetic field

E2 = ((-A*((sin(theta)).^2))- (H2*theta)) ; % E2 = total energy of particle in magnetic field H2 = 0.3 A/m

TF3 = islocalmin(E2) ;      % Figuring out local minimum of E2
Xmin_E2 = theta(find(TF3));
Ymin_E2 = E2(find(TF3));

TF4 = islocalmax(E2) ;      % Figuring out local maximum of E2
Xmax_E2 = theta(find(TF4));
Ymax_E2 = E2(find(TF4));

FE2 = @(theta,A,H2)((-A*((sin(theta)).^2))- (H2*theta)) ;
dE2 = abs(FE2(Xmin_E2,A,H2) - FE2(Xmax_E2,A,H2));         %Calculation of dE2, meaning energetic barrier
%----------------------------------------------------------------------------------------------------------------
% 1.3) Calculation and extremes of function of Total energy for non-zero negative magnetic field

E3 = ((-A*((sin(theta)).^2))- (H3*theta)) ; % % E3 = total energy of particle in magnetic field H3 = -0.3 A/m

TF5 = islocalmin(E3) ;         % Figuring out local minimum of E3
Xmin_E3 = theta(find(TF5));
Ymin_E3 = E3(find(TF5));

TF6 = islocalmax(E3) ;         % Figuring out local maximum of E3
Xmax_E3 = theta(find(TF6));
Ymax_E3 = E3(find(TF6));

FE3 = @(theta,A,H3)((-A*((sin(theta)).^2))- (H3*theta)) ;
dE3 = abs(FE3(Xmin_E3,A,H3) - FE3(Xmax_E3,A,H3));           %Calculation of dE3, meaning energetic barrier

%----------------------------------------------------------------------------------------------------------------
% 1.4) Graphical representation of both energies
figure
plot(theta,E1,theta(TF1),E1(TF1),'r*',theta(TF2),E1(TF2),'r*',theta,E2,theta(TF3),E2(TF3),'g*',theta(TF4),E2(TF4),'g*')             % ,thetan,dE1 ,thetam,dE2 ; ,theta,E3,theta(TF5),E3(TF5),'b*',theta(TF6),E3(TF6),'b*'
legend('E1 na theta','minima E1','maxima E1','E2 na theta','minima E2','maxima E2')                                             %'dE1 na thetan''dE2 na thetam';'E3 na theta','minima E3','maxima E3'
xlabel('theta [rad]')
ylabel('E [J]')
xlim([-2,2])
ylim([-2,0.5])
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 1); % X axis.
axis on
grid on

%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
% 2) Master rovnice - function of spin rotation probability on time

% 2.0) Definition of parameters
% INPUT
t0 = 0     ;             % Initial time t0, [s]
tmax = 1  ;              % Final time tmax, [s]
dt = 1e-6 ;              % Step for discretization [s]
dE = dE2 ;               % choose dE1 pro H =0, dE2 pro H=0.3, dE3 pro H=-0.3 Energetic barrier for rotating the spin
kT = A   ;               % Boltzmann const [J/K] * Absolute temperature [K] -> [J]
P0 = 0.5   ;             % Initial probability that spin is rotated upwards [-]
v0 = 42.58 ;             % Maximal frequence of spin rotation (change the side) [1/s] -> chosen based on Larmor frequence for electron = 42,58 MHz
                         % For speeding up the result and reducing the
                         % computation difficulty, we use 42.58 Hz instead
                         % of 42.58 MHz (verified as OK, its only const)
%-------------------------------------------------------------------------------------------
% 2.1) Calculation the spin flipping frequency

v = v0*exp((-dE)/(kT));
v1 = v(1);
v2 = v(2);

%dP/dt = ((1-P)*v1)-(P*v2)        MASTER EQUATION 

t = [t0:dt:tmax] ;   % Time interval in which we measure the P, [s] 
[t,P] = ode45(@(t,P)(((1-P)*v1)-(P*v2)),t,P0);  % Solving analytically the Master equation using tool ODE45
                                                % Heh, lecturer told me at the exam that I was supposed to do this via
                                                % iterative process, but my
                                                % solution is unexpected and good.
                                                
%----------------------------------------------------------------------------------------------------------------
% 2.2) Graphical representation of both energies
figure
plot(t,P)
legend('zavislost P na dt')
xlabel('dt [s]')
ylabel('P [-]')
ylim([0,1])
axis on
grid on

toc


%GRAVEYARD
%thetan = linspace(min(theta),max(theta),numel(theta)-1) ;
%dE1 = diff(E1)./diff(theta) ;
%thetam = linspace(min(theta),max(theta),numel(theta)-1) ;
%dE2 = diff(E2)./diff(theta) ;
%thetal = linspace(min(theta),max(theta),numel(theta)-1) ;
%dE2 = diff(E2)./diff(theta) ;