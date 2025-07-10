import 'package:dinamica1/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:dinamica1/views/home_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes:{
        '/': (context) => const LoginView(),
        '/home': (context) => const HomeView()
      }


    
    );
  }
}

