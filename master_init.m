function master_init()
%MASTER_INIT  One-click initialisation for the Passenger-Comfort project.
%
%  Run this script once after opening a CarMaker / Simulink project.
%  It adds every Passenger-Comfort subfolder to the MATLAB path and
%  executes shared setup scripts (bus definitions, vehicle parameters, …)
%  so that all model dependencies are resolved automatically.
%
%  Usage:
%    >> master_init            % from the command window
%    >> run('<path>/master_init.m')   % from any working directory
%
%  The script is location-independent: it derives all paths relative to
%  the folder that contains this file, so it works when copied into
%  another CarMaker project tree.

%% -----------------------------------------------------------------------
%  1.  Resolve project root (= folder that contains this file)
% -----------------------------------------------------------------------
    projectRoot = fileparts(mfilename('fullpath'));
    fprintf('\n========================================\n');
    fprintf(' Passenger-Comfort Initialisation\n');
    fprintf('========================================\n');
    fprintf('Project root : %s\n\n', projectRoot);

%% -----------------------------------------------------------------------
%  2.  Define subfolder tree to add to the MATLAB path
%       — keeps a single, maintainable list so new folders are easy to add.
% -----------------------------------------------------------------------
    subfolders = { ...
        'Shared', ...
        fullfile('Shared', 'Libraries'), ...
        ...
        'ControlCore', ...
        fullfile('ControlCore', 'Preprocessing'), ...
        fullfile('ControlCore', 'Preprocessing', 'Parameters'),...
        ...
        'LateralControllers', ...
        fullfile('LateralControllers', 'Models'), ...
        fullfile('LateralControllers', 'Parameters'), ...
        fullfile('LateralControllers', 'Others'), ...
        fullfile('LateralControllers', 'Logs'), ...
        ...
        'LongitudinalControllers', ...
        fullfile('LongitudinalControllers', 'Models'), ...
        fullfile('LongitudinalControllers', 'Parameters'), ...
        fullfile('LongitudinalControllers', 'Others'), ...
        fullfile('LongitudinalControllers', 'Logs'), ...
        ...
        'Resources', ...
    };

%% -----------------------------------------------------------------------
%  3.  Add each subfolder that exists to the MATLAB path
% -----------------------------------------------------------------------
    addedCount = 0;
    for k = 1:numel(subfolders)
        p = fullfile(projectRoot, subfolders{k});
        if isfolder(p)
            addpath(p);
            fprintf('  addpath  %s\n', subfolders{k});
            addedCount = addedCount + 1;
        else
            fprintf('  [skip]   %s  (not found)\n', subfolders{k});
        end
    end
    fprintf('\n  %d folders added to path.\n\n', addedCount);

%% -----------------------------------------------------------------------
%  4.  Run shared initialisation scripts (bus definitions, parameters, …)
%       — each call is guarded: if the script does not yet exist the
%         initialisation continues without error.
% -----------------------------------------------------------------------
    safeRun('bus_definitions',    'Bus definitions');
    safeRun('vehicle_parameters', 'Vehicle parameters');

%% -----------------------------------------------------------------------
%  5.  Run controller-specific parameter scripts
%       — these depend on the shared parameters loaded above.
% -----------------------------------------------------------------------
    safeRun('lateral_controller_params',  'Lateral controller parameters');
    safeRun('lateral_controller_gains',   'Lateral controller gains');

    safeRun('mpc_controller_params',      'MPC controller parameters');
    safeRun('mpc_controller_gains',       'MPC controller gains');

    fprintf('========================================\n');
    fprintf(' Initialisation complete.\n');
    fprintf('========================================\n\n');
end

%% =======================================================================
%  LOCAL HELPER — run a script/function only if it is on the path
%  =======================================================================
function safeRun(name, label)
    if ~isempty(which(name))
        fprintf('  Running  %s  …\n', label);
        try
            evalin('base', name);   % execute in the base workspace
        catch ME
            warning('master_init:runFailed', ...
                    'Failed to run "%s": %s', name, ME.message);
        end
    else
        fprintf('  [skip]   %s  (script not on path)\n', label);
    end
end