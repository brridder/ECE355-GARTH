#
#   SensorController.py
#
#   This controller handles polling of events. Event handling is done by the
#   systemController.
#
#   Polling is done on a thread that fires every 60 seconds or as appropriate
#   depending on the data sensitivity.
#
#   Note that this controller is not fully implemented, as it is out of the 
#   chosen implementation scope for this submission.
#

from controller import Controller

class SensorController(Controller):
    def __init__(self, event_manager):
        Controller.__init__(self, event_manager)
        self.sensor_list = []

    def add_sensor(self, sensor):
        self.sensor_list.append(sensor)
    
    def remove_sensor(self, sensor):
        self.sensor_list.remove(sensor)

    def handle_event(self, event):
        pass
    
    def poll_sensor(self, sensor_id):
        pass

    def handle_sensor_input(self, sensor_event):
        pass

    def check_sensor_status(self, sensor_id):
        pass
