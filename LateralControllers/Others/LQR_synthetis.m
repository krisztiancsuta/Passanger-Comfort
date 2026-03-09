function K = LQR_synthetis(speed, Ts, Q, R)
%LQR_SYNTHETIS  Compute discrete LQR gain for the lateral error dynamics.
%
%  K = LQR_synthetis(speed, Ts, Q, R)
%
%  Inputs:
%    speed — longitudinal velocity used for linearisation [m/s]
%    Ts    — discrete sample time [s]
%    Q     — state weighting matrix  (5×5, augmented with integrator)
%    R     — input weighting scalar
%
%  Vehicle parameters (Caf, Car, lf, lr, m, Iz) are read directly from
%  the base workspace (created by vehicle_parameters.m).
%
%  Output:
%    K — 1×5 feedback gain vector [K_e1, K_de1, K_e2, K_de2, K_int]
%
%  The plant is the bicycle-model lateral error dynamics:
%    states : [e1; de1; e2; de2]   (lateral deviation & heading error)
%    input  : delta (front-wheel steering angle)
%  augmented with an integrator on e1 for zero steady-state tracking.

    Caf = getBaseParamValue('Vehicle_CorneringStiffnessFrontAxle');
    Car = getBaseParamValue('Vehicle_CorneringStiffnessRearAxle');
    lf  = getBaseParamValue('Vehicle_CoGFrontWheelsLength');
    lr  = getBaseParamValue('Vehicle_CoGRearWheelsLength');
    m   = getBaseParamValue('Vehicle_Weight');
    Iz  = getBaseParamValue('Vehicle_MomentofInertiaZ');
    Vx  = speed;

    %% Continuous-time state-space (error dynamics)
    A = [0, 1,                              0,                       0; ...
         0, -(2*Caf + 2*Car)/(m*Vx),        (2*Caf + 2*Car)/m,       (-2*lf*Caf + 2*lr*Car)/(m*Vx); ...
         0, 0,                              0,                       1; ...
         0, -(2*lf*Caf - 2*lr*Car)/(Iz*Vx), (2*lf*Caf - 2*lr*Car)/Iz, -(2*lf^2*Caf + 2*lr^2*Car)/(Iz*Vx)];

    B1 = [0; 2*Caf/m; 0; 2*lf*Caf/Iz];

    C = [1, 0, 0, 0];   % measure e1

    %% Augment with integrator on e1
    A_ext = [A, zeros(4, 1); -C, 0];
    B_ext = [B1; 0];

    %% Discrete LQR
    K = lqrd(A_ext, B_ext, Q, R, Ts);
end

%% =======================================================================
%  LOCAL HELPER
%  =======================================================================
function val = getBaseParamValue(name)
%GETBASEPARAMVALUE  Read a Simulink.Parameter's .Value from the base workspace.
    obj = evalin('base', name);
    if isa(obj, 'Simulink.Parameter')
        val = obj.Value;
    else
        val = obj;
    end
end
