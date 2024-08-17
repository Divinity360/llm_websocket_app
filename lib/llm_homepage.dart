import 'package:flutter/material.dart';
import 'package:llm_websocket_app/llm_service.dart';

/// The main page of the app where users can authenticate and interact with the LLM.
class LLMHomePage extends StatefulWidget {
  @override
  _LLMHomePageState createState() => _LLMHomePageState();
}

class _LLMHomePageState extends State<LLMHomePage> {
  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  
  // Instance of LLMService to handle authentication and WebSocket communication
  final LLMService _llmService = LLMService();

  // Variables to store the response and authentication token
  String _response = '';
  String _token = '';

  /// Authenticates the user and connects to the WebSocket with the received token.
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
        _response = 'Error: ${e.toString()}'; // Display error message if authentication fails
      });
    }
  }

  /// Sends a prompt to the LLM and listens for a response.
  void _sendPrompt() {
    try {
      _llmService.sendPrompt(_promptController.text);
      _llmService.receiveResponse().listen((message) {
        setState(() {
          _response = message; // Update the UI with the response from the LLM
        });
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}'; // Display error message if sending the prompt fails
      });
    }
  }

  /// Disconnects from the WebSocket when the widget is disposed.
  @override
  void dispose() {
    _llmService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LLM WebSocket App'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username input field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hide the password input
            ),
            SizedBox(height: 16.0),
            // Authenticate button
            ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate'),
            ),
            SizedBox(height: 16.0),
            // Prompt input field
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: 'Enter a prompt',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Send prompt button
            ElevatedButton(
              onPressed: _sendPrompt,
              child: Text('Send Prompt'),
            ),
            SizedBox(height: 16.0),
            // Display the response from the LLM
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