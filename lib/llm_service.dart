import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class LLMService {
  final String _baseUrl = 'https://localhost:8080'; 
  WebSocketChannel? _channel;

  // Authenticate and obtain JWT token
  Future<String> authenticate(String username, String password) async {
    final url = Uri.parse('$_baseUrl/api/token/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  // Connect to the WebSocket with the JWT token
  void connectToWebSocket(String token) {
    final url = 'ws://localhost/ws/llm/?token=$token';  // Replace with your WebSocket URL
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  // Send a prompt to the LLM
  void sendPrompt(String prompt) {
    if (_channel != null) {
      _channel!.sink.add(json.encode({'prompt': prompt}));
    } else {
      throw Exception('WebSocket is not connected');
    }
  }

  // Listen for responses from the LLM
  Stream<String> receiveResponse() {
    if (_channel != null) {
      return _channel!.stream.map((event) => json.decode(event)['response']);
    } else {
      throw Exception('WebSocket is not connected');
    }
  }

  // Close the WebSocket connection
  void disconnect() {
    _channel?.sink.close();
  }
}
