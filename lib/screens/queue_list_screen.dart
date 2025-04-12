import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app/api/api_service.dart';
import 'package:your_app/models/queue.dart';
import 'package:your_app/widgets/queue_card.dart';

class QueueListScreen extends StatefulWidget {
  @override
  _QueueListScreenState createState() => _QueueListScreenState();
}

class _QueueListScreenState extends State<QueueListScreen> {
  late Future<List<Queue>> _queuesFuture;

  @override
  void initState() {
    super.initState();
    _queuesFuture = ApiService().getQueues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Доступные очереди')),
      body: FutureBuilder<List<Queue>>(
        future: _queuesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
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