import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university_queue_app/providers/auth_provider.dart';
import 'package:university_queue_app/screens/auth_screen.dart';
import 'package:university_queue_app/screens/queue_list_screen.dart';
import 'package:university_queue_app/screens/admin_panel_screen.dart';  // Убедитесь, что файл существует!

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Queue',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
        
          if (auth.isAuthenticated) {
            if (auth.isAdmin) {
              return AdminPanelScreen();  
            } else {
              return QueueListScreen(); 
            }
          } else {
            return AuthScreen();  
          }
        },
      ),
    );
  }
}
