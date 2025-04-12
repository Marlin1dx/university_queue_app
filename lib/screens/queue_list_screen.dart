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
  bool _isLoading = true; // Статус загрузки данных
  String _errorMessage = ''; // Сообщение об ошибке

  @override
  void initState() {
    super.initState();
    _loadQueues(); // Загружаем очереди
  }

  // Метод для загрузки очередей
  Future<void> _loadQueues() async {
    try {
      final response = await ApiService().getQueues();
      if (response != null) {
        setState(() {
          _queuesFuture = Future.value(response); // Устанавливаем результат в Future
          _isLoading = false; // Завершаем загрузку
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Нет доступных очередей';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка загрузки данных: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Доступные очереди')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Индикатор загрузки
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage)) // Сообщение об ошибке
              : FutureBuilder<List<Queue>>(
                  future: _queuesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Ошибка загрузки данных'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Нет доступных очередей'));
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
