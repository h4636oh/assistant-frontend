import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingCard extends StatelessWidget {
  final String imageUrl;
  final String paymentUrl;
  final String hotelName;
  final String location;
  final String ratingReviews;
  final double totalPrice;
  final String tagText; // Tag text variable

  const ListingCard({
    super.key,
    required this.imageUrl,
    required this.paymentUrl,
    required this.hotelName,
    required this.location,
    required this.ratingReviews,
    required this.totalPrice,
    required this.tagText, // Accepting tag text from constructor
  });

  void _launchURL() async {
    try {
      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
        await launchUrl(Uri.parse(paymentUrl));
      }
    } catch (e) {
      // Handle the error silently or log it if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    hotelName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    location,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 18),
                          SizedBox(width: 4),
                          Text(
                            ratingReviews,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(0)} total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
            // Tag positioned at the top-left corner
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color.fromARGB(80, 0, 0, 0), // Fix for the deprecation warning
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tagText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(title: Text('Listing Card')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListingCard(
              imageUrl: "https://a0.muscache.com/im/pictures/hosting/Hosting-1252006468109509167/original/05652ca2-5d6c-4cac-b3ce-33b672e1c36e.jpeg?im_w=720&im_format=avif",
              paymentUrl: "https://www.airbnb.co.in/rooms/1252006468109509167",
              hotelName: 'Apartment in Siolim',
              location: 'Elements Studio GOA',
              ratingReviews: '4.96 (84 reviews)',
              totalPrice: 9898,
              tagText: 'Guest Favourite', // Customizable tag text
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
