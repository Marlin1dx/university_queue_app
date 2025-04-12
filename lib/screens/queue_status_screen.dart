import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:university_queue_app/api/websocket_service.dart';
import 'package:university_queue_app/models/queue.dart';
import 'dart:convert';

class QueueStatusScreen extends StatefulWidget {
  final int queueId;

  const QueueStatusScreen({required this.queueId});

  @override
  _QueueStatusScreenState createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends State<QueueStatusScreen> {
  late WebSocketService _webSocketService;
  late Future<Queue> _queueFuture;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(widget.queueId);
    _webSocketService.connect();
    _loadQueueData();
  }

  Future<void> _loadQueueData() async {
    try {
      final queueData = await ApiService().getQueueStatus(widget.queueId);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Ошибка загрузки данных: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статус очереди')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : FutureBuilder<Queue>(
                  future: _queueFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text('Ошибка: ${snapshot.error}');
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    
                    return Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(snapshot.data!.name),
                            subtitle: Text('Текущая позиция: ${snapshot.data!.currentPosition}'),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: _webSocketService.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Ошибка потока: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final data = jsonDecode(snapshot.data);
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ваша позиция: ${data['current_position']}',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 20),
                                    LinearProgressIndicator(
                                      value: data['current_position'] / 100,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
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