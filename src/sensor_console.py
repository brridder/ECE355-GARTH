#!/usr/bin/env python2

import wx
import logging
import argparse

import event
from eventmanager import EventManager

MIN_WINDOW_SIZE = wx.Size(590, 500)

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
        door_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Doors')
        door_sizer = wx.StaticBoxSizer(door_staticbox, wx.HORIZONTAL)
        door_sizer.Add(button_door_open, 0, wx.ALL, border=5)
        door_sizer.Add(button_door_closed, 0, wx.ALL, border=5)

        # Windows
        button_window_open = wx.Button(panel, wx.ID_ANY, 'Open Window')
        button_window_closed = wx.Button(panel, wx.ID_ANY, 'Close Window')
        window_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Windows')
        window_sizer = wx.StaticBoxSizer(window_staticbox, wx.HORIZONTAL)
        window_sizer.Add(button_window_open, 0, wx.ALL, border=5)
        window_sizer.Add(button_window_closed, 0, wx.ALL, border=5)

        door_window_sizer = wx.BoxSizer(wx.HORIZONTAL)
        door_window_sizer.Add(door_sizer)
        door_window_sizer.Add(window_sizer, 1, wx.LEFT, border=10)

        # Flood
        button_flood = wx.Button(panel, wx.ID_ANY, 'Trigger Flood Sensor')
        self.flood_level = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        flood_level_label = wx.StaticText(panel, wx.ID_ANY, label='Level: ')
        self.flood_delta = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        flood_delta_label = wx.StaticText(panel, wx.ID_ANY, label='Delta: ')

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
        temp_level_label = wx.StaticText(panel, wx.ID_ANY, label='Temp: ')
        self.temp_delta = wx.TextCtrl(panel, wx.ID_ANY, value='0')
        temp_delta_label = wx.StaticText(panel, wx.ID_ANY, label='Delta: ')

        temp_staticbox = wx.StaticBox(panel, wx.ID_ANY, 'Temp Sensors')
        temp_sizer = wx.StaticBoxSizer(temp_staticbox, wx.HORIZONTAL)    
        temp_sizer.Add(button_temp, 0, wx.ALL, border=5)
        temp_sizer.Add(temp_level_label, 0, wx.ALL, border=5)        
        temp_sizer.Add(self.temp, 0, wx.ALL, border=5)
        temp_sizer.Add(temp_delta_label, 0, wx.ALL, border=5)        
        temp_sizer.Add(self.temp_delta, 0, wx.ALL, border=5)

        # Panel
        panel_sizer = wx.BoxSizer(wx.VERTICAL)
        panel_sizer.Add(title)
        panel_sizer.Add(title_line)
        panel_sizer.Add(door_window_sizer, 0, wx.EXPAND | wx.TOP, border=5)
        panel_sizer.Add(flood_sizer, 1, wx.EXPAND | wx.TOP, border=10)
        panel_sizer.Add(temp_sizer, 1, wx.EXPAND | wx.TOP, border=10)
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

        self.Show(True)

    def OnDoorOpen(self, wx_event):
        e = event.DoorSensorEvent(0, 0, True)
        g_event_manager.broadcast_event(e)

    def OnDoorClosed(self, wx_event):
        e = event.DoorSensorEvent(0, 0, False)
        g_event_manager.broadcast_event(e)

    def OnWindowOpen(self, wx_event):
        e = event.WindowSensorEvent(1, 0, True)
        g_event_manager.broadcast_event(e)

    def OnWindowClosed(self, wx_event):
        e = event.WindowSensorEvent(1, 0, False)
        g_event_manager.broadcast_event(e)

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
