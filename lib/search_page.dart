import 'package:flutter/material.dart';

void main() {
  runApp(ChatbotApp());
}

class ChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(color: Colors.white10),
      ),
      home: ChatbotSearchPage(),
    );
  }
}

class ChatbotSearchPage extends StatefulWidget {
  @override
  _ChatbotSearchPageState createState() => _ChatbotSearchPageState();
}

class _ChatbotSearchPageState extends State<ChatbotSearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchResult = "";

  final Map<String, String> actsAndRules = {
    "Coal Mines Act, 1952": "Regulates coal mining industry in India.",
    "Indian Explosives Act, 1884": "Governs the manufacture and storage of explosives.",
    "Colliery Control Order, 2000": "Regulates production, supply, and distribution of coal.",
    "Colliery Control Rules, 2004": "Provides operational guidelines for collieries.",
    "Coal Mines Regulations, 2017": "Ensures safety and efficiency in coal mining.",
    "Payment of Wages (Mines) Rules, 1956": "Defines wage payment regulations for miners.",
    "CBA (Coal Bearing Areas) Act": "Regulates acquisition of coal-bearing lands.",
    "LA (Land Acquisition) Act": "Governs land acquisition for public purposes.",
    "RandR (Rehabilitation and Resettlement) Act": "Provides for rehabilitation and resettlement of affected families.",
  };

  void _search() {
    String query = _searchController.text.trim();
    setState(() {
      _searchResult = actsAndRules.containsKey(query)
          ? actsAndRules[query]!
          : "Not Found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mining Laws Chatbot", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Acts & Rules...",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: _search,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _searchResult,
              style: TextStyle(
                fontSize: 18,
                color: _searchResult == "Not Found" ? Colors.red : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Available Acts & Rules:",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: actsAndRules.length,
                itemBuilder: (context, index) {
                  String key = actsAndRules.keys.elementAt(index);
                  return ListTile(
                    title: Text(
                      key,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      actsAndRules[key]!,
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}