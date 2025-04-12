import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:university_queue_app/models/queue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<List<Queue>> getQueues() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/queues'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Queue.fromJson(json)).toList();
    }
    throw Exception('Ошибка загрузки очередей');
  }

  Future<void> createQueue(Queue queue) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/queues'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': queue.name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка создания очереди');
    }
  }

  Future<void> deleteQueue(int queueId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/queues/$queueId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка удаления очереди');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}