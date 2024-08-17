import 'package:flutter/material.dart';
import 'package:llm_websocket_app/llm_homepage.dart';
import 'llm_service.dart'; 

void main() {
  runApp(MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLM WebSocket App', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary theme color
      ),
      home: LLMHomePage(), // Set the home page to LLMHomePage
    );
  }
}
