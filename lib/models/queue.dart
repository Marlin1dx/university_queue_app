// lib/models/queue.dart
class Queue {
  final int id;
  final String name;
  final int currentPosition;

  Queue({
    required this.id,
    required this.name,
    required this.currentPosition,
  });

  // Фабричный метод для создания объекта из JSON
  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      id: json['id'],
      name: json['name'],
      currentPosition: json['current_position'] ?? 0,
    );
  }

  // Метод для преобразования объекта в JSON для отправки на сервер
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'current_position': currentPosition,
    };
  }
}
