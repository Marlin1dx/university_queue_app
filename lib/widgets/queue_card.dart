import 'package:flutter/material.dart';
import 'package:university_queue_app/models/queue.dart';

class QueueCard extends StatelessWidget {
  final Queue queue;
  final VoidCallback? onDelete;

  const QueueCard({
    super.key,
    required this.queue,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(queue.name),
        subtitle: Text('Текущая позиция: ${queue.currentPosition}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Записаться'),
            ),
          ],
        ),
      ),
    );
  }
}