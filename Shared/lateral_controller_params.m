function lateral_controller_params()
%LATERAL_CONTROLLER_PARAMS  Define lateral-controller tuning parameters.
%
%  This function is called by master_init (after vehicle_parameters and
%  bus_definitions have already been executed).  It:
%
%    1. Defines controller tuning parameters (Q, R, Ts, design speed).
%    2. Exports every parameter as a Simulink.Parameter in the base
%       workspace so that Simulink models can reference them directly.
%
%  Gain computation is handled separately in:
%    LateralControllers/Parameters/lateral_controller_gains.m
%
%  All values are kept in one place — change them here and re-run
%  master_init before the next simulation.
%
%  Dependencies on the MATLAB path:
%    - vehicle_parameters.m must have been run first (Shared)
%
%  Location: Shared/  (so all parameter files are in one place)

    fprintf('\n--- Lateral Controller Parameters ---\n');

    %% ==================================================================
    %  Controller tuning parameters  (edit these as needed)
    %  Vehicle parameters are accessed directly from the base workspace
    %  by LQR_synthetis (no car struct needed).
    % ===================================================================

    % — Sample time [s] ------------------------------------------------
    LateralControllers_SampleTime = createParam(0.033, 's','Sample Time');

    % — Design (linearisation) speed [m/s] -----------------------------
    LateralControllers_DesignSpeed = createParam(100, 'm/s', 'Design speed for LQR linearisation');

    % — LQR state-cost matrix Q  (5×5 diagonal) -----------------------
    %   States: [e1, de1, e2, de2, int_e1]
    %   Increase a weight to penalise that state more aggressively.
    LateralControllers_Q = createParam(diag([4 1 1 1 60]), '', 'LQR state weighting matrix Q (5x5)');

    % — LQR input-cost weight R ----------------------------------------
    LateralControllers_R = createParam(10, '', 'LQR input weighting scalar R');

    %% ==================================================================
    %  Export everything to the base workspace
    % ===================================================================
    vars = { ...
        'LateralControllers_SampleTime',   LateralControllers_SampleTime; ...
        'LateralControllers_DesignSpeed',  LateralControllers_DesignSpeed; ...
        'LateralControllers_Q',            LateralControllers_Q; ...
        'LateralControllers_R',            LateralControllers_R; ...
    };

    for i = 1:size(vars, 1)
        assignin('base', vars{i,1}, vars{i,2});
        fprintf('  %-42s  created\n', vars{i,1});
    end

    fprintf('--- Lateral controller params done. ---\n\n');
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
