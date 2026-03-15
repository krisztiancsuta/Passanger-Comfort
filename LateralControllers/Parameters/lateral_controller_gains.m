function lateral_controller_gains()
%LATERAL_CONTROLLER_GAINS  Compute lateral-controller feedback gains.
%
%  This function is called by master_init AFTER lateral_controller_params
%  has exported tuning parameters and vehicle data to the base workspace.
%
%  It reads the tuning parameters, calls LQR_synthetis() to compute the
%  discrete LQR gain, and stores the result as a Simulink.Parameter.
%
%  Dependencies on the MATLAB path:
%    - LQR_synthetis.m  (LateralControllers/Others)
%    - lateral_controller_params must have been run first (Shared)
%
%  Location: LateralControllers/Parameters/

    fprintf('\n--- Lateral Controller Gains ---\n');

    %% ==================================================================
    %  1.  Read tuning parameters from the base workspace
    % ===================================================================
    Ts   = getBaseParamValue('LateralControllers_SampleTime');
    Vdes = getBaseParamValue('LateralControllers_DesignSpeed');
    Q    = getBaseParamValue('LateralControllers_Q');
    R    = getBaseParamValue('LateralControllers_R');

    %% ==================================================================
    %  2.  Compute the LQR feedback gain
    %      LQR_synthetis reads vehicle params from the base workspace.
    % ===================================================================
    K = LQR_synthesis(Vdes, Ts, Q, R);

    %% ==================================================================
    %  3.  Export gain to the base workspace as Simulink.Parameter
    % ===================================================================
    LateralControllers_FeedbackGainLQR = Simulink.Parameter;
    LateralControllers_FeedbackGainLQR.Value                 = K(:,1:5);
    LateralControllers_FeedbackGainLQR.DataType              = 'double';
    LateralControllers_FeedbackGainLQR.Complexity            = 'real';
    LateralControllers_FeedbackGainLQR.DocUnits              = '';
    LateralControllers_FeedbackGainLQR.Description           = 'LQR feedback gain [K_e1, K_de1, K_e2, K_de2, K_int]';
    LateralControllers_FeedbackGainLQR.CoderInfo.StorageClass = 'Auto';

    assignin('base', 'LateralControllers_FeedbackGainLQR', LateralControllers_FeedbackGainLQR);

    fprintf('  %-42s  created\n', 'LateralControllers_FeedbackGainLQR');
    fprintf('  Design speed: %.1f m/s\n', Vdes);
    fprintf('  K = [');
    fprintf('%.4f ', K);
    fprintf(']\n');
    fprintf('--- Lateral controller gains done. ---\n\n');
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
