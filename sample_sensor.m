classdef sample_sensor < general_sensor
    %SAMPLE_SENSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        % Sensor-specific properties go here
    end
    
    methods
        
        function obj = sample_sensor(com_name, debug_on, log_file)
        % Constructor (see general_sensor for more details)
            
            obj@general_sensor(com_name, debug_on, log_file);
            
            obj.init_sensor();
            
            obj.dmsg('Sensor initialized!'); 
        end
        
        
        function init_comm(obj, com_name)
        % Initializes serial communication (see general_sensor for more details)
        % We keep this method public so we can reinitialize communication
        % if we need to.

            % Are we reinitializing?
            if nargin < 2 || isempty(com_name)
                com_name = obj.com_name;
            end
        
            init_comm@general_sensor(obj, com_name);

            % Modify properties on the port here. If your callback is based
            % on a specific number of bytes available, a set period, or a
            % terminator sequence, then make modifications here.
            obj.port.BytesAvailableFcn = @(ser, event)(obj.serial_callback());             
            
            % Open port
            fopen(obj.port);
            
            obj.dmsg();
        end
        
    end
    
    methods (Access = protected)

        function init_sensor(obj)
        % Any sensor-specific initialization goes here.   
            
            obj.dmsg('Initializing sensor (change this message to be more specific)...');
            
            obj.dmsg();
        end
        
        
        function serial_callback(obj)
        % Serial port callback. Any sensor-specific callback goes here.
        
            % Uncomment to see if callback is being called
            % disp('Callback called');            
        end                

    end    
end

