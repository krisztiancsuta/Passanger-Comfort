function [Kmpc, Ky, H, Phi_Phi, Phi_F, Phi_R, F, Phi, A_e, B_e, C_e, Ad, Bd, Bd2, Cd] = MPC_synthesis(speed, Ts, Nc, Np, rw)
%MPC_SYNTHESIS  Compute MPC gains and prediction matrices for lateral error dynamics.
%
%  [Kmpc, Ky, H, Phi_Phi, Phi_F, Phi_R, F, Phi, A_e, B_e, C_e, Ad, Bd, Bd2, Cd] = ...
%      MPC_synthesis(speed, Ts, Nc, Np, rw)
%
%  Inputs:
%    speed — longitudinal velocity for linearisation [m/s]
%    Ts    — discrete sample time [s]
%    Nc    — control horizon steps
%    Np    — prediction horizon steps
%    rw    — control-increment penalty weight (scalar)
%
%  Vehicle parameters (Caf, Car, lf, lr, m, Iz) are read from the base
%  workspace by vehicle_model().
%
%  Outputs:
%    Kmpc        — 1×(n+m1) augmented-state feedback gain
%    Ky          — 1×m1    reference tracking gain
%    H           — Nc×Nc   QP Hessian (Phi_Phi + rw*I)
%    Phi_Phi     — (Nc*n_in)×(Nc*n_in) quadratic cost matrix Phi'*Q*Phi
%    Phi_F       — (Nc*n_in)×(n+m1) free-response prediction matrix
%    Phi_R       — Np×m1   reference prediction matrix
%    F           — (Np*m1)×(n+m1) free output evolution matrix
%    Phi         — (Np*m1)×(Nc*n_in) control prediction matrix
%    A_e, B_e, C_e — augmented state-space matrices
%    Ad, Bd, Bd2, Cd — discrete plant matrices (control & disturbance inputs)
%
%  Dependencies on the MATLAB path:
%    - vehicle_model.m   (LateralControllers/Others)
%    - mpcgain.m         (LateralControllers/Others)

    %% Continuous-time lateral error dynamics
    [Ac, Bc, Cc, Bc2] = vehicle_model(speed);

    %% Discretise via zero-order hold (state-space, control + disturbance)
    c_ss = ss(Ac, [Bc, Bc2], Cc, 0);
    d_ss = c2d(c_ss, Ts);

    Ad  = d_ss.A;
    Bd  = d_ss.B(:, 1);   % steering angle input
    Bd2 = d_ss.B(:, 2);   % yaw-rate disturbance
    Cd  = d_ss.C;

    %% MPC prediction matrices (augmented model built inside mpcgain)
    [Phi_Phi, Phi_F, Phi_R, A_e, B_e, C_e, F, Phi] = mpcgain(Ad, Bd, Cd, Nc, Np);
    
    [~, n_in] = size(Bd);

    %% QP Hessian
    H = Phi_Phi + rw * eye(Nc * n_in);

    %% Unconstrained receding-horizon gains (first control move only)
    Kmpc = H \ Phi_F;
    Ky   = H \ Phi_R;
    

    Kmpc = Kmpc(1:n_in, :);   % first move — state feedback
    Ky   = Ky(1:n_in, :);     % first move — reference gain
end