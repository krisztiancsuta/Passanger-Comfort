%% Vehicle_Parameters.m — Vehicle physical parameters
%  Defines the parameters used by bus_VehicleParams and other subsystems.
%  All values are Simulink.Parameter objects (DataType = 'double').
%  Values from 'Lexus adatok tablazata.xlsx'.

%% ---------- Quick reference -------------------------------------------
%  Parameter                              Value         Unit
%  -----------------------------------------------—---------
%  Vehicle_CorneringStiffnessFrontAxle    222685.8      N/rad
%  Vehicle_CorneringStiffnessRearAxle    136242.8      N/rad
%  Vehicle_CoGFrontWheelsLength             1.236      m
%  Vehicle_CoGRearWheelsLength              1.553      m
%  Vehicle_WheelBase                        2.789      m
%  Vehicle_Weight                           2300       kg
%  Vehicle_MomentofInertiaZ                 2873       kg*m^2
%  Vehicle_SteeringGearRatio               16.603      -
%  Vehicle_SteeringSettlingTime              0.02      s
%  Vehicle_TrackWidth                       1.636      m
%  Vehicle_CoGHeight                        0.7164     m
%  Vehicle_WheelEffectiveRadius              0.3       m
%  Vehicle_WheelMomentofInertia              1         kg*m^2
%  Vehicle_DragCoefficient                   0.33      -
%  Vehicle_FrontalArea                       2.5       m^2
%  Vehicle_AirDensity                        1.225     kg/m^3
%  Vehicle_TurningCircleMinChassis           6.9       m
%  Vehicle_TurningCircleMinWheels            5.9       m

%% ---- Cornering stiffness ---------------------------------------------

Vehicle_CorneringStiffnessFrontAxle                       = Simulink.Parameter;
Vehicle_CorneringStiffnessFrontAxle.Value                 = 222685.8;
Vehicle_CorneringStiffnessFrontAxle.DataType              = 'double';
Vehicle_CorneringStiffnessFrontAxle.Complexity            = 'real';
Vehicle_CorneringStiffnessFrontAxle.DocUnits              = 'N/rad';
Vehicle_CorneringStiffnessFrontAxle.Description           = 'Front axle cornering stiffness';
Vehicle_CorneringStiffnessFrontAxle.CoderInfo.StorageClass = 'Auto';

Vehicle_CorneringStiffnessRearAxle                        = Simulink.Parameter;
Vehicle_CorneringStiffnessRearAxle.Value                  = 136242.8;
Vehicle_CorneringStiffnessRearAxle.DataType               = 'double';
Vehicle_CorneringStiffnessRearAxle.Complexity             = 'real';
Vehicle_CorneringStiffnessRearAxle.DocUnits               = 'N/rad';
Vehicle_CorneringStiffnessRearAxle.Description            = 'Rear axle cornering stiffness';
Vehicle_CorneringStiffnessRearAxle.CoderInfo.StorageClass  = 'Auto';

%% ---- Geometry ---------------------------------------------------------

Vehicle_CoGFrontWheelsLength                              = Simulink.Parameter;
Vehicle_CoGFrontWheelsLength.Value                        = 1.236;
Vehicle_CoGFrontWheelsLength.DataType                     = 'double';
Vehicle_CoGFrontWheelsLength.Complexity                   = 'real';
Vehicle_CoGFrontWheelsLength.DocUnits                     = 'm';
Vehicle_CoGFrontWheelsLength.Description                  = 'CoG to front axle distance';
Vehicle_CoGFrontWheelsLength.CoderInfo.StorageClass        = 'ExportedGlobal';

Vehicle_CoGRearWheelsLength                               = Simulink.Parameter;
Vehicle_CoGRearWheelsLength.Value                         = 1.553;
Vehicle_CoGRearWheelsLength.DataType                      = 'double';
Vehicle_CoGRearWheelsLength.Complexity                    = 'real';
Vehicle_CoGRearWheelsLength.DocUnits                      = 'm';
Vehicle_CoGRearWheelsLength.Description                   = 'CoG to rear axle distance';
Vehicle_CoGRearWheelsLength.CoderInfo.StorageClass         = 'ExportedGlobal';

Vehicle_WheelBase                                         = Simulink.Parameter;
Vehicle_WheelBase.Value                                   = 2.789;
Vehicle_WheelBase.DataType                                = 'double';
Vehicle_WheelBase.Complexity                              = 'real';
Vehicle_WheelBase.DocUnits                                = 'm';
Vehicle_WheelBase.Description                             = 'Wheelbase (lf + lr)';
Vehicle_WheelBase.CoderInfo.StorageClass                   = 'ExportedGlobal';

Vehicle_TrackWidth                                        = Simulink.Parameter;
Vehicle_TrackWidth.Value                                  = 1.636;
Vehicle_TrackWidth.DataType                               = 'double';
Vehicle_TrackWidth.Complexity                             = 'real';
Vehicle_TrackWidth.DocUnits                               = 'm';
Vehicle_TrackWidth.Description                            = 'Track width';
Vehicle_TrackWidth.CoderInfo.StorageClass                  = 'Auto';

Vehicle_CoGHeight                                         = Simulink.Parameter;
Vehicle_CoGHeight.Value                                   = 0.7164;
Vehicle_CoGHeight.DataType                                = 'double';
Vehicle_CoGHeight.Complexity                              = 'real';
Vehicle_CoGHeight.DocUnits                                = 'm';
Vehicle_CoGHeight.Description                             = 'Centre of gravity height';
Vehicle_CoGHeight.CoderInfo.StorageClass                   = 'Auto';

%% ---- Mass & Inertia ---------------------------------------------------

Vehicle_Weight                                            = Simulink.Parameter;
Vehicle_Weight.Value                                      = 2300;
Vehicle_Weight.DataType                                   = 'double';
Vehicle_Weight.Complexity                                 = 'real';
Vehicle_Weight.DocUnits                                   = 'kg';
Vehicle_Weight.Description                                = 'Vehicle mass';
Vehicle_Weight.CoderInfo.StorageClass                      = 'Auto';

Vehicle_MomentofInertiaZ                                  = Simulink.Parameter;
Vehicle_MomentofInertiaZ.Value                            = 2873;
Vehicle_MomentofInertiaZ.DataType                         = 'double';
Vehicle_MomentofInertiaZ.Complexity                       = 'real';
Vehicle_MomentofInertiaZ.DocUnits                         = 'kg*m^2';
Vehicle_MomentofInertiaZ.Description                      = 'Yaw moment of inertia';
Vehicle_MomentofInertiaZ.CoderInfo.StorageClass            = 'Auto';

Vehicle_WheelMomentofInertia                              = Simulink.Parameter;
Vehicle_WheelMomentofInertia.Value                        = 1;
Vehicle_WheelMomentofInertia.DataType                     = 'double';
Vehicle_WheelMomentofInertia.Complexity                   = 'real';
Vehicle_WheelMomentofInertia.DocUnits                     = 'kg*m^2';
Vehicle_WheelMomentofInertia.Description                  = 'Wheel moment of inertia';
Vehicle_WheelMomentofInertia.CoderInfo.StorageClass        = 'Auto';

%% ---- Steering ---------------------------------------------------------

Vehicle_SteeringGearRatio                                 = Simulink.Parameter;
Vehicle_SteeringGearRatio.Value                           = 20;
Vehicle_SteeringGearRatio.DataType                        = 'double';
Vehicle_SteeringGearRatio.Complexity                      = 'real';
Vehicle_SteeringGearRatio.DocUnits                        = '';
Vehicle_SteeringGearRatio.Description                     = 'Steering wheel to road wheel ratio';
Vehicle_SteeringGearRatio.CoderInfo.StorageClass           = 'ExportedGlobal';

Vehicle_SteeringSettlingTime                              = Simulink.Parameter;
Vehicle_SteeringSettlingTime.Value                        = 0.02;
Vehicle_SteeringSettlingTime.DataType                     = 'double';
Vehicle_SteeringSettlingTime.Complexity                   = 'real';
Vehicle_SteeringSettlingTime.DocUnits                     = 's';
Vehicle_SteeringSettlingTime.Description                  = 'Steering settling time';
Vehicle_SteeringSettlingTime.CoderInfo.StorageClass        = 'Auto';

%% ---- Wheels -----------------------------------------------------------

Vehicle_WheelEffectiveRadius                              = Simulink.Parameter;
Vehicle_WheelEffectiveRadius.Value                        = 0.3;
Vehicle_WheelEffectiveRadius.DataType                     = 'double';
Vehicle_WheelEffectiveRadius.Complexity                   = 'real';
Vehicle_WheelEffectiveRadius.DocUnits                     = 'm';
Vehicle_WheelEffectiveRadius.Description                  = 'Effective rolling radius';
Vehicle_WheelEffectiveRadius.CoderInfo.StorageClass        = 'ExportedGlobal';

Vehicle_TurningCircleMinChassis                           = Simulink.Parameter;
Vehicle_TurningCircleMinChassis.Value                     = 6.9;
Vehicle_TurningCircleMinChassis.DataType                  = 'double';
Vehicle_TurningCircleMinChassis.Complexity                = 'real';
Vehicle_TurningCircleMinChassis.DocUnits                  = 'm';
Vehicle_TurningCircleMinChassis.Description               = 'Min turning circle (chassis)';
Vehicle_TurningCircleMinChassis.CoderInfo.StorageClass     = 'Auto';

Vehicle_TurningCircleMinWheels                            = Simulink.Parameter;
Vehicle_TurningCircleMinWheels.Value                      = 5.9;
Vehicle_TurningCircleMinWheels.DataType                   = 'double';
Vehicle_TurningCircleMinWheels.Complexity                 = 'real';
Vehicle_TurningCircleMinWheels.DocUnits                   = 'm';
Vehicle_TurningCircleMinWheels.Description                = 'Min turning circle (wheels)';
Vehicle_TurningCircleMinWheels.CoderInfo.StorageClass      = 'Auto';

%% ---- Aerodynamics -----------------------------------------------------

Vehicle_DragCoefficient                                   = Simulink.Parameter;
Vehicle_DragCoefficient.Value                             = 0.33;
Vehicle_DragCoefficient.DataType                          = 'double';
Vehicle_DragCoefficient.Complexity                        = 'real';
Vehicle_DragCoefficient.DocUnits                          = '';
Vehicle_DragCoefficient.Description                       = 'Aerodynamic drag coefficient';
Vehicle_DragCoefficient.CoderInfo.StorageClass             = 'Auto';

Vehicle_FrontalArea                                       = Simulink.Parameter;
Vehicle_FrontalArea.Value                                 = 2.5;
Vehicle_FrontalArea.DataType                              = 'double';
Vehicle_FrontalArea.Complexity                            = 'real';
Vehicle_FrontalArea.DocUnits                              = 'm^2';
Vehicle_FrontalArea.Description                           = 'Vehicle frontal area';
Vehicle_FrontalArea.CoderInfo.StorageClass                 = 'Auto';

Vehicle_AirDensity                                        = Simulink.Parameter;
Vehicle_AirDensity.Value                                  = 1.225;
Vehicle_AirDensity.DataType                               = 'double';
Vehicle_AirDensity.Complexity                             = 'real';
Vehicle_AirDensity.DocUnits                               = 'kg/m^3';
Vehicle_AirDensity.Description                            = 'Air density';
Vehicle_AirDensity.CoderInfo.StorageClass                  = 'Auto';
