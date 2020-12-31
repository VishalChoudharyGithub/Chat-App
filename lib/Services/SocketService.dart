import 'package:flash_chat/Services/StreamSocket.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  Socket socket;
  StreamSocket streamSocket;
  SocketService(StreamSocket streamSocket) {
    this.streamSocket = streamSocket;
    socket = socket = io('< Your Server address here>',
            OptionBuilder().setTransports(['websocket']).build())
        .connect();
    socket.onConnect((data) {
      print("connected");
    });
    socket.onDisconnect((data) {
      print(data);
    });
    socket.onConnectError((data) {
      print("error connecting");
      print(data);
    });
    socket.onConnecting((data) {
      print("connecting");
    });
    socket.on("message_received", (jsonData) {
      streamSocket.addSingleitem(jsonData);
    });
    socket.onError((data) {
      print("error occured");
      print(data);
    });
  }
  void disposeSocket() {
    socket.dispose();
  }

  Socket getsocket() {
    return socket;
  }
}
