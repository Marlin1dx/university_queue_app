import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_queue_app/api/api_service.dart';
import 'package:university_queue_app/models/queue.dart';
import 'package:university_queue_app/widgets/queue_card.dart';

class QueueListScreen extends StatefulWidget {
  @override
  _QueueListScreenState createState() => _QueueListScreenState();
}

class _QueueListScreenState extends State<QueueListScreen> {
  late Future<List<Queue>> _queuesFuture;

  @override
  void initState() {
    super.initState();
    _queuesFuture = _loadQueues();
  }

  Future<List<Queue>> _loadQueues() async {
    try {
      return await ApiService().getQueues();
    } catch (e) {
      throw Exception('Ошибка загрузки: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Доступные очереди')),
      body: FutureBuilder<List<Queue>>(
        future: _queuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных очередей'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, i) => QueueCard(queue: snapshot.data![i]),
          );
        },
      ),
    );
  }
}