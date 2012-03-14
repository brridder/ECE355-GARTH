import select
import socket
import logging
import threading

class ListenerThread(threading.Thread):
    def __init__(self, event_manager, listen_port):
        self._listen_port = listen_port
        self._event_manager = event_manager
        self._stop = threading.Event()

    def stop(self):
        self._stop.set()

    def run(self):
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setblocking(0)
        server_socket.bind((socket.gethostname(), listen_port))
        server_socket.listen(5)

        logging.debug("Bound socket on port %s" % listen_port)        

        while not self._stop.isSet():

            # Check if there is input
            readable, writable, exceptional = select.select(
                [server_socket], [], [], 0)

            for s in readable:
                (client_socket, address) = s.accept()
                data_received = ''
            
                # Read all the data the client sends
                while True:
                    data = client_socket.recv(1024)
                    data_received += data
                    if not data:
                        break
                logging.debug("Received data: \"%s\"" % data_received)
            time.sleep(0)
                
        server_socket.close()
        logging.debug("Listener thread finished")
  

class CommunicationsInterface:

    #
    # Returns a ListenerThread which will handle listening for data,
    # parsing received data into Event objects, and calling
    # event_received() on the EventManager.
    #
    
    @classmethod
    def listen(cls, event_manager, listen_port):
        return ListenerThread(event_manager, listen_port)

    #
    # Broadcast data to all peers
    #
        
    @classmethod
    def broadcast_data(cls, data, peers):
        logging.debug("Broadcasting data: %s" % data)

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
