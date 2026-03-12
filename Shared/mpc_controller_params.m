function mpc_controller_params()
%MPC_CONTROLLER_PARAMS  Define MPC tuning parameters.
%
%  This function is called by master_init AFTER vehicle_parameters and
%  bus_definitions have already been executed.  It:
%
%    1. Defines MPC tuning parameters (Nc, Np, rw, Ts, design speed).
%    2. Exports every parameter as a Simulink.Parameter in the base
%       workspace so that Simulink models can reference them directly.
%
%  Gain computation is handled separately in:
%    LateralControllers/Parameters/mpc_controller_gains.m
%
%  All values are kept in one place — change them here and re-run
%  master_init before the next simulation.
%
%  Dependencies on the MATLAB path:
%    - vehicle_parameters.m must have been run first (Shared)
%
%  Location: Shared/

    fprintf('\n--- MPC Controller Parameters ---\n');

    %% ==================================================================
    %  Controller tuning parameters  (edit these as needed)
    % ===================================================================

    % — Sample time [s] ------------------------------------------------
    MPC_SampleTime = createParam(0.1, 's', 'MPC sample time');

    % — Design (linearisation) speed [m/s] -----------------------------
    MPC_DesignSpeed = createParam(10, 'm/s', 'Design speed for MPC linearisation');

    % — Prediction horizon (number of steps) ---------------------------
    MPC_Np = createParam(100, '', 'Prediction horizon length');

    % — Control horizon (number of steps) ------------------------------
    MPC_Nc = createParam(100, '', 'Control horizon length');

    % — Control-increment penalty weight (rw) --------------------------
    %   Higher value → more conservative / smoother steering.
    MPC_Rw = createParam(5000, '', 'Control increment penalty weight');

    %% ==================================================================
    %  Export everything to the base workspace
    % ===================================================================
    vars = { ...
        'MPC_SampleTime',       MPC_SampleTime; ...
        'MPC_DesignSpeed',      MPC_DesignSpeed; ...
        'MPC_Np',               MPC_Np; ...
        'MPC_Nc',               MPC_Nc; ...
        'MPC_Rw',               MPC_Rw; ...
    };

    for i = 1:size(vars, 1)
        assignin('base', vars{i,1}, vars{i,2});
        fprintf('  %-42s  created\n', vars{i,1});
    end

    fprintf('--- MPC controller params done. ---\n\n');
end

%% =======================================================================
%  LOCAL HELPERS
%  =======================================================================

function p = createParam(value, units, description)
%CREATEPARAM  Build a Simulink.Parameter with sensible defaults.
    p = Simulink.Parameter;
    p.Value                 = value;
    p.DataType              = 'double';
    p.Complexity            = 'real';
    p.DocUnits              = units;
    p.Description           = description;
    p.CoderInfo.StorageClass = 'Auto';
end
