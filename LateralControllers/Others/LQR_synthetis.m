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

    %% Get lateral error dynamics from vehicle_model
    [A, B1, C] = vehicle_model(speed);

    %% Augment with integrator on e1
    A_ext = [A, zeros(4, 1); -C, 0];
    B_ext = [B1; 0];

    %% Discrete LQR
    K = lqrd(A_ext, B_ext, Q, R, Ts);
end
