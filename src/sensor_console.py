#!/usr/bin/env python2

#
#   sensor_console.py
#
#   User interface for a sensor bank. Different event types are represented and
#   are sent to the controllers when activated.
#

import wx
import logging
import argparse

import event
from datetime import datetime, timedelta
from eventmanager import EventManager

MIN_WINDOW_SIZE = wx.Size(590, 520)

class SensorFrame(wx.Frame):
    def __init__(self, parent, title):
        wx.Frame.__init__(self, parent, title=title, size=MIN_WINDOW_SIZE)
        self.SetMinSize(MIN_WINDOW_SIZE)

        panel = wx.Panel(self)

        # Header
        title = wx.StaticText(panel, wx.ID_ANY, label='GARTH Sensor Demonstration Console')
        title_line = wx.StaticLine(panel, wx.ID_ANY, size=(570, 10))
        
        # Doors
        button_door_open = wx.Button(panel, wx.ID_ANY, 'Open Door')
        button_door_closed = wx.Button(panel, wx.ID_ANY, 'Close Door')
        self.door_id = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        door_id_label = wx.StaticText(panel, wx.ID_ANY, label='Door ID:')
        door_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Doors')
        door_sizer = wx.StaticBoxSizer(door_staticbox, wx.HORIZONTAL)
        door_sizer.Add(button_door_open, 0, wx.ALL, border=5)
        door_sizer.Add(button_door_closed, 0, wx.ALL, border=5)
        door_sizer.Add(door_id_label, 0, wx.ALL, border=5)
        door_sizer.Add(self.door_id, 0, wx.ALL, border=5)

        # Windows
        button_window_open = wx.Button(panel, wx.ID_ANY, 'Open Window')
        button_window_closed = wx.Button(panel, wx.ID_ANY, 'Close Window')
        self.window_id = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        window_id_label = wx.StaticText(panel, wx.ID_ANY, label='Window ID:')
        window_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Windows')
        window_sizer = wx.StaticBoxSizer(window_staticbox, wx.HORIZONTAL)
        window_sizer.Add(button_window_open, 0, wx.ALL, border=5)
        window_sizer.Add(button_window_closed, 0, wx.ALL, border=5)
        window_sizer.Add(window_id_label, 0, wx.ALL, border=5)
        window_sizer.Add(self.window_id, 0, wx.ALL, border=5)

        # Flood
        button_flood = wx.Button(panel, wx.ID_ANY, 'Trigger Flood Sensor')
        self.flood_level = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        flood_level_label = wx.StaticText(panel, wx.ID_ANY, label='Level:')
        self.flood_delta = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        flood_delta_label = wx.StaticText(panel, wx.ID_ANY, label='Delta:')

        flood_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Flood Sensors')
        flood_sizer = wx.StaticBoxSizer(flood_staticbox, wx.HORIZONTAL)    
        flood_sizer.Add(button_flood, 0, wx.ALL, border=5)
        flood_sizer.Add(flood_level_label, 0, wx.ALL, border=5)        
        flood_sizer.Add(self.flood_level, 0, wx.ALL, border=5)
        flood_sizer.Add(flood_delta_label, 0, wx.ALL, border=5)        
        flood_sizer.Add(self.flood_delta, 0, wx.ALL, border=5)

        # Temperature
        button_temp = wx.Button(panel, wx.ID_ANY, 'Trigger Temp Sensor')
        self.temp = wx.TextCtrl(panel, wx.ID_ANY, value='20')
        temp_level_label = wx.StaticText(panel, wx.ID_ANY, label='Temp:')
        self.temp_delta = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        temp_delta_label = wx.StaticText(panel, wx.ID_ANY, label='Delta:')

        temp_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Temp Sensors')
        temp_sizer = wx.StaticBoxSizer(temp_staticbox, wx.HORIZONTAL)    
        temp_sizer.Add(button_temp, 0, wx.ALL, border=5)
        temp_sizer.Add(temp_level_label, 0, wx.ALL, border=5)        
        temp_sizer.Add(self.temp, 0, wx.ALL, border=5)
        temp_sizer.Add(temp_delta_label, 0, wx.ALL, border=5)        
        temp_sizer.Add(self.temp_delta, 0, wx.ALL, border=5)

        # Keyboard Events
        button_keyboard = wx.Button(panel, wx.ID_ANY, 'Keyboard Input')
        self.keyboard = wx.TextCtrl(panel, wx.ID_ANY)
        keyboard_level_label = wx.StaticText(panel, wx.ID_ANY, label='String:')

        keyboard_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Keyboard Input')
        keyboard_sizer = wx.StaticBoxSizer(keyboard_staticbox, wx.HORIZONTAL)    
        keyboard_sizer.Add(button_keyboard, 0, wx.ALL, border=5)
        keyboard_sizer.Add(keyboard_level_label, 0, wx.ALL, border=5)        
        keyboard_sizer.Add(self.keyboard, 0, wx.ALL, border=5)        

        # Motion Event
        button_motion = wx.Button(panel, wx.ID_ANY, 'Trigger Motion Sensor')

        motion_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Motion Sensor')
        motion_sizer = wx.StaticBoxSizer(motion_staticbox, wx.HORIZONTAL)    
        motion_sizer.Add(button_motion, 0, wx.ALL, border=5)

        # Panel
        panel_sizer = wx.BoxSizer(wx.VERTICAL)
        panel_sizer.Add(title)
        panel_sizer.Add(title_line)
        panel_sizer.Add(door_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel_sizer.Add(window_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel_sizer.Add(flood_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel_sizer.Add(temp_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel_sizer.Add(keyboard_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel_sizer.Add(motion_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel.SetSizer(panel_sizer)

        sizer = wx.BoxSizer(wx.VERTICAL)
        sizer.Add(panel, 0, wx.EXPAND | wx.ALL, 10)
        self.SetSizer(sizer)

        # Bind events
        self.Bind(wx.EVT_BUTTON, self.OnDoorOpen, button_door_open)
        self.Bind(wx.EVT_BUTTON, self.OnDoorClosed, button_door_closed)
        self.Bind(wx.EVT_BUTTON, self.OnWindowOpen, button_window_open)
        self.Bind(wx.EVT_BUTTON, self.OnWindowClosed, button_window_closed)
        self.Bind(wx.EVT_BUTTON, self.OnFlood, button_flood)
        self.Bind(wx.EVT_BUTTON, self.OnTemp, button_temp)
        self.Bind(wx.EVT_BUTTON, self.OnKeyboard, button_keyboard)
        self.Bind(wx.EVT_BUTTON, self.OnMotion, button_motion)

        self.Show(True)

    def OnDoorOpen(self, wx_event):
        try:
            door_id = int(self.door_id.GetValue())
            e = event.DoorSensorEvent(0, door_id, True)
            g_event_manager.broadcast_event(e)
        except ValueError:
            pass

    def OnDoorClosed(self, wx_event):
        try:
            door_id = int(self.door_id.GetValue())
            e = event.DoorSensorEvent(0, door_id, False)
            g_event_manager.broadcast_event(e)
        except ValueError:
            pass

    def OnWindowOpen(self, wx_event):
        try:
            window_id = int(self.window_id.GetValue())
            e = event.WindowSensorEvent(1, window_id, True)
            g_event_manager.broadcast_event(e)
        except ValueError:
            pass

    def OnWindowClosed(self, wx_event):
        try:
            window_id = int(self.window_id.GetValue())
            e = event.WindowSensorEvent(1, window_id, False)
            g_event_manager.broadcast_event(e)
        except ValueError:
            pass

    def OnFlood(self, wx_event):
        try:
            level = int(self.flood_level.GetValue())
            delta = int(self.flood_delta.GetValue())
            e = event.FloodSensorEvent(2, level, delta)
            g_event_manager.broadcast_event(e)
        except ValueError:
            pass

    def OnTemp(self, wx_event):
        try:
            temp = int(self.temp.GetValue())
            delta = int(self.temp_delta.GetValue())
            e = event.TempSensorEvent(3, temp, delta)
            g_event_manager.broadcast_event(e)
        except ValueError:
            pass

    def OnKeyboard(self, wx_event):
        string = self.keyboard.GetValue()
        if len(string) > 1:
            string = string[0]

        e = event.KeypadEvent(4, string)
        g_event_manager.broadcast_event(e)

    def OnMotion(self, wx_event):
        e = event.MotionSensorEvent(5,
                                    0,
                                    datetime.utcnow() - timedelta(seconds=31))
        g_event_manager.broadcast_event(e)
        

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-p',
                        '--peers',
                        help='comma seperated list of peers to connect to. eg: \'localhost:8001,localhost:8002\'',
                        required=True,
                        dest='peers')
    parser.add_argument('-v',
                        '--verbose',
                        default=False,
                        action='store_true',
                        dest='verbose',
                        help='show debug logging')

    args = parser.parse_args()
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)

    peer_list = []
    for peer in args.peers.split(','):
        peer_list.append(tuple(peer.split(':')))

    g_event_manager = EventManager(peer_list)

    app = wx.App(False)
    frame = SensorFrame(None, 'GARTH Sensor Demo Console')

    app.MainLoop()
