import 'package:flutter/material.dart';
import 'package:university_queue_app/api/api_service.dart';
import 'package:university_queue_app/models/queue.dart';
import 'package:university_queue_app/widgets/queue_card.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late Future<List<Queue>> _queuesFuture;

  @override
  void initState() {
    super.initState();
    _refreshQueues();
  }

  void _refreshQueues() {
    setState(() {
      _queuesFuture = ApiService().getQueues();
    });
  }

  void _createQueue() async {
    try {
      await ApiService().createQueue(Queue(
        id: 0, // ID будет сгенерирован сервером
        name: 'Новая очередь',
        currentPosition: 0
      ));
      _refreshQueues();
    } catch (e) {
      print('Ошибка создания: $e');
    }
  }

  void _deleteQueue(int queueId) async {
    try {
      await ApiService().deleteQueue(queueId);
      _refreshQueues();
    } catch (e) {
      print('Ошибка удаления: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Панель администратора')),
      floatingActionButton: FloatingActionButton(
        onPressed: _createQueue,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Queue>>(
        future: _queuesFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (ctx, i) => QueueCard(
              queue: snapshot.data![i],
              onDelete: () => _deleteQueue(snapshot.data![i].id),
            ),
          );
        },
      ),
    );
  }
}