import pickle
import threading
import Queue
from communicationsinterface import CommunicationsInterface

class EventManager:
    def __init__(self, peers, listen_port=None):
        """
        EventManager constructor.

        Keyword arguments:
        peers -- list of peers to connect to when broadcasting events.
                 Each peer is a tuple of the form (hostname, port).
        listen_port -- Port to listen for incoming events on. If this is not
                       specified, no listener thread will be created and no
                       events will be received.
        
        """

        self.peers = peers

        self.in_event_queue = Queue.Queue()
        self.subscriptions = {}

        # Start thread to listen for incoming events    
        if listen_port:
            self.peers.append(('localhost', listen_port))
            self.listener_thread = CommunicationsInterface.listen(self, listen_port)
            self.listener_thread.daemon = True
            self.listener_thread.start()

    def is_listening(self):
        """
        Returns True if the listener thread has bound its port and
        is listening, False otherwise.

        """

        return self.listener_thread.is_listening()

    def shutdown(self):
        """
        Shutdown the listener thread and block until it has exited.

        """
        
        self.listener_thread.stop()
        self.listener_thread.join()

    @classmethod
    def serialize_event(cls, event):
        """
        Return a string representing the serialized version of an Event object.

        Keyword arguments:
        event -- Event to serialize.

        """

        return pickle.dumps(event)

    @classmethod
    def deserialize_event(cls, event_string):
        """
        Deserialize a string back into an Event object.

        Keyword arguments:
        event_string -- String to deserialize

        """

        return pickle.loads(event_string)

    def event_received(self, event):
        """
        Puts an Event into the received Event queue

        Keyword arguments:
        event -- event to enqueue

        """

        self.in_event_queue.put(event)
        
    def broadcast_event(self, event):
        """
        Broadcast an Event to all peers. If this EventManager is listening,
        the Event will be broadcast to itself as well.

        Keyword arguments:
        event -- Event to broadcast

        """

        data = self.serialize_event(event)
        CommunicationsInterface.broadcast_data(data, self.peers)
   
    def subscribe(self, event_type, controller):
        """
        Subscribe a Controller to receive events of a certain type. 
        When an Event with the event type of event_type is received, 
        the Event will be passed to controller via handle_event.

        Keyword arguments:
        event_type -- EventType to subscribe to
        controller -- Controller to subscribe

        """
        
        if not event_type in self.subscriptions:
            self.subscriptions[event_type] = []
        
        if controller not in self.subscriptions[event_type]:
            self.subscriptions[event_type].append(controller)

    def process_events(self):
        """
        Attempt to process Events that are waiting in the queue. If no event
        can be dequeued within 1 second, return.

        This should be called frequently to move events through the system.

        """

        # Get an event from the incoming queue and dispatch it to subscribers
        try:
            event = self.in_event_queue.get(timeout=1)
            if event.event_type in self.subscriptions:
                for controller in self.subscriptions[event.event_type]:
                    controller.handle_event(event)
        except Queue.Empty:
            pass
