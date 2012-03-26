#
#   CommunicationsInterface.py
#   
#   Provides the interface for the EventManger to listen and broadcast events
#   from controllers and sensors using sockets.
#

import time
import pickle
import select
import socket
import logging
import threading

class ListenerThread(threading.Thread):
    def __init__(self, event_manager, listen_port):
        """
        ListenerThread constructor

        Keyword arguments:
        event_manager -- EventManager to pass received Events to
        listen_port -- port to listen on

        """

        threading.Thread.__init__(self)
        
        self._listen_port = listen_port
        self._event_manager = event_manager
        self._stop = threading.Event()
        self._ready = threading.Event()

    def is_listening(self):
        """
        Returns True if the listening socket has been bound, False otherwise.

        """

        return self._ready.isSet()

    def stop(self):
        """
        Signal this thread to stop.

        """

        self._stop.set()

    def run(self):
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setblocking(0)
        server_socket.bind((socket.gethostname(), self._listen_port))
        server_socket.listen(5)
        self._ready.set()

        logging.debug("Bound socket on port %s" % self._listen_port)        

        while not self._stop.isSet():

            # Check if there is input
            readable, writable, exceptional = select.select(
                [server_socket], [], [], 0.01)

            for s in readable:
                (client_socket, address) = s.accept()
                data_received = ''
            
                # Read all the data the client sends
                while True:
                    data = client_socket.recv(1024)
                    data_received += data
                    if not data:
                        break

                event = pickle.loads(data_received)
                self._event_manager.event_received(event)
                
        server_socket.close()
        logging.debug("Listener thread finished")
  

class CommunicationsInterface:

    @classmethod
    def listen(cls, event_manager, listen_port):
        """

        Returns a ListenerThread which will handle listening for data,
        parsing received data into Event objects, and calling
        event_received() on the EventManager.

        """

        return ListenerThread(event_manager, listen_port)

    #
    # Broadcast data to all peers
    #
        
    @classmethod
    def broadcast_data(cls, data, peers):
        """
        Broadcast string data to a list of peers.

        Keyword arguments:
        data -- string to broadcast
        peers -- list of peer tuples of the form (hostname, port)
        
        """
        
        logging.debug("Broadcasting data")

        for peer in peers:
            try:

                # Connect to peer
                s = socket.create_connection(peer)
                logging.debug("Connected to peer %s:%s" % (peer[0], peer[1]))
                s.sendall(data)
                s.shutdown(socket.SHUT_RDWR)
                s.close()

            except socket.error, e:
                logging.error("Socket error with peer \"%s:%s\": %s" % (
                        peer[0], peer[1], e))

        logging.debug("Broadcast complete")
