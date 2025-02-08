// lib/main.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'card/bus_card.dart';
import 'card/airplane_card.dart';
import 'card/airbnb_card.dart';
import 'card/amazon_card.dart';
import 'card/booking_dot_com_card.dart';
import 'card/restaurant_card.dart';
import 'card/fashion_shopping.dart';
import 'card/movies_list.dart';

void main() {
  runApp(const ChatApp());
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
        colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
      ),
      home: const ChatScreen(),
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
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];

  /// Called when the send button is pressed or Enter is hit.
  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      // Add the user message.
      messages.add({
        "type": "text",
        "text": _controller.text,
        "sender": "user",
      });

      // Add cards based on the input.
      if (_controller.text.startsWith("bus")) {
        addBusCardsToMessages();
      } else if (_controller.text.startsWith("airplane")) {
        addAirplaneCardsToMessages();
      } else if (_controller.text.startsWith("amazon")) {
        addAmazonCardsToMessages();
      } else if (_controller.text.startsWith("airbnb")) {
        addAirbnbCardsToMessages();
      } else if (_controller.text.startsWith("booking")) {
        addBookingCardsToMessages();
      } else if (_controller.text.startsWith("restaurant")) {
        addRestaurantCardsToMessages();
      } else if (_controller.text.startsWith("fashion")) {
        addFashionShoppingCardsToMessages();
      } else if (_controller.text.startsWith("movieslist")) {
        addMoviesListCardsToMessages();
      } else {
        messages.add({
          "type": "text",
          "text": "This is a placeholder response.",
          "sender": "bot",
        });
      }
    });
    _controller.clear();
    _focusNode.requestFocus();

    // Scroll to bottom after the frame updates.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Adds bus card messages.
  void addBusCardsToMessages() {
    List<BusCard> busCards = getBusCards();
    for (var busCard in busCards) {
      messages.add({
        "type": "bus",
        "data": busCard,
      });
    }
  }

  /// Adds airplane card messages.
  void addAirplaneCardsToMessages() {
    List<AirplaneCard> airplaneCards = getAirplaneCards();
    for (var airplaneCard in airplaneCards) {
      messages.add({
        "type": "airplane",
        "data": airplaneCard,
      });
    }
  }

  /// Adds amazon card messages.
  void addAmazonCardsToMessages() {
    List<AmazonCard> amazonCards = getAmazonCards();
    for (var amazonCard in amazonCards) {
      messages.add({
        "type": "amazon",
        "data": amazonCard,
      });
    }
  }

  /// Adds airbnb card messages.
  void addAirbnbCardsToMessages() {
    List<AirbnbCard> airbnbCards = getAirbnbCards();
    for (var airbnbCard in airbnbCards) {
      messages.add({
        "type": "airbnb",
        "data": airbnbCard,
      });
    }
  }

  /// Adds booking dot com card messages.
  void addBookingCardsToMessages() {
    List<BookingCard> bookingCards = getBookingCards();
    for (var bookingCard in bookingCards) {
      messages.add({
        "type": "booking",
        "data": bookingCard,
      });
    }
  }

  /// Adds restaurant card messages.
  void addRestaurantCardsToMessages() {
    List<RestaurantCard> restaurantCards = getRestaurantCards();
    for (var restaurantCard in restaurantCards) {
      messages.add({
        "type": "restaurant",
        "data": restaurantCard,
      });
    }
  }

  /// Adds fashion shopping card messages.
  void addFashionShoppingCardsToMessages() {
    List<FashionShopping> fashionCards = getFashionCards();
    for (var fashionCard in fashionCards) {
      messages.add({
        "type": "fashion",
        "data": fashionCard,
      });
    }
  }

  /// Adds movies list card messages.
  void addMoviesListCardsToMessages() {
    List<MovieList> moviesCards = getMoviesListCards();
    for (var moviesCard in moviesCards) {
      messages.add({
        "type": "movieslist",
        "data": moviesCard,
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ATHENA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: const Icon(Icons.chat_bubble, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the scroll controller.
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                if (msg["type"] == "text") {
                  bool isUser = msg["sender"] == "user";
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg["text"],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ).animate().fade(duration: 500.ms).slideY(),
                  );
                } else if (msg["type"] == "bus") {
                  final busCard = msg["data"] as BusCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: busCard,
                  );
                } else if (msg["type"] == "airplane") {
                  final airplaneCard = msg["data"] as AirplaneCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: airplaneCard,
                  );
                } else if (msg["type"] == "amazon") {
                  final amazonCard = msg["data"] as AmazonCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: amazonCard,
                  );
                } else if (msg["type"] == "airbnb") {
                  final airbnbCard = msg["data"] as AirbnbCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: airbnbCard,
                  );
                } else if (msg["type"] == "booking") {
                  final bookingCard = msg["data"] as BookingCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: bookingCard,
                  );
                } else if (msg["type"] == "restaurant") {
                  final restaurantCard = msg["data"] as RestaurantCard;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: restaurantCard,
                  );
                } else if (msg["type"] == "fashion") {
                  final fashionCard = msg["data"] as FashionShopping;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: fashionCard,
                  );
                } else if (msg["type"] == "movieslist") {
                  final fashionCard = msg["data"] as MovieList;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: fashionCard,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) => _sendMessage(),
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
