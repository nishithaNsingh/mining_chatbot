import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ChatService {
  static const String _baseUrl = 'https://singh7nishitha.pythonanywhere.com/chat';

  Future<String> sendMessage(String query) async {
    try {
      // Extensive logging
      print('Attempting to send message');
      print('URL: $_baseUrl');
      print('Query: $query');

      // Check internet connectivity
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Internet connection is confirmed');
        }
      } on SocketException catch (_) {
        print('No internet connection detected');
        throw Exception('No internet connection. Please check your network.');
      }

      // Validate query
      if (query.trim().isEmpty) {
        print('Query is empty');
        throw Exception('Query cannot be empty');
      }

      // Prepare and log the request payload
      final payload = json.encode({'query': query});
      print('Request Payload: $payload');

      // Add more headers for debugging
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br'
        },
        body: payload,
      ).timeout(
        Duration(seconds: 120), // Increased timeout to 30 seconds
        onTimeout: () {
          print('Request timed out');
          throw Exception('Request timed out. Please try again.');
        },
      );

      // Extensive response logging
      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('Parsed Response: $responseData');

          // Handle empty response
          if (responseData['response'] == null || responseData['response'].isEmpty) {
            throw Exception('Empty response from server');
          }

          return responseData['response'];
        } catch (e) {
          print('JSON Parsing Error: $e');
          throw Exception('Failed to parse server response');
        }
      } else {
        print('Server Error: ${response.statusCode}');
        throw Exception('Failed to send message. Status code: ${response.statusCode}. Body: ${response.body}');
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      throw Exception('Network error. Please check your internet connection.');
    } on HttpException catch (e) {
      print('HTTP Exception: $e');
      throw Exception('Could not reach the server. Please try again later.');
    } on FormatException catch (e) {
      print('Format Exception: $e');
      throw Exception('Invalid response from server. Please try again.');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}