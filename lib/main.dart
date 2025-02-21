// lib/main.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

// New imports for compression and file handling.
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'card/bus_card.dart';
import 'card/airplane_card.dart';
import 'card/airbnb_card.dart';
import 'card/amazon_card.dart';
import 'card/booking_dot_com_card.dart';
import 'card/restaurant_card.dart';
import 'card/fashion_shopping.dart';
import 'card/movies_list.dart';
import 'card/movies_timing.dart';
import 'card/perplexity_card.dart';
import 'card/uber_card.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ChatApp());
}

List<Map<String, String>> history = [];

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.purpleAccent,
        colorScheme: const ColorScheme.dark(primary: Colors.purpleAccent),
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
  bool _isLoading = false; // Indicates whether a message is being processed.
  http.Client? _client; // HTTP client for making/canceling requests.

  /// Sends the message to the server and waits for the reply.
  Future<dynamic> sendString(String message) async {
    // final url = Uri.parse('http://localhost:3000'); // Localhost
    // final url = Uri.parse('https://stirred-bream-largely.ngrok-free.app'); // Deepanshu
    // final url = Uri.parse('https://mighty-sailfish-touched.ngrok-free.app'); // Kabir
    final url = Uri.parse('https://just-mainly-monster.ngrok-free.app'); // Siddhanth

    _client = http.Client();
    try {
      final response = await _client!
          .post(
        url,
        // headers: {"Content-Type": "application/json"},
        // body: jsonEncode({"message": message, "history": history}),
        headers: {'Content-Type': 'text/plain'},
        // headers: {'Content-Type': 'text/plain', 'Accept': 'application/json'},
        body: history.toString(),
      )
          .timeout(
        const Duration(seconds: 60), // Timeout to prevent infinite waiting
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      _client?.close();
      _client = null;

      if (response.statusCode == 200) {
        debugPrint(response.body.toString());
        return jsonDecode(response.body);
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      // debugPrint('Error: $e');
      return 'Error: $e';
    }
  }

  /// Cancels the current message processing.
  void _cancelMessage() {
    // Cancel the HTTP request if still in progress.
    _client?.close();
    _client = null;
    setState(() {
      _isLoading = false;
      // Remove the loading indicator message if it exists.
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
      _controller.clear();
      return;
    }

    // Add the user message and disable further input.
    setState(() {
      _isLoading = true;
      messages.add({
        "type": "text",
        "text": inputText,
        "sender": "user",
      });
      history.add({"role": "user", "content": inputText});
    });

    // Add a loading indicator message.
    final int loadingMessageIndex = messages.length;
    setState(() {
      messages.add({
        "type": "loading",
        "sender": "bot",
      });
    });

    // Wait until the HTTP request completes.
    final response = await sendString(inputText);
    history.add({"role": "assistant", "content": response.toString()});

    List<Map<String, String>> quoteKeysAndValues(dynamic response) {
      // First, ensure that response is a List<dynamic>
      final List<dynamic> list = response as List<dynamic>;

      // Now, convert each element to Map<String, String>
      final List<Map<String, String>> quotedMaps = list.map((item) {
        final Map<String, dynamic> map = item as Map<String, dynamic>;
        return map
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }).toList();

      // Return the JSON-encoded string.
      return quotedMaps;
    }

    List<Map<String, String>> responseData = [];
    if (response is Map && response.containsKey ("data")) {
      if (response["data"] is List) {
        responseData = quoteKeysAndValues(response["data"]);
      } else if (response["data"] is Map) {
        responseData = quoteKeysAndValues([response["data"]]);
      }
    }

    // If the request was canceled, _isLoading would be false.
    if (!_isLoading) {
      return;
    }

    // Remove the loading indicator message.
    setState(() {
      messages.removeAt(loadingMessageIndex);
    });

    // Process the server response.
    setState(() {
      if (response is Map && response.containsKey("type")) {
        List<Map<String, String>> formattedData = [];

        if (response["data"] is List) {
          formattedData = (response["data"] as List)
              .whereType<Map<String, dynamic>>() // Ensure each item is a map
              .map((item) => item.map((key, value) => MapEntry(key.toString(), value.toString())))
              .toList();
        }

        switch (response["type"]) {
          case "bus":
            addBusCardsToMessages(responseData);
            break;
          case "airplane":
            addAirplaneCardsToMessages(responseData);
            break;
          case "amazon":
            addAmazonCardsToMessages(responseData);
            break;
          case "airbnb":
            addAirbnbCardsToMessages(responseData);
            break;
          case "booking":
            addBookingCardsToMessages(responseData);
            break;
          case "restaurant":
            addRestaurantCardsToMessages(responseData);
            break;
          case "fashion":
            addFashionShoppingCardsToMessages(responseData);
            break;
          case "movietime":
            addMovieTimeingCardToMessages(responseData);
            break;
          case "movieslist":
            addMoviesListCardsToMessages(responseData);
            break;
          case "perplexity":
            addPerplexityCardsToMessages(responseData);
            break;
          case "uber":
            addUberCardsToMessages(responseData);
            break;
          default:
            // FIX: Extract "data" from the response map if available.
            messages.add({
              "type": "text",
              "text": response.containsKey("data")
                  ? response["data"]
                  : response.toString(),
              "sender": "bot",
            });
        }
      } else {
        messages.add({
          "type": "text",
          "text": response.toString(),
          "sender": "bot",
        });
      }
      _isLoading = false;
    });

    _controller.clear();
    _focusNode.requestFocus();

    // Scroll to bottom after frame updates.
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

  /// Updated image upload function that compresses, encodes to Base64, and sends the image.
  Future<void> _sendImageToServer(XFile imageFile) async {
    File file = File(imageFile.path);

    // Compress the image.
    final tempDir = await getTemporaryDirectory();
    final targetPath = path.join(
      tempDir.absolute.path,
      "temp_${DateTime.now().millisecondsSinceEpoch}.jpg",
    );
    XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );
    if (compressedFile == null) {
      setState(() {
        messages.add({
          "type": "text",
          "text": "Failed to compress image.",
          "sender": "bot",
        });
      });
      return;
    }

    // Encode the compressed image to Base64.
    final bytes = await compressedFile.readAsBytes();
    String base64Image = base64Encode(bytes);
    String fileName = path.basename(compressedFile.path);

    // Prepare JSON payload.
    final body = jsonEncode({
      "image": base64Image,
      "name": fileName,
    });

    // Replace with your backend URL.
    var url = Uri.parse('https://just-mainly-monster.ngrok-free.app/');
    // final url = Uri.parse('https://stirred-bream-largely.ngrok-free.app'); // Deepanshu

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        setState(() {
          messages.add({
            "type": "text",
            "text": "Image uploaded successfully!",
            "sender": "bot",
          });
        });
      } else {
        setState(() {
          messages.add({
            "type": "text",
            "text":
                "Failed to upload image. Status: ${response.statusCode}",
            "sender": "bot",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "type": "text",
          "text": "Error during image upload: $e",
          "sender": "bot",
        });
      });
    }
  }

  /// Picks an image and sends it to the server.
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _isLoading = true;
        messages.add({
          "type": "image",
          "imagePath": image.path,
          "sender": "user",
        });
        history.add({"role": "user", "content": "[Image Sent]"});
      });

      await _sendImageToServer(image);
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Adds Uber card messages.
  void addUberCardsToMessages(List<Map<String, String>> response) {
    List<UberCard> uberCards = getUberCards(response);
    for (var uberCard in uberCards) {
      messages.add({
        "type": "uber",
        "data": uberCard,
        "sender": "bot",
      });
    }
  }

  /// Adds Movie Timings card messages.
  void addMovieTimeingCardToMessages(List<Map<String, String>> response) {
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
  void addBusCardsToMessages(List<Map<String, String>> response) {
    List<BusCard> busCards = getBusCards(response);
    for (var busCard in busCards) {
      messages.add({
        "type": "bus",
        "data": busCard,
        "sender": "bot",
      });
    }
  }

  /// Adds airplane card messages.
  void addAirplaneCardsToMessages(List<Map<String, String>> response) {
    List<AirplaneCard> airplaneCards = getAirplaneCards(response);
    for (var airplaneCard in airplaneCards) {
      messages.add({
        "type": "airplane",
        "data": airplaneCard,
        "sender": "bot",
      });
    }
  }

  /// Adds amazon card messages.
  void addAmazonCardsToMessages(List<Map<String, String>> response) {
    List<AmazonCard> amazonCards = getAmazonCards(response);
    for (var amazonCard in amazonCards) {
      messages.add({
        "type": "amazon",
        "data": amazonCard,
        "sender": "bot",
      });
    }
  }

  /// Adds airbnb card messages.
  void addAirbnbCardsToMessages(List<Map<String, String>> response) {
    List<AirbnbCard> airbnbCards = getAirbnbCards(response);
    for (var airbnbCard in airbnbCards) {
      messages.add({
        "type": "airbnb",
        "data": airbnbCard,
        "sender": "bot",
      });
    }
  }

  /// Adds booking dot com card messages.
  void addBookingCardsToMessages(List<Map<String, String>> response) {
    List<BookingCard> bookingCards = getBookingCards(response);
    for (var bookingCard in bookingCards) {
      messages.add({
        "type": "booking",
        "data": bookingCard,
        "sender": "bot",
      });
    }
  }

  /// Adds restaurant card messages.
  void addRestaurantCardsToMessages(List<Map<String, String>> response) {
    List<RestaurantCard> restaurantCards = getRestaurantCards(response);
    for (var restaurantCard in restaurantCards) {
      messages.add({
        "type": "restaurant",
        "data": restaurantCard,
        "sender": "bot",
      });
    }
  }

  /// Adds fashion shopping card messages.
  void addFashionShoppingCardsToMessages(List<Map<String, String>> response) {
    List<FashionShopping> fashionCards = getFashionCards(response);
    for (var fashionCard in fashionCards) {
      messages.add({
        "type": "fashion",
        "data": fashionCard,
        "sender": "bot",
      });
    }
  }

  /// Adds movies list card messages.
  void addMoviesListCardsToMessages(List<Map<String, String>> response) {
    List<MovieList> moviesCards = getMoviesListCards();
    for (var moviesCard in moviesCards) {
      messages.add({
        "type": "movieslist",
        "data": moviesCard,
        "sender": "bot",
      });
    }
  }

  /// Adds perplexity card messages.
  void addPerplexityCardsToMessages(List<Map<String, String>> response) {
    List<PerplexityCard> perplexityCards = getPerplexityCards(response);
    for (var perplexityCard in perplexityCards) {
      messages.add({
        "type": "perplexity",
        "data": perplexityCard,
        "sender": "bot",
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent,
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
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "nasa",
              color: Colors.purpleAccent,
              letterSpacing: 5,
              fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: const Icon(
            Icons.replay_rounded,
            color: Colors.grey),
          iconSize: 32,
          onPressed: () {
            setState(() {
              messages.clear();
              history.clear();
            });
          },
        ),
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

                switch (msg["type"]) {
                  case "text":
                    final bubble = ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.purpleAccent : Colors.grey[800],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg["text"].toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ).animate().fade(duration: 300.ms).slideX(
                          begin: isUser ? 1 : -1,
                        );
                    return buildMessageWithIcon(bubble, index, isUser);
                  case "image":
                    final imageWidget = ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxBubbleWidth,
                        maxHeight: 250,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(msg["imagePath"]),
                            fit: BoxFit.cover),
                      ),
                    );
                    return buildMessageWithIcon(imageWidget, index, isUser);
                  case "loading":
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
                  case "bus":
                    final busCard = msg["data"] as BusCard;
                    return buildMessageWithIcon(busCard, index, isUser);
                  case "airplane":
                    final airplaneCard = msg["data"] as AirplaneCard;
                    return buildMessageWithIcon(airplaneCard, index, isUser);
                  case "amazon":
                    final amazonCard = msg["data"] as AmazonCard;
                    return buildMessageWithIcon(amazonCard, index, isUser);
                  case "airbnb":
                    final airbnbCard = msg["data"] as AirbnbCard;
                    return buildMessageWithIcon(airbnbCard, index, isUser);
                  case "booking":
                    final bookingCard = msg["data"] as BookingCard;
                    return buildMessageWithIcon(bookingCard, index, isUser);
                  case "restaurant":
                    final restaurantCard = msg["data"] as RestaurantCard;
                    return buildMessageWithIcon(restaurantCard, index, isUser);
                  case "fashion":
                    final fashionCard = msg["data"] as FashionShopping;
                    return buildMessageWithIcon(fashionCard, index, isUser);
                  case "movieslist":
                    final movieslist = msg["data"] as MovieList;
                    return buildMessageWithIcon(movieslist, index, isUser);
                  case "mtime":
                    final movietimes = msg["data"] as MoviesTimingCard;
                    return buildMessageWithIcon(movietimes, index, isUser);
                  case "perplexity":
                    final perplexity = msg["data"] as PerplexityCard;
                    return buildMessageWithIcon(perplexity, index, isUser);
                  case "uber":
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
              crossAxisAlignment: CrossAxisAlignment
                  .end, // Align items in the center vertically
              children: [
                // FloatingActionButton wrapped in a SizedBox
                SizedBox(
                  height: 56, // Match default FAB height
                  width: 56, // Match default FAB width
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[900],
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Icon(Icons.photo, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                // TextField wrapped in SizedBox
                Expanded(
                  child: Flexible(
                  // child: SizedBox(
                    // height:
                    //     56, // Match FloatingActionButton's default height (56)
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (value) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                      maxLines: null, // Allow multiline expansion
                      decoration: InputDecoration(
                        hintText: "Ask something...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: _isLoading ? Colors.grey : Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, // Adjust padding for better alignment
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Space between TextField and button
                // FloatingActionButton wrapped in a SizedBox
                SizedBox(
                  height: 56, // Match default FAB height
                  width: 56, // Match default FAB width
                  child: FloatingActionButton(
                    backgroundColor:
                        _isLoading ? Colors.red : Colors.purpleAccent,
                    onPressed: _isLoading ? _cancelMessage : _sendMessage,
                    child: Icon(
                      _isLoading ? Icons.stop : Icons.send,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
