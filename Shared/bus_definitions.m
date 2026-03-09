function BusDefinitions()
%BUSDEFINITIONS  Create all Simulink Bus objects in the base workspace.
%
%  Usage:
%    BusDefinitions()              — creates all buses with default elements
%
%  To add more bus elements later:
%    1. Call createBusElement(name, dataType, dims, description) to build
%       individual elements, then use createBus() to register a new bus.
%    2. Or call addElementToBus(busName, name, dataType, dims, description)
%       to append an element to an existing bus at runtime.
%
%  Helper functions (defined below):
%    elem  = createBusElement(name, dataType, dims, description)
%    bus   = createBus(busName, description, elements)
%    addElementToBus(busName, name, dataType, dims, description)

    %% ---- Bus_CM_Dictionary --------------------------------------------
    elems = [ ...
        createBusElement('x', 'double', 1, 'x'), ...
        createBusElement('y', 'double', 1, 'y'), ...
        createBusElement('LateralVelocity',      'double', 1, 'Car.vy — Lateral velocity [m/s]'), ...
        createBusElement('LateralAcceleration',   'double', 1, 'Car.ay — Lateral acceleration [m/s^2]'), ...
        createBusElement('SlipAngle',             'double', 1, 'Car.Yaw — Slip angle [rad]'), ...
        createBusElement('Yawrate',               'double', 1, 'Car.YawRate — Yaw rate [rad/s]'), ...
        createBusElement('LongitudinalVelocity',  'double', 1, 'Car.vx — Longitudinal velocity [m/s]'), ...
        createBusElement('SteeringAngle',         'double', 1, 'Vhcl.Steer.Ang — Steering angle [rad]'), ...
        ... % --- Reference states from VehSensor_0.Path ---
        createBusElement('refx',               'double', 1, 'Sensor.Road.VehSensor_0.Path.tx — Reference X [m]'), ...
        createBusElement('refy',               'double', 1, 'Sensor.Road.VehSensor_0.Path.ty — Reference Y [m]'), ...
        createBusElement('refyaw',           'double', 1, 'Sensor.Road.VehSensor_0.Path.DevAng — Heading deviation [rad]'), ...
        createBusElement('refyawrate',          'double', 1, 'Computed: CurveXY * Car.vx — Reference yaw rate [rad/s]'), ...
        createBusElement('Curve',                 'double', 1, 'VehSensor_0.R — Road curvature [1/m]') ...
    ];
    createBus('Bus_CM_Dictionary', 'CarMaker dictionary signals read from CM Dict Read blocks', elems);

    %% ---- bus_VehicleStates --------------------------------------------
    elems = [ ...
        createBusElement('x',            'double', 1, 'Global X position [m]'), ...
        createBusElement('y',            'double', 1, 'Global Y position [m]'), ...
        createBusElement('LateralVelocity',      'double', 1, 'Lateral velocity [m/s]'), ...
        createBusElement('yaw',                  'double', 1, 'Yaw angle [rad]'), ...
        createBusElement('yawRate',              'double', 1, 'Yaw rate [rad/s]'), ...
        createBusElement('steeringAngle',        'double', 1, 'Steering angle [rad]'), ...
        createBusElement('longitudinalVelocity', 'double', 1, 'Longitudinal velocity [m/s]') ...
    ];
    createBus('bus_VehicleStates', 'Vehicle state vector', elems);

    
    %% ---- bus_VehicleParams --------------------------------------------
    elems = [ ...
        createBusElement('Cf', 'double', 1, 'Front axle cornering stiffness [N/rad]'), ...
        createBusElement('Cr', 'double', 1, 'Rear axle cornering stiffness [N/rad]'), ...
        createBusElement('lf', 'double', 1, 'CoG to front axle distance [m]'), ...
        createBusElement('lr', 'double', 1, 'CoG to rear axle distance [m]'), ...
        createBusElement('m',  'double', 1, 'Vehicle mass [kg]'), ...
        createBusElement('Iz', 'double', 1, 'Yaw moment of inertia [kg*m^2]') ...
    ];
    createBus('bus_VehicleParams', 'Vehicle physical parameters', elems);

    %% ---- bus_ReferenceStates ------------------------------------------
    elems = [ ...
        createBusElement('refx',         'double', 1, 'Reference X position [m]'), ...
        createBusElement('refy',         'double', 1, 'Reference Y position [m]'), ...
        createBusElement('refyaw',       'double', 1, 'Reference yaw angle [rad]'), ...
        createBusElement('refyawrate',   'double', 1, 'Reference yaw rate [rad/s]'), ...
        createBusElement('Curve', 'double', 1, 'Reference curvature [1/m]'), ...
        createBusElement('referenceSpeed',     'double', 1, 'Reference speed [m/s]') ...
    ];
    createBus('bus_ReferenceStates', 'Desired trajectory reference states', elems);

    %% ---- bus_ErrorStates ----------------------------------------------
    elems = [ ...
        createBusElement('e1',      'double', 1, 'Lateral deviation [m]'), ...
        createBusElement('de1',     'double', 1, 'Lateral deviation rate [m/s]'), ...
        createBusElement('e2',      'double', 1, 'Heading error [rad]'), ...
        createBusElement('de2',     'double', 1, 'Heading error rate [rad/s]'), ...
        createBusElement('int_e1',  'double', 1, 'Integrated lateral deviation [m*s]') ...
    ];
    createBus('bus_ErrorStates', 'Lateral error states for LQR feedback (augmented with integrator)', elems);

    %% ---- Add more buses below -----------------------------------------
    % Example:
    %   elems = [ ...
    %       createBusElement('mySignal', 'double', 1, 'description'), ...
    %       createBusElement('myArray',  'single', 10, 'a 10-element array') ...
    %   ];
    %   createBus('Bus_MyNewBus', 'Description of new bus', elems);

    fprintf('BusDefinitions: All buses created in base workspace.\n');
end

%% =======================================================================
%  HELPER FUNCTIONS
%  =======================================================================

function elem = createBusElement(name, dataType, dims, description)
%CREATEBUSELEMENT  Create a single Simulink.BusElement.
%
%  Inputs:
%    name        — element name (char / string)
%    dataType    — Simulink data type, e.g. 'double', 'int8', 'Bus: bus_X'
%    dims        — numeric scalar or vector for dimensions (default 1)
%    description — human-readable description (default '')
%
%  Output:
%    elem — configured Simulink.BusElement object

    if nargin < 3 || isempty(dims);  dims = 1;  end
    if nargin < 4;                   description = '';  end

    elem = Simulink.BusElement;
    elem.Name        = char(name);
    elem.DataType    = char(dataType);
    elem.Dimensions  = dims;
    elem.Description = char(description);
end

function bus = createBus(busName, description, elements)
%CREATEBUS  Create a Simulink.Bus and assign it in the base workspace.
%
%  Inputs:
%    busName     — variable name for the bus in the base workspace
%    description — bus description string
%    elements    — array of Simulink.BusElement objects
%
%  Output:
%    bus — the created Simulink.Bus object

    bus = Simulink.Bus;
    bus.Description = char(description);
    bus.Elements    = elements;
    assignin('base', busName, bus);
end

function addElementToBus(busName, name, dataType, dims, description)
%ADDELEMENTTOBUS  Append a new element to an existing bus in the base workspace.
%
%  Inputs:
%    busName     — name of the bus variable already in the base workspace
%    name        — new element name
%    dataType    — Simulink data type
%    dims        — dimensions (default 1)
%    description — element description (default '')
%
%  Example:
%    addElementToBus('Bus_CM_Dictionary', 'NewSignal', 'double', 1, 'A new signal')

    if nargin < 4 || isempty(dims);  dims = 1;  end
    if nargin < 5;                   description = '';  end

    bus = evalin('base', busName);
    newElem = createBusElement(name, dataType, dims, description);
    bus.Elements(end+1) = newElem;
    assignin('base', busName, bus);
end
