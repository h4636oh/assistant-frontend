import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blueAccent,
        colorScheme: ColorScheme.dark(primary: Colors.blueAccent),
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {
      "type": "bus",
      "data": {
        "name": "Bus A",
        "type": "AC Sleeper",
        "departure": "10:00 AM",
        "arrival": "2:00 PM",
        "duration": "4h",
        "star": "4.5",
        "price": "\$20"
      }
    },
    {
      "type": "bus",
      "data": {
        "name": "Bus B",
        "type": "Non-AC",
        "departure": "11:00 AM",
        "arrival": "3:30 PM",
        "duration": "4.5h",
        "star": "4.0",
        "price": "\$18"
      }
    },
    {
      "type": "bus",
      "data": {
        "name": "Bus C",
        "type": "AC Semi-Sleeper",
        "departure": "1:00 PM",
        "arrival": "5:00 PM",
        "duration": "4h",
        "star": "4.7",
        "price": "\$22"
      }
    }
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      messages.add({"type": "text", "text": _controller.text, "sender": "user"});
      messages.add({"type": "text", "text": "This is a placeholder response.", "sender": "bot"});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assistant", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: Icon(Icons.chat_bubble, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                if (msg["type"] == "text") {
                  bool isUser = msg["sender"] == "user";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg["text"]!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ).animate().fade(duration: 500.ms).slideY(),
                  );
                } else if (msg["type"] == "bus") {
                  final bus = msg["data"];
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: BusCard(
                      name: bus["name"],
                      type: bus["type"],
                      departure: bus["departure"],
                      arrival: bus["arrival"],
                      duration: bus["duration"],
                      star: bus["star"],
                      price: bus["price"],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  backgroundColor: Colors.blueAccent,
                  onPressed: _sendMessage,
                  child: Icon(Icons.send, color: Colors.white).animate().scale(duration: 200.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final String name;
  final String type;
  final String departure;
  final String arrival;
  final String duration;
  final String star;
  final String price;

  const BusCard({super.key, 
    required this.name,
    required this.type,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.star,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(type, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                SizedBox(height: 10),
                Text("$departure → $arrival",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(duration, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                SizedBox(height: 10),
                Text("⭐ $star", style: TextStyle(fontSize: 14, color: Colors.white)),
                Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms).slideY();
  }
}
