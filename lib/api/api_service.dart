import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<http.Response> register(String name, String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );
  }

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
    }

    return response;
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
    throw Exception('Failed to load queues');
  }

  Future<void> joinQueue(int queueId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/queues/$queueId/join'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to join queue');
    }
  }
}