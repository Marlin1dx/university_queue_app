import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final int queueId;

  WebSocketService(this.queueId);

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:3000/queue.$queueId'),
    );
  }

  Stream<dynamic> get stream => _channel!.stream;

  void dispose() {
    _channel?.sink.close();
  }
}