function longitudinal_mpc_params()
%LONGITUDINAL_MPC_PARAMS  Define longitudinal MPC tuning parameters.
%
%  This function is called by master_init. It defines longitudinal MPC
%  tuning values, then exports them to the base
%  workspace as Simulink.Parameter objects.
%
%  Gain computation is handled in:
%    LongitudinalControllers/Parameters/longitudinal_mpc_gains.m
%
%  Location: LongitudinalControllers/Parameters/

    fprintf('\n--- Longitudinal MPC Parameters ---\n');

    %% Controller tuning parameters
    LongitudinalMPC_SampleTime = createParam(0.033, 's', 'Longitudinal MPC sample time');
    LongitudinalMPC_Np = createParam(100, '', 'Prediction horizon length');
    LongitudinalMPC_Nc = createParam(5, '', 'Control horizon length');
    LongitudinalMPC_Rw = createParam(0.00001, '', 'Control increment penalty weight');

    % Use a constant linear damping term as requested.
    b_lin = 50;
    LongitudinalMPC_LinearDragCoeff = createParam( ...
        b_lin, 'N/(m/s)', 'Linear damping coefficient (constant)');

    %% Export everything to the base workspace
    vars = {
        'LongitudinalMPC_SampleTime',       LongitudinalMPC_SampleTime; ...
        'LongitudinalMPC_Np',               LongitudinalMPC_Np; ...
        'LongitudinalMPC_Nc',               LongitudinalMPC_Nc; ...
        'LongitudinalMPC_Rw',               LongitudinalMPC_Rw; ...
        'LongitudinalMPC_LinearDragCoeff',  LongitudinalMPC_LinearDragCoeff; ...
    };

    for i = 1:size(vars, 1)
        assignin('base', vars{i,1}, vars{i,2});
        fprintf('  %-42s  created\n', vars{i,1});
    end

    fprintf('--- Longitudinal MPC params done. ---\n\n');
end

%% =======================================================================
%  LOCAL HELPERS
%  =======================================================================

function p = createParam(value, units, description)
%CREATEPARAM  Build a Simulink.Parameter with sensible defaults.
    p = Simulink.Parameter;
    p.Value                  = value;
    p.DataType               = 'double';
    p.Complexity             = 'real';
    p.DocUnits               = units;
    p.Description            = description;
    p.CoderInfo.StorageClass = 'Auto';
end
