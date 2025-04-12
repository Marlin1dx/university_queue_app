import 'package:flutter/material.dart';
import 'package:your_app/api/api_service.dart';
import 'package:your_app/screens/queue_status_screen.dart';

class QueueCard extends StatelessWidget {
  final Queue queue;

  const QueueCard({required this.queue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(queue.name),
        subtitle: Text('Текущая позиция: ${queue.currentPosition}'),
        trailing: ElevatedButton(
          onPressed: () async {
            try {
              await ApiService().joinQueue(queue.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QueueStatusScreen(queueId: queue.id),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка записи в очередь')),
              );
            }
          },
          child: Text('Записаться'),
        ),
      ),
    );
  }
}