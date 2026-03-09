function [A, B, C] = vehicle_model(speed)
%VEHICLE_MODEL  Continuous-time state-space matrices for lateral error dynamics.
%
%  [A, B, C] = vehicle_model(speed)
%
%  Inputs:
%    speed — longitudinal velocity used for linearisation [m/s]
%
%  Vehicle parameters (Caf, Car, lf, lr, m, Iz) are read directly from
%  the base workspace (created by vehicle_parameters.m).
%
%  Outputs:
%    A — 4×4 state matrix  (bicycle-model lateral error dynamics)
%    B — 4×1 input matrix  (front-wheel steering angle delta)
%    C — 1×4 output matrix (measures e1)
%
%  States : [e1; de1; e2; de2]  (lateral deviation & heading error)
%  Input  : delta (front-wheel steering angle)

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

    B = [0; 2*Caf/m; 0; 2*lf*Caf/Iz];

    C = [1, 0, 0, 0];   % measure e1
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
