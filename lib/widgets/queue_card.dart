import 'package:flutter/material.dart';
import 'package:university_queue_app/models/queue.dart';

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
          onPressed: () {}, // Пока оставьте пустым
          child: Text('Записаться'),
        ),
      ),
    );
  }
}