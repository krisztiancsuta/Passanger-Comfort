function mpc_controller_gains()
%MPC_CONTROLLER_GAINS  Compute MPC gains and export prediction matrices.
%
%  This function is called by master_init AFTER mpc_controller_params
%  has exported tuning parameters to the base workspace.
%
%  It reads the tuning parameters, calls MPC_synthesis() once to compute
%  all gains and matrices, then stores everything as Simulink.Parameter
%  objects in the base workspace.
%
%  Exported parameters:
%    MPC_FeedbackGainKmpc  — state feedback gain
%    MPC_ReferenceGainKy   — reference tracking gain
%    MPC_H                 — QP Hessian (Phi_Phi + rw*I)
%    MPC_PhiF              — free-response prediction matrix
%    MPC_PhiR              — reference prediction matrix
%    MPC_Ae, MPC_Be, MPC_Ce — augmented state-space model
%    MPC_Bd2               — discrete disturbance matrix (yaw rate)
%
%  Dependencies on the MATLAB path:
%    - MPC_synthesis.m, mpcgain.m, vehicle_model.m (LateralControllers/Others)
%    - mpc_controller_params must have been run first (Shared)
%
%  Location: LateralControllers/Parameters/

    fprintf('\n--- MPC Controller Gains ---\n');

    %% ==================================================================
    %  1.  Read tuning parameters from the base workspace
    % ===================================================================
    Ts             = getBaseParamValue('MPC_SampleTime');
    Vdes           = getBaseParamValue('MPC_DesignSpeed');
    Np             = getBaseParamValue('MPC_Np');
    Nc             = getBaseParamValue('MPC_Nc');
    rw             = getBaseParamValue('MPC_Rw');

    %% ==================================================================
    %  2.  Compute MPC gains and all prediction matrices
    % ===================================================================
    [Kmpc, Ky, H, Phi_F, Phi_R, A_e, B_e, C_e, ~, ~, Bd2, ~] = ...
        MPC_synthesis(Vdes, Ts, Nc, Np, rw);


    %% ==================================================================
    %  3.  Export to base workspace as Simulink.Parameter objects
    % ===================================================================
    exportParam('MPC_FeedbackGainKmpc',  Kmpc,   '', ...
        'Unconstrained MPC state feedback gain');
    exportParam('MPC_ReferenceGainKy',   Ky,     '', ...
        'Unconstrained MPC reference tracking gain');

    exportParam('MPC_H',                 H,      '', ...
        'QP Hessian matrix (Phi''*Q*Phi + rw*I)');
    exportParam('MPC_PhiF',              Phi_F,  '', ...
        'Free-response prediction matrix');
    exportParam('MPC_PhiR',              Phi_R,  '', ...
        'Reference prediction matrix');

 
    exportParam('MPC_Ae',   A_e,  '', 'Augmented state matrix');
    exportParam('MPC_Be',   B_e,  '', 'Augmented input matrix');
    exportParam('MPC_Ce',   C_e,  '', 'Augmented output matrix');
    exportParam('MPC_Bd2',  Bd2,  '', 'Discrete disturbance matrix (yaw rate from curvature)');

    %% ==================================================================
    %  4.  Summary
    % ===================================================================
    fprintf('  Design speed : %.1f m/s\n', Vdes);
    fprintf('  Np = %d,  Nc = %d,  rw = %.2f\n', Np, Nc, rw);
    fprintf('  Kmpc = [');
    fprintf('%.4f ', Kmpc);
    fprintf(']\n');
    fprintf('  Ky   = %.4f\n', Ky);
    fprintf('--- MPC controller gains done. ---\n\n');
end

%% =======================================================================
%  LOCAL HELPERS
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

function exportParam(name, value, units, description)
%EXPORTPARAM  Create a Simulink.Parameter and assign it in the base workspace.
    p = Simulink.Parameter;
    p.Value                 = value;
    p.DataType              = 'double';
    p.Complexity            = 'real';
    p.DocUnits              = units;
    p.Description           = description;
    p.CoderInfo.StorageClass = 'Auto';
    assignin('base', name, p);
    fprintf('  %-42s  created\n', name);
end
