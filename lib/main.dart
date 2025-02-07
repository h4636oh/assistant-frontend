// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

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
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  //updates bus constructor to contain all data
  BusCard createBusCard({
    required String busName,
    required String busType,
    required String departureTime,
    required String departureDate,
    required String arrivalTime,
    required String arrivalDate,
    required String duration,
    required String finalPrice,
    required String rating,
    required String seatsAvailable,
    required String url,
  }) {
    return BusCard(
      busName: busName,
      busType: busType,
      departureTime: departureTime,
      departureDate: departureDate,
      arrivalTime: arrivalTime,
      arrivalDate: arrivalDate,
      duration: duration,
      finalPrice: finalPrice,
      rating: rating,
      seatsAvailable: seatsAvailable,
      url: url,
    );
  }

  /// Called when the send button is pressed.
  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      if (_controller.text.startsWith("bus")) {
        //bus input for testing purposes
        addBusCardsToMessages();
      } else {
        messages.add({
          "type": "text",
          "text": _controller.text,
          "sender": "user",
        });
        messages.add({
          "type": "text",
          "text": "This is a placeholder response.",
          "sender": "bot",
        });
      }
    });
    _controller.clear();
  }

  /// Loops over the JSON list and creates a BusCard for each bus.
  void addBusCardsToMessages() {
    //example for bus data
    final List<Map<String, dynamic>> busDataList = [
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "11:30 PM",
        "departure_date": "10 Feb",
        "arrival_time": "05:05 AM",
        "arrival_date": "11 Feb",
        "duration": "05h 35m",
        "final_price": "346",
        "rating": "3.5",
        "seats_available": "17",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "09:30 AM",
        "departure_date": "10 Feb",
        "arrival_time": "03:20 PM",
        "arrival_date": "10 Feb",
        "duration": "05h 50m",
        "final_price": "346",
        "rating": "3.1",
        "seats_available": "41",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "11:50 PM",
        "departure_date": "10 Feb",
        "arrival_time": "06:05 AM",
        "arrival_date": "11 Feb",
        "duration": "06h 15m",
        "final_price": "346",
        "rating": "3.2",
        "seats_available": "12",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater/Sleeper Electric",
        "departure_time": "11:55 PM",
        "departure_date": "10 Feb",
        "arrival_time": "05:50 AM",
        "arrival_date": "11 Feb",
        "duration": "05h 55m",
        "final_price": "354",
        "rating": "3.1",
        "seats_available": "12",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater/Sleeper 2+1 Bharat Benz",
        "departure_time": "11:59 PM",
        "departure_date": "10 Feb",
        "arrival_time": "05:40 AM",
        "arrival_date": "11 Feb",
        "duration": "05h 41m",
        "final_price": "399",
        "rating": "4.6",
        "seats_available": "10",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "02:00 PM",
        "departure_date": "10 Feb",
        "arrival_time": "07:50 PM",
        "arrival_date": "10 Feb",
        "duration": "05h 50m",
        "final_price": "346",
        "rating": "2.8",
        "seats_available": "19",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "04:00 PM",
        "departure_date": "10 Feb",
        "arrival_time": "09:50 PM",
        "arrival_date": "10 Feb",
        "duration": "05h 50m",
        "final_price": "346",
        "rating": "2.8",
        "seats_available": "11",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "06:30 AM",
        "departure_date": "10 Feb",
        "arrival_time": "12:20 PM",
        "arrival_date": "10 Feb",
        "duration": "05h 50m",
        "final_price": "342",
        "rating": "3.2",
        "seats_available": "12",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "06:30 PM",
        "departure_date": "10 Feb",
        "arrival_time": "12:20 AM",
        "arrival_date": "11 Feb",
        "duration": "05h 50m",
        "final_price": "346",
        "rating": "2.9",
        "seats_available": "14",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      },
      {
        "bus_name": "NueGo",
        "bus_type": "AC Seater 2+2 Electric",
        "departure_time": "11:00 PM",
        "departure_date": "10 Feb",
        "arrival_time": "04:35 AM",
        "arrival_date": "11 Feb",
        "duration": "05h 35m",
        "final_price": "346",
        "rating": "3.6",
        "seats_available": "20",
        "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
      }
    ];

    // Loop through the list and add a BusCard message for each entry.
    for (var busData in busDataList) {
      final busCard = createBusCard(
        busName: busData["bus_name"],
        busType: busData["bus_type"],
        departureTime: busData["departure_time"],
        departureDate: busData["departure_date"],
        arrivalTime: busData["arrival_time"],
        arrivalDate: busData["arrival_date"],
        duration: busData["duration"],
        finalPrice: busData["final_price"],
        rating: busData["rating"],
        seatsAvailable: busData["seats_available"],
        url: busData["url"],
      );

      messages.add({
        "type": "bus",
        "data": busCard,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assistant",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg["text"],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ).animate().fade(duration: 500.ms).slideY(),
                  );
                } else if (msg["type"] == "bus") {
                  final busCard = msg["data"] as BusCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: busCard,
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
                  child: Icon(Icons.send, color: Colors.white)
                      .animate()
                      .scale(duration: 200.ms),
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
  final String busName;
  final String busType;
  final String departureTime;
  final String departureDate;
  final String arrivalTime;
  final String arrivalDate;
  final String duration;
  final String finalPrice;
  final String rating;
  final String seatsAvailable;
  final String url;

  const BusCard({
    super.key,
    required this.busName,
    required this.busType,
    required this.departureTime,
    required this.departureDate,
    required this.arrivalTime,
    required this.arrivalDate,
    required this.duration,
    required this.finalPrice,
    required this.rating,
    required this.seatsAvailable,
    required this.url,
  });

  void _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: Card(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus name and type.
              Text(
                busName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                busType,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 10),
              // Departure and Arrival information.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Departure",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "$departureTime, $departureDate",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Arrival",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "$arrivalTime, $arrivalDate",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Duration, rating, seats available, and price.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Duration: $duration",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Rating: $rating",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seats: $seatsAvailable",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Price: \$$finalPrice",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fade(duration: 500.ms).slideY(),
    );
  }
}
