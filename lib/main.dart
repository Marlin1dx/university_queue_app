import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_queue_app/providers/auth_provider.dart';
import 'package:university_queue_app/screens/auth_screen.dart';
import 'package:university_queue_app/screens/queue_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class Queue {
  final int id;
  final String name;

  Queue({required this.id, required this.name});

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      id: json['id'],
      name: json['name'],
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Queue',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => auth.isAuthenticated
            ? QueueListScreen()
            : AuthScreen(),
      ),
    );
  }
}
