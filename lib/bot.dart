import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'chat_service.dart';
import 'message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  List<Message> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final userMessage = Message(text: messageText, isUserMessage: true);
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();

    try {
      developer.log('Sending message: $messageText', name: 'ChatScreen', level: 800);
      final response = await _chatService.sendMessage(messageText);
      developer.log('Received response: $response', name: 'ChatScreen', level: 800);

      setState(() {
        _messages.add(Message(text: response, isUserMessage: false));
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error sending message', name: 'ChatScreen', error: e, level: 1000);
      setState(() {
        _messages.add(Message(text: 'Error: ${e.toString()}', isUserMessage: false));
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Connection Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _sendMessage(); // Retry sending the message
            },
          ),
          TextButton(
            child: Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mining Law Chatbot'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageBubble(_messages.reversed.toList()[index]),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isUserMessage ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          message.text,
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask about mining laws...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.black,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}