// lib/main.dart
// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;

import 'card/airbnb_card.dart';
import 'card/airplane_card.dart';
import 'card/amazon_card.dart';
import 'card/booking_dot_com_card.dart';
import 'card/bus_card.dart';
import 'card/fashion_shopping.dart';
import 'card/movies_list.dart';
import 'card/movies_timing.dart';
import 'card/perplexity_card.dart';
import 'card/restaurant_card.dart';
import 'card/uber_card.dart';

/// Global conversation history.
/// Every message (text or card data) is stored as:
/// {
///    "role": "user" or "assistant",
///    "content": "<a single string>"
/// }
List<Map<String, dynamic>> conversationMessages = [];

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
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

  // Local UI messages list. Each message is either a text message or a card widget.
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false; // Indicates whether a message is being processed.
  http.Client? _client; // HTTP client for making/canceling requests.

  /// Sends the entire conversation history (as JSON) to the backend HTTPS endpoint.
  Future<String> sendString(String message) async {
    // Replace the URL below with your backend HTTPS endpoint.
    final url = Uri.parse('https://stirred-bream-largely.ngrok-free.app');
    _client = http.Client();

    // Send the full conversation history as JSON.
    final body = jsonEncode(conversationMessages);

    try {
      final response = await _client!
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      _client?.close();
      _client = null;

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('Error: $e');
      return 'Error: $e';
    }
  }

  /// Cancels the current message processing.
  void _cancelMessage() {
    _client?.close();
    _client = null;
    setState(() {
      _isLoading = false;
      // Remove the loading indicator message if present.
      if (messages.isNotEmpty && messages.last["type"] == "loading") {
        messages.removeLast();
      }
      // Also remove the last user message that initiated the request.
      if (messages.isNotEmpty && messages.last["sender"] == "user") {
        messages.removeLast();
      }
    });
  }

  /// Called when the send (or stop) button is pressed.
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;
    final inputText = _controller.text.trim();

    // Process clear command immediately.
    if (inputText == "clear()") {
      setState(() {
        messages.clear();
      });
      conversationMessages.clear();
      _controller.clear();
      return;
    }

    // Add the user message to the UI and to the global conversation.
    setState(() {
      _isLoading = true;
      messages.add({
        "type": "text",
        "text": inputText,
        "sender": "user",
      });
    });
    conversationMessages.add({
      "role": "user",
      "content": inputText,
    });

    // Add a loading indicator message.
    final int loadingMessageIndex = messages.length;
    setState(() {
      messages.add({
        "type": "loading",
        "sender": "bot",
      });
    });

    // Send the entire conversation to the backend.
    String response = await sendString(inputText);

    // If the request was canceled, exit early.
    if (!_isLoading) {
      return;
    }

    // Remove the loading indicator.
    setState(() {
      messages.removeAt(loadingMessageIndex);
    });

    // Process the server response.
    setState(() {
      if (response.startsWith("Error: ")) {
        messages.add({
          "type": "text",
          "text": response,
          "sender": "system",
        });
        conversationMessages.add({
          "role": "assistant",
          "content": response,
        });
      } else {
        // If the input starts with a command to show cards, add the corresponding card messages.
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
        } else if (inputText.startsWith("perplexity")) {
          addPerplexityCardsToMessages();
        } else if (inputText.startsWith("uber")) {
          addUberCardsToMessages();
        } else {
          // For a normal text response, add it.
          messages.add({
            "type": "text",
            "text": response,
            "sender": "bot",
          });
          conversationMessages.add({
            "role": "assistant",
            "content": response,
          });
        }
        _isLoading = false;
      }
    });

    _controller.clear();
    _focusNode.requestFocus();

    // Scroll to the bottom.
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

  /// ===========================
  /// CARD ADDITION FUNCTIONS
  /// ===========================

  /// Adds Uber card messages.
  void addUberCardsToMessages() {
    // Raw data for Uber card.
    final List<Map<String, dynamic>> uberDataList = [
      {
        'type': 'Uber',
        'url':
            'https://m.uber.com/go/product-selection?drop%5B0%5D=%7B%22addressLine1%22%3A%22Marine%20Drive%22%2C%22addressLine2%22%3A%22Kochi%2C%20Kerala%22%2C%22id%22%3A%22ChIJrYrKf1MNCDsR6gNsW6zTGHc%22%2C%22source%22%3A%22SEARCH%22%2C%22latitude%22%3A9.9771685%2C%22longitude%22%3A76.2773228%7D&effect=&pickup=%7B%22addressLine1%22%3A%22Siddhi%20Vinayak%20Industry%22%2C%22addressLine2%22%3A%229WFH%2B9VV%2C%20Verna%20Industrial%20Estate%2C%20Kesarvale%2C%20Goa%22%2C%22id%22%3A%22ChIJJzsQfFa3vzsRDFuFEkXAzp8%22%2C%22source%22%3A%22SEARCH%22%2C%22latitude%22%3A15.3734797%2C%22longitude%22%3A73.9296825%2C%22provider%22%3A%22google_places%22%7D',
        'pickup': {
          'name': 'Siddhi Vinayak Industry',
          'address': '9WFH+9VV, Verna Industrial Estate, Kesarvale, Goa',
          'latitude': 15.3734797,
          'longitude': 73.9296825,
        },
        'dropoff': {
          'name': 'Marine Drive',
          'address': 'Kochi, Kerala',
          'latitude': 9.9771685,
          'longitude': 76.2773228,
        },
      }
    ];
    List<UberCard> uberCards = getUberCards();
    for (int i = 0; i < uberCards.length; i++) {
      messages.add({
        "type": "uber",
        "data": uberCards[i],
        "sender": "bot",
      });
      final data =
          (i < uberDataList.length) ? uberDataList[i] : uberDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Bus card messages.
  void addBusCardsToMessages() {
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
    List<BusCard> busCards = getBusCards();
    for (int i = 0; i < busCards.length; i++) {
      messages.add({
        "type": "bus",
        "data": busCards[i],
        "sender": "bot",
      });
      final data = (i < busDataList.length) ? busDataList[i] : busDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Airplane card messages.
  void addAirplaneCardsToMessages() {
    final List<Map<String, dynamic>> airplaneDataList = [
      {
        "airline": "Airline Name",
        "flight_number": "123",
        "departure_time": "10:00 AM",
        "arrival_time": "12:00 PM",
        "duration": "2h",
        "price": "5000",
        "url": "https://example.com/airplane/123"
      }
    ];
    List<AirplaneCard> airplaneCards = getAirplaneCards();
    for (int i = 0; i < airplaneCards.length; i++) {
      messages.add({
        "type": "airplane",
        "data": airplaneCards[i],
        "sender": "bot",
      });
      final data = (i < airplaneDataList.length)
          ? airplaneDataList[i]
          : airplaneDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Amazon card messages.
  void addAmazonCardsToMessages() {
    final List<Map<String, dynamic>> amazonDataList = [
      {
        "product": "Sample Product",
        "price": "₹999",
        "rating": "4.5",
        "url": "https://amazon.in/sample-product"
      }
    ];
    List<AmazonCard> amazonCards = getAmazonCards();
    for (int i = 0; i < amazonCards.length; i++) {
      messages.add({
        "type": "amazon",
        "data": amazonCards[i],
        "sender": "bot",
      });
      final data =
          (i < amazonDataList.length) ? amazonDataList[i] : amazonDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Airbnb card messages.
  void addAirbnbCardsToMessages() {
    final List<Map<String, dynamic>> airbnbDataList = [
      {
        "listing": "Cozy Apartment",
        "price_per_night": "₹2500",
        "rating": "4.8",
        "url": "https://airbnb.in/listing/cozy-apartment"
      }
    ];
    List<AirbnbCard> airbnbCards = getAirbnbCards();
    for (int i = 0; i < airbnbCards.length; i++) {
      messages.add({
        "type": "airbnb",
        "data": airbnbCards[i],
        "sender": "bot",
      });
      final data =
          (i < airbnbDataList.length) ? airbnbDataList[i] : airbnbDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Booking.com card messages.
  void addBookingCardsToMessages() {
    final List<Map<String, dynamic>> bookingDataList = [
      {
        "hotel": "Hotel Example",
        "price": "₹3500",
        "rating": "4.2",
        "url": "https://booking.com/hotel/example"
      }
    ];
    List<BookingCard> bookingCards = getBookingCards();
    for (int i = 0; i < bookingCards.length; i++) {
      messages.add({
        "type": "booking",
        "data": bookingCards[i],
        "sender": "bot",
      });
      final data = (i < bookingDataList.length)
          ? bookingDataList[i]
          : bookingDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Restaurant card messages.
  void addRestaurantCardsToMessages() {
    final List<Map<String, dynamic>> restaurantDataList = [
      {
        "restaurant": "The Food Place",
        "cuisine": "Italian",
        "rating": "4.7",
        "url": "https://restaurant.example.com/thefoodplace"
      }
    ];
    List<RestaurantCard> restaurantCards = getRestaurantCards();
    for (int i = 0; i < restaurantCards.length; i++) {
      messages.add({
        "type": "restaurant",
        "data": restaurantCards[i],
        "sender": "bot",
      });
      final data = (i < restaurantDataList.length)
          ? restaurantDataList[i]
          : restaurantDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Fashion Shopping card messages.
  void addFashionShoppingCardsToMessages() {
    final List<Map<String, dynamic>> fashionDataList = [
      {
        "brand": "Fashion Brand",
        "item": "Stylish Jacket",
        "price": "₹2999",
        "url": "https://fashion.example.com/stylish-jacket"
      }
    ];
    List<FashionShopping> fashionCards = getFashionCards();
    for (int i = 0; i < fashionCards.length; i++) {
      messages.add({
        "type": "fashion",
        "data": fashionCards[i],
        "sender": "bot",
      });
      final data = (i < fashionDataList.length)
          ? fashionDataList[i]
          : fashionDataList[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Movies List card messages.
  void addMoviesListCardsToMessages() {
    final List<Map<String, dynamic>> moviesListData = [
      {
        "movies": ["Movie 1", "Movie 2", "Movie 3"],
        "url": "https://movies.example.com/list"
      }
    ];
    List<MovieList> moviesCards = getMoviesListCards();
    for (int i = 0; i < moviesCards.length; i++) {
      messages.add({
        "type": "movieslist",
        "data": moviesCards[i],
        "sender": "bot",
      });
      final data =
          (i < moviesListData.length) ? moviesListData[i] : moviesListData[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Movies Timing card messages.
  void addMovieTimeingCardToMessages() {
    final List<Map<String, dynamic>> moviesTimingData = [
      {
        "movie": "Example Movie",
        "showtimes": ["1:00 PM", "4:00 PM", "7:00 PM"],
        "url": "https://movies.example.com/timing"
      }
    ];
    List<MoviesTimingCard> moviesTimingCards = getMoviesTimingCards();
    for (int i = 0; i < moviesTimingCards.length; i++) {
      messages.add({
        "type": "mtime",
        "data": moviesTimingCards[i],
        "sender": "bot",
      });
      final data = (i < moviesTimingData.length)
          ? moviesTimingData[i]
          : moviesTimingData[0];
      conversationMessages.add({
        "role": "assistant",
        "content": jsonEncode(data),
      });
    }
  }

  /// Adds Perplexity card messages.
  void addPerplexityCardsToMessages() {
    final List<Map<String, dynamic>> perplexityData = [
      {
        "query": "Example query",
        "answer": "Example answer from Perplexity.",
        "url": "https://perplexity.ai/example"
      }
    ];
    List<PerplexityCard> perplexityCards = getPerplexityCards();
    for (int i = 0; i < perplexityCards.length; i++) {
      messages.add({
        "type": "perplexity",
        "data": perplexityCards[i],
        "sender": "bot",
      });
      final data =
          (i < perplexityData.length) ? perplexityData[i] : perplexityData[0];
      conversationMessages.add({
        "role": "assistant",
        "content": (data).toString(),
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;

    /// Helper to wrap a message widget with an icon.
    Widget buildMessageWithIcon(Widget messageWidget, int index, bool isUser) {
      bool showIcon = true;
      if (index > 0) {
        final prevMsg = messages[index - 1];
        if (prevMsg["sender"] == messages[index]["sender"]) {
          showIcon = false;
        }
      }

      const double iconAreaWidth = 40.0;
      const double spacing = 8.0;
      Widget iconWidget;
      if (showIcon) {
        if (isUser) {
          iconWidget = Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_rounded,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          );
        } else {
          iconWidget = Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
              ),
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        iconWidget = const SizedBox(width: iconAreaWidth);
      }

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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ).animate().fade(duration: 300.ms).slideX(
                        begin: isUser ? 1 : -1,
                      );
                  return buildMessageWithIcon(bubble, index, isUser);
                } else if (msg["type"] == "loading") {
                  final bubble = ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fade(duration: 300.ms).slideX(
                        begin: isUser ? 1 : -1,
                      );
                  return buildMessageWithIcon(bubble, index, isUser);
                }
                // Card messages.
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
                  final moviesList = msg["data"] as MovieList;
                  return buildMessageWithIcon(moviesList, index, isUser);
                } else if (msg["type"] == "mtime") {
                  final movieTimes = msg["data"] as MoviesTimingCard;
                  return buildMessageWithIcon(movieTimes, index, isUser);
                } else if (msg["type"] == "perplexity") {
                  final perplexity = msg["data"] as PerplexityCard;
                  return buildMessageWithIcon(perplexity, index, isUser);
                } else if (msg["type"] == "uber") {
                  final uberCard = msg["data"] as UberCard;
                  return buildMessageWithIcon(uberCard, index, isUser);
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
                  child: Opacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (value) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: "Ask something...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: _isLoading ? Colors.grey : Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  backgroundColor: _isLoading ? Colors.red : Colors.blueAccent,
                  onPressed: _isLoading ? _cancelMessage : _sendMessage,
                  child: Icon(
                    _isLoading ? Icons.stop : Icons.send,
                    color: Colors.white,
                  ).animate().scale(duration: 200.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
