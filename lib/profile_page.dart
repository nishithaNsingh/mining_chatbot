import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Chatbot Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Mining Industry Chatbot',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Your AI Assistant for Mining Acts, Rules & Regulations',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              Divider(color: Colors.grey[700], height: 32, thickness: 1),
              _buildProfileOption(context, Icons.info, 'About Chatbot', 'AI-powered assistant for Mining queries', AboutChatbotPage()),
              _buildProfileOption(context, Icons.rule, 'Regulations & Acts', 'View Mining laws and policies', RegulationsActsPage()),
              _buildProfileOption(context, Icons.help, 'FAQs', 'Commonly asked questions and answers', FAQsPage()),
              _buildProfileOption(context, Icons.message, 'Start Query', 'Ask me about Mining laws', StartQueryPage()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement action to start chatbot query
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text('Start Chat'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title, String subtitle, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

class AboutChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'This chatbot is designed to assist users with queries related to mining acts, rules, and regulations. It leverages AI to provide accurate and timely information.',
          style: TextStyle(fontSize: 16,color: Colors.white),
        ),
      ),
    );
  }
}

class RegulationsActsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulations & Acts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Here you can find detailed information about various mining regulations and acts. This includes environmental regulations, safety standards, and operational guidelines.',
          style: TextStyle(fontSize: 16,color: Colors.white),
        ),
      ),
    );
  }
}

class FAQsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Frequently Asked Questions about mining laws and regulations. This section aims to clarify common doubts and provide quick answers to typical queries.',
          style: TextStyle(fontSize: 16,color: Colors.white),
        ),
      ),
    );
  }
}

class StartQueryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Query'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Start a new query to get detailed information about specific mining laws, regulations, or any other related topics. The chatbot is here to assist you with accurate and reliable information.',
          style: TextStyle(fontSize: 16,color: Colors.white),
        ),
      ),
    );
  }
}