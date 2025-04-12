class Queue {
  final int id;
  final String name;
  final int currentPosition;

  Queue({
    required this.id,
    required this.name,
    required this.currentPosition,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      id: json['id'],
      name: json['name'],
      currentPosition: json['current_position'] ?? 0,
    );
  }
}