import 'package:flutter/material.dart';
import 'llm_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLM WebSocket App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LLMHomePage(),
    );
  }
}

class LLMHomePage extends StatefulWidget {
  @override
  _LLMHomePageState createState() => _LLMHomePageState();
}

class _LLMHomePageState extends State<LLMHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  final LLMService _llmService = LLMService();

  String _response = '';
  String _token = '';

  void _authenticate() async {
    try {
      final token = await _llmService.authenticate(
        _usernameController.text,
        _passwordController.text,
      );
      setState(() {
        _token = token;
      });
      _llmService.connectToWebSocket(_token);
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
      });
    }
  }

  void _sendPrompt() {
    try {
      _llmService.sendPrompt(_promptController.text);
      _llmService.receiveResponse().listen((message) {
        setState(() {
          _response = message;
        });
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _llmService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LLM WebSocket App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: 'Enter a prompt',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendPrompt,
              child: Text('Send Prompt'),
            ),
            SizedBox(height: 16.0),
            Text(
              _response,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
