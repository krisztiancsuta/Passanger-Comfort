function longitudinal_mpc_gains()
%LONGITUDINAL_MPC_GAINS  Compute and export longitudinal MPC gains.
%
%  This function is called by master_init after longitudinal_mpc_params.
%  It reads tuning values from the base workspace, computes the MPC gains
%  and matrices, then exports them as Simulink.Parameter objects.
%
%  Dependencies on the MATLAB path:
%    - Longitudinal_MPC_synthesis.m (LongitudinalControllers/Others)
%    - mpcgain.m (LateralControllers/Others)
%
%  Location: LongitudinalControllers/Parameters/

    fprintf('\n--- Longitudinal MPC Gains ---\n');

    %% Read tuning parameters from base workspace
    Ts   = getBaseParamValue('LongitudinalMPC_SampleTime');
    Nc   = getBaseParamValue('LongitudinalMPC_Nc');
    Np   = getBaseParamValue('LongitudinalMPC_Np');
    rw   = getBaseParamValue('LongitudinalMPC_Rw');
    % Mass is sourced directly from Shared/vehicle_parameters.m.
    mass = getBaseParamValue('Vehicle_Weight');
    blin = getBaseParamValue('LongitudinalMPC_LinearDragCoeff');

    %% Compute gains and matrices
    [Kmpc, Ky, H, Phi_F, Phi_R,F, Phi] = ...
        Longitudinal_MPC_synthesis(Ts, Nc, Np, rw, mass, blin);

    %% Export to base workspace as Simulink.Parameter objects
    exportParam('LongitudinalMPC_FeedbackGainKmpc', Kmpc, '', ...
        'Unconstrained longitudinal MPC state feedback gain');
    exportParam('LongitudinalMPC_ReferenceGainKy', Ky, '', ...
        'Unconstrained longitudinal MPC reference gain');

    exportParam('LongitudinalMPC_H', H, '', ...
        'Longitudinal MPC Hessian matrix');
    exportParam('LongitudinalMPC_PhiF', Phi_F, '', ...
        'Longitudinal MPC free-response prediction matrix');
    exportParam('LongitudinalMPC_PhiR', Phi_R, '', ...
        'Longitudinal MPC reference prediction matrix');
    exportParam('LongitudinalMPC_Phi', Phi, '','');
    exportParam('LongitudinalMPC_F', F, '','');

    %% Summary
    fprintf('  Ts = %.4f s, Np = %d, Nc = %d, rw = %.6f\n', Ts, Np, Nc, rw);
    fprintf('  mass = %.1f kg, b_lin = %.3f N/(m/s)\n', mass, blin);
    fprintf('  Kmpc = [' );
    fprintf('%.5f ', Kmpc);
    fprintf(']\n');
    fprintf('  Ky   = %.5f\n', Ky);
    fprintf('--- Longitudinal MPC gains done. ---\n\n');
end

%% =======================================================================
%  LOCAL HELPERS
%  =======================================================================

function val = getBaseParamValue(name)
%GETBASEPARAMVALUE  Read a Simulink.Parameter's .Value from base workspace.
    obj = evalin('base', name);
    if isa(obj, 'Simulink.Parameter')
        val = obj.Value;
    else
        val = obj;
    end
end

function exportParam(name, value, units, description)
%EXPORTPARAM  Create Simulink.Parameter and assign it in base workspace.
    p = Simulink.Parameter;
    p.Value                  = value;
    p.DataType               = 'double';
    p.Complexity             = 'real';
    p.DocUnits               = units;
    p.Description            = description;
    p.CoderInfo.StorageClass = 'Auto';

    assignin('base', name, p);
    fprintf('  %-42s  created\n', name);
end
