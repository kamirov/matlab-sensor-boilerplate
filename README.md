# MATLAB Serial Sensor Boilerplate

This is a template that can be used for physical sensors that you want to communicate with using a MATLAB's serial port interface.

`general_sensor` is an abstract class containing some general initialization and debugging methods. `sample_sensor` is a sample subclass of `general_sensor`. Look at `sample_sensor.m` to get an idea of how to extend `general_sensor` for your own sensors.

## Usage Notes

1. Extend `general_sensor`.

2. Implement the following abstract methods (see `general_sensor` for what they refer to):

   - `init_sensor(obj)`
   - `serial_callback(obj)`

3. Implement `init_comm(com_name)` with your own serial requirements (baud rate, terminator, callback trigger) that starts with a call to `init_comm@general_sensor(obj, com_name)`.

## Development Notes

This project is on a brief hiatus until I start working with serial sensors and MATLAB again. It's functional in its current state, and I encourage anyone who finds it beneficial to use it, but I won't be doing too much work on it for now.

That said, if you find a glitch or have a suggestion, send me a message and I'll be glad to update the repo.