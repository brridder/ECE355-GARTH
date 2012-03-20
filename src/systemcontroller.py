from controller import Controller
from event_type import EventType
from event import *
from datetime import timedelta
from threading import Timer
import logging
import jsonrpc
import urllib2

STR_ALARM_DOOR_DESC = "Door opened!"
STR_ALARM_DOOR_SPEECH = "Intrusion Detected"

STR_ALARM_WINDOW_DESC = "Window opened!"
STR_ALARM_WINDOW_SPEECH = "Intrusion Detected"

STR_ALARM_FLOOD_MAJOR_DESC = "Flooding occuring "
STR_ALARM_FLOOD_MAJOR_SPEECH = "Flooding Detected"
STR_ALARM_FLOOD_CRIT_DESC = "Critical flooding occuring"
STR_ALARM_FLOOD_CRIT_SPEECH = "Major Flooding Detected"

STR_ALARM_TEMP_MINOR_DESC = "Temperature changing slightly"
STR_ALARM_TEMP_MINOR_SPEECH = "Temperature starting to change"
STR_ALARM_TEMP_MAJOR_DESC = "Temperature changing quickly"
STR_ALARM_TEMP_MAJOR_SPEECH = "Temperature changing quickly"
STR_ALARM_TEMP_CRIT_DESC = "Abnormal temperature levels"
STR_ALARM_TEMP_CRIT_SPEECH = "Please vacate the premisses"

STR_ALARM_MOTION_SPEECH = "Motion detected"
STR_ALARM_MOTION_DESC = "Motion detected"

FLOOD_DELTA_HEIGHT_CRIT = 3

ALARM_MOTION_DURATION = timedelta(0, 30)
DOOR_EVENT_TIMER_DELAY = 30

class SystemState:
    ARMED           = 1
    DISARMED        = 2
    ERROR_ARMED     = 3
    ERROR_DISARMED  = 4
    UNKNOWN         = 5


class SystemController(Controller):
    def __init__(self, event_manager, server_url=None):
        # Setup inital states
        Controller.__init__(self, event_manager)
        self._server_url = server_url
        self.system_state = SystemState.ARMED
        self.user_list = []
        self.input_devices = []
        self.door_timer_delay = DOOR_EVENT_TIMER_DELAY
    
        # Load the event handlers functions into a dictionary to make calling
        # the appropriate function easier through the enum
        self.event_handling_functions = {
            EventType.DOOR_SENSOR_EVENT : self._handle_door_event,
            EventType.WINDOW_SENSOR_EVENT : self._handle_window_event,
            EventType.FLOOD_SENSOR_EVENT : self._handle_flood_event,
            EventType.TEMP_SENSOR_EVENT : self._handle_temp_event,
            EventType.MOTION_SENSOR_EVENT : self._handle_motion_event,
            EventType.ALARM_EVENT : self._handle_alarm_event,
            EventType.KEYPAD_EVENT : self._handle_keypad_event,
            EventType.NFC_EVENT : self._handle_nfc_event
        }

        # Subscribe to events
        if self.event_manager is not None:
            for event_type in self.event_handling_functions.keys():
                self.event_manager.subscribe(event_type, self)
    
    def get_input_devices(self):
        return self.input_devices
    
    def get_system_state(self):
        return self.system_state

    def get_user_list(self):
        return self.user_list

    def handle_event(self, event):
        """ 
        Pass the event type to the appropriate event handler. Returns True
        if the event is handled, False otherwise
        """
        event_type = event.get_event_type()
        self.log_event_to_server(event)
        try:
            return self.event_handling_functions[event_type](event)  
        except KeyError as e:
            #logging.error(e)
            return False

    def _handle_door_event(self, event):
        """ Handle door events. If the system is armed, set a timer and recheck
        the system state conditions. If the system is disarmed, do not handle
        the event."""
        if self.system_state == SystemState.DISARMED:
            return False
        elif (event.get_opened() and self.system_state == SystemState.ARMED):
            # Start timer, when fired call broadcast event
            print "self.door_timer_delay %s" % self.door_timer_delay
            t = Timer(self.door_timer_delay, self._door_timer)
            t.start()
            return True
        else:
            return False

    def _door_timer(self):
        """ Door timer for handle_door_event. Rechecks system state and sends
        an alarm if still ARMED """
        if self.system_state == SystemState.ARMED:
            alarm = AlarmEvent(
                AlarmSeverity.MAJOR_ALARM, 
                STR_ALARM_DOOR_DESC,
                STR_ALARM_DOOR_SPEECH)
            self.raise_alarm(alarm)

    def _handle_window_event(self, event):
        """ Handle window events. If system is armed, send back an alarm,
        otherwise do not do anything. """
        if event.get_opened() and self.system_state == SystemState.ARMED:
            logging.debug("Window opened while system armed")
            description = STR_ALARM_WINDOW_DESC
            speech_message = STR_ALARM_WINDOW_SPEECH
            alarm = AlarmEvent(
                AlarmSeverity.MAJOR_ALARM,
                description,
                speech_message) 
            self.raise_alarm(alarm)
            return True
        return False
    
    # Tested
    def _handle_flood_event(self, event):
        """ Handle flood events. Alarm severity is dependent on the water
        height and delta values """
        description = ""
        message = ""
        severity = AlarmSeverity.MINOR_ALARM
        
        # Water level is critical
        if event.get_height_delta() >= FLOOD_DELTA_HEIGHT_CRIT:
            description = STR_ALARM_FLOOD_CRIT_DESC
            message = STR_ALARM_FLOOD_CRIT_SPEECH
            severity = AlarmSeverity.CRITICAL_ALARM
        # Water level is major
        elif event.get_water_height() >= 1 or event.get_height_delta() >= 1:
            description = STR_ALARM_FLOOD_MAJOR_DESC
            message = STR_ALARM_FLOOD_MAJOR_SPEECH
            severity = AlarmSeverity.MAJOR_ALARM
        # Nothing happened of importance
        else: 
            return False
        alarm = AlarmEvent(severity, description, message)
        self.raise_alarm(alarm)
        return True
    
    # Tested
    def _handle_temp_event(self, event):
        """ Handle temperature events. Alarm severity varies depending on the
        temperature and delta values."""
        description = ""
        message = ""
        severity = AlarmSeverity.MINOR_ALARM
        
        temp = event.get_temperature()
        delta = event.get_temp_delta()

        # Minor deviance in temperature
        if (temp >= 26 and temp < 30) or  (temp < 18 and temp >= 15) or \
          (abs(delta) <= 3 and abs(delta) > 2):  
            description = STR_ALARM_TEMP_MINOR_DESC
            message = STR_ALARM_TEMP_MINOR_SPEECH
            severity = AlarmSeverity.MINOR_ALARM
        # Major deviance in temperature
        elif (temp >= 30 and temp < 35) or (temp < 15 and temp >= 12) or \
           (abs(delta) > 3  and abs(delta) <= 5):
            description = STR_ALARM_TEMP_MAJOR_DESC
            message = STR_ALARM_TEMP_MAJOR_SPEECH
            severity = AlarmSeverity.MAJOR_ALARM
        # Critical deviance in temperature: FIRE or air leak
        elif (temp >= 35) or (temp < 12) or (abs(delta) > 5):
            description = STR_ALARM_TEMP_CRIT_DESC
            message = STR_ALARM_TEMP_CRIT_SPEECH
            severity = AlarmSeverity.CRITICAL_ALARM
        else: 
            return False
        alarm = AlarmEvent(severity, description, message)
        self.raise_alarm(alarm)
        return True
    
    # Tested
    def _handle_motion_event(self, event):
        """ Handle motion events. Only concerned for when system is armed.
        Assumes that there will be an end time for event to be handled
        correctly. """
        description = ""
        message = ""
        severity = AlarmSeverity.MINOR_ALARM
                
        duration = event.get_duration()
        if event.get_end_time() == None or \
           self.system_state == SystemState.DISARMED :
            return False
        elif (duration >= ALARM_MOTION_DURATION):
            message = STR_ALARM_MOTION_SPEECH
            description = STR_ALARM_MOTION_DESC
            severity = AlarmSeverity.MAJOR_ALARM
        else:
            return False
        
        alarm = AlarmEvent(severity, description, message)
        self.raise_alarm(alarm)
        return True

    def _handle_alarm_event(self, event):
        """ In this case, shouldn't pass back the alarmEvent since it will
        cause an infinite loop"""
        return True
    
    def _arm_system(self):
        self.system_state = SystemState.ARMED
        
    def _disarm_system(self):
        self.system_state = SystemState.DISARMED

    def log_event_to_server(self, event):
        """ Send the event to the server in JSON-RPC form. """
        logging.debug("Sensor_controller::log_event_to_server %s" % event)

        if self._server_url:
            try:
                jsonrpc.rpc('log_event', [event], self._server_url)
            except urllib2.URLError, e:
                logging.error("RPC Error: %s" % e)            

    # 
    # Outside of implementation scope
    #

    def _handle_nfc_event(self, nfc_event):
        return False
    
    #
    # "a" or "A" => arm system
    # "d" or "D" => disarm system
    # "s" or "S" => stop alarms
    #
    def _handle_keypad_event(self, keypad_event):
        """ Handles keypad inputs. See comment for character mappings """
        if keypad_event.input_char.lower() == 'a':
            self._arm_system()
            return True
        elif keypad_event.input_char.lower() == 'd':
            self._disarm_system()
            self.system_state = SystemState.DISARMED;
            return True
        elif keypad_event.input_char.lower() == 's':
            return True
        else: 
            return False
    
    def raise_alarm(self, alarm_event):
        """ Broadcast the alarm event to the event_manager """
        if self.event_manager != None:
            self.event_manager.broadcast_event(alarm_event)

