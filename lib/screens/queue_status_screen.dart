import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:university_queue_app/api/websocket_service.dart';

class QueueStatusScreen extends StatefulWidget {
  final int queueId;

  const QueueStatusScreen({required this.queueId});

  @override
  _QueueStatusScreenState createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends State<QueueStatusScreen> {
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(widget.queueId);
    _webSocketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Статус очереди')),
      body: StreamBuilder(
        stream: _webSocketService.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = jsonDecode(snapshot.data);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ваша позиция: ${data['current_position']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: data['current_position'] / 100,
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}