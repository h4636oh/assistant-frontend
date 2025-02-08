// lib/main.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'card/bus_card.dart';
import 'card/airplane_card.dart';
import 'card/airbnb_card.dart';
import 'card/amazon_card.dart';
import 'card/booking_dot_com_card.dart';
import 'card/restaurant_card.dart';
import 'card/fashion_shopping.dart';
import 'card/movies_list.dart';
import 'card/movies_timing.dart';

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

  // Every message now includes a "sender" property.
  List<Map<String, dynamic>> messages = [];

  /// Sends the message to the server and waits for the reply.
  Future<void> sendString(String message) async {
    final url = Uri.parse(
        'https://stirred-bream-largely.ngrok-free.app'); // Replace with your URL
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "text/plain"},
        body: message,
      );
      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
      } else {
        debugPrint('Failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// Called when the send button is pressed or Enter is hit.
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final inputText = _controller.text.trim();

    // Process clear command immediately.
    if (inputText == "clear()") {
      setState(() {
        messages.clear();
      });
      _controller.clear();
      return;
    }

    // Wait until the HTTP request completes (i.e. wait for the reply).
    await sendString(inputText);

    setState(() {
      // Add the user message.
      messages.add({
        "type": "text",
        "text": inputText,
        "sender": "user",
      });

      // Add cards based on the input.
      if (inputText.startsWith("bus")) {
        addBusCardsToMessages();
      } else if (inputText.startsWith("airplane")) {
        addAirplaneCardsToMessages();
      } else if (inputText.startsWith("amazon")) {
        addAmazonCardsToMessages();
      } else if (inputText.startsWith("airbnb")) {
        addAirbnbCardsToMessages();
      } else if (inputText.startsWith("booking")) {
        addBookingCardsToMessages();
      } else if (inputText.startsWith("restaurant")) {
        addRestaurantCardsToMessages();
      } else if (inputText.startsWith("fashion")) {
        addFashionShoppingCardsToMessages();
      } else if (inputText.startsWith("mtime")) {
        addMovieTimeingCardToMessages();
      } else if (inputText.startsWith("movieslist")) {
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

  /// Adds Movie Timings card messages.
  void addMovieTimeingCardToMessages() {
    List<MoviesTimingCard> moviesTimingCards = getMoviesTimingCards();
    for (var moviesTimingCard in moviesTimingCards) {
      messages.add({
        "type": "mtime",
        "data": moviesTimingCard,
        "sender": "bot",
      });
    }
  }

  /// Adds bus card messages.
  void addBusCardsToMessages() {
    List<BusCard> busCards = getBusCards();
    for (var busCard in busCards) {
      messages.add({
        "type": "bus",
        "data": busCard,
        "sender": "bot",
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
        "sender": "bot",
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
        "sender": "bot",
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
        "sender": "bot",
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
        "sender": "bot",
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
        "sender": "bot",
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
        "sender": "bot",
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
        "sender": "bot",
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
    // Calculate a max width for message bubbles (e.g. 70% of screen width)
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;

    /// Helper function to wrap any message widget with an icon (or a reserved space)
    /// so that the horizontal spacing is uniform.
    Widget buildMessageWithIcon(Widget messageWidget, int index, bool isUser) {
      // Determine if this is the first message in a consecutive chain.
      bool showIcon = true;
      if (index > 0) {
        final prevMsg = messages[index - 1];
        if (prevMsg["sender"] == messages[index]["sender"]) {
          showIcon = false;
        }
      }

      // Set a fixed width for the icon area.
      const double iconAreaWidth = 40.0;
      const double spacing = 8.0;

      Widget iconWidget;
      if (showIcon) {
        if (isUser) {
          // For user messages: icon on the top right in blue.
          iconWidget = Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue, // Background color
              ),
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              child: Icon(
                Icons.person_rounded,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          );
        } else {
          // For bot messages: icon on the top left in grey.
          iconWidget = Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
              ),
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              child: Icon(
                Icons.smart_toy_rounded,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        // Reserve the same space with an invisible widget.
        iconWidget = const SizedBox(width: iconAreaWidth);
      }

      // Build a row that always reserves the icon area.
      if (isUser) {
        return Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: messageWidget),
              const SizedBox(width: spacing),
              SizedBox(width: iconAreaWidth, child: iconWidget),
            ],
          ),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: iconAreaWidth, child: iconWidget),
              const SizedBox(width: spacing),
              Flexible(child: messageWidget),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ATHENA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        // The leading property has been removed to eliminate the top left icon.
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final String sender = msg["sender"] ?? "bot";
                final bool isUser = sender == "user";

                // For text messages, build a styled bubble.
                if (msg["type"] == "text") {
                  final bubble = ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxBubbleWidth),
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
                    ),
                  ).animate().fade(duration: 300.ms).slideX(
                        begin: isUser ? 1 : -1,
                      );
                  return buildMessageWithIcon(bubble, index, isUser);
                }
                // For card messages, wrap the card widget similarly.
                else if (msg["type"] == "bus") {
                  final busCard = msg["data"] as BusCard;
                  return buildMessageWithIcon(busCard, index, isUser);
                } else if (msg["type"] == "airplane") {
                  final airplaneCard = msg["data"] as AirplaneCard;
                  return buildMessageWithIcon(airplaneCard, index, isUser);
                } else if (msg["type"] == "amazon") {
                  final amazonCard = msg["data"] as AmazonCard;
                  return buildMessageWithIcon(amazonCard, index, isUser);
                } else if (msg["type"] == "airbnb") {
                  final airbnbCard = msg["data"] as AirbnbCard;
                  return buildMessageWithIcon(airbnbCard, index, isUser);
                } else if (msg["type"] == "booking") {
                  final bookingCard = msg["data"] as BookingCard;
                  return buildMessageWithIcon(bookingCard, index, isUser);
                } else if (msg["type"] == "restaurant") {
                  final restaurantCard = msg["data"] as RestaurantCard;
                  return buildMessageWithIcon(restaurantCard, index, isUser);
                } else if (msg["type"] == "fashion") {
                  final fashionCard = msg["data"] as FashionShopping;
                  return buildMessageWithIcon(fashionCard, index, isUser);
                } else if (msg["type"] == "movieslist") {
                  final movieslist = msg["data"] as MovieList;
                  return buildMessageWithIcon(movieslist, index, isUser);
                } else if (msg["type"] == "mtime") {
                  final movietimes = msg["data"] as MoviesTimingCard;
                  return buildMessageWithIcon(movietimes, index, isUser);
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
