classdef (Abstract) general_sensor < handle
% Abstract parent class for all sensors.
% Extend this for your physical sensors.
    

    properties (Access = public)
        debug = struct(...                     % Debug information
                       'on', false, ...        % Are we debugging?
                       'log', false, ...       % Save debug data to file?
                       'log_file', '');        % Which file?
    end
    
    
    % Properties we don't want visible OR cached
    properties (Access = protected, Transient = true)
        com_name;               
        port;
        port_initialized = false;
    end
    
    
    methods
        
        function obj = general_sensor(com_name, debug_on, log_file)
        % Constructor. 
        %   - com_name        String representing the com port (e.g. 'COM5').
        %   - debug_on        Boolean. Enables debug messages. Optional.
        %   - log_file        Absolute path. If set, will log debug
        %                     messages to the file. Optional.
            
            % Default arguments
            if nargin < 3 || isempty(log_file)
                log_file = '';
            end
            if nargin < 2 || isempty(debug_on)
                debug_on = false;
            end
            if nargin < 1 || isempty(com_name)
                error('Please specify a com port name (e.g. ''COM5'')');
            end
            
            % Debugging setup
            obj.debug.on = debug_on;
            if ~isempty(log_file)
                obj.debug.log = true;
                obj.debug.log_file = log_file;
            end
            
            % Initialization
            obj.init_comm(com_name);
        end
        
        
        function init_comm(obj, com_name)
        % Initializes serial communication, sets serial port properties.
        
            % Are we reinitializing using the same com port?
            if nargin < 2 || isempty(com_name)
                com_name = obj.com_name;
            end

            if obj.port_initialized
                init_msg = 'Reinitializing';
            else
                init_msg = 'Initializing';
            end
            
            obj.dmsg([init_msg ' communication (' com_name ')...']);

            obj.com_name = com_name;
            
            % Close port (if opened)
            cur_port = instrfind('Port', obj.com_name);
            if ~isempty(cur_port)
                try
                    fclose(cur_port);
                    delete(cur_port);
                catch
                    warning('Error closing/deleting current serial port (was it already closed?). Trying to reinitialize communication anyway.');
                end
            end
            
            % Instantiate port
            obj.port = serial(obj.com_name);
            
            % Clear buffer (not sure if this is still needed)
            if obj.port.BytesAvailable > 0
                obj.dmsg('Bytes still available on the serial port. Flushing... ');
                fscanf(obj.port, '%s', obj.port.BytesAvailable);
            end
            
            obj.port_initialized = true;
        end

    end
   
    methods (Abstract, Access = protected)
        % Serial port callback. Any sensor-specific callback goes here.
        serial_callback(obj)
       
        % Any sensor-specific initialization goes here.
        init_sensor(obj)
    end 
        
    methods (Access = protected)
        
        function dmsg(obj, str, force_new)
        % Print messages only if debug mode is active. This keeps us from
        % having to put conditional blocks in the code for each debug
        % message (also lets us get fancy with the messages).
        %   - str           String. If set, then will print it. If empty,
        %                   then will print a 'done message' if the
        %                   previous message was a 'Doing something...'
        %                   message
        %   - force_new     Boolean. If true, will put message on new line
        
            % Force a new line beforehand?
            if nargin < 3 || isempty(force_new)
                str_prefix = '';
            else
                str_prefix = '\n';
            end
            
            if nargin < 2 || isempty(str)
                str = [];
            end
        
            % Keep track of whether we're in a 'Doing something...' message
            persistent message_started;
            if isempty(message_started)
                message_started = true;
            end

            % Was the last message a 'Doing something...' message?
            if message_started && isempty(str)
                message_started = false;
                str = 'Done!\n';
            else
                message_started = true;
            end
                    
            % Print the message only if we're debugging
            if obj.debug.on
                str = [str_prefix, str];
                fprintf(str);
                
                if obj.debug.log
                    timestamp = datestr(now, 'dd-mmm-yyyy HH:MM:SS.FFF');
                    f = fopen(obj.debug.log_file, 'a+');
                    fprintf(f, ['[' timestamp '] ' str]);
                    
                    % Log a new line if there isn't already one
                    if ~strcmp(str(end-1:end), '\n')
                        fprintf(f, '\n');
                    end
                    
                    fclose(f); 
                end
            end
        end

    end
      
end