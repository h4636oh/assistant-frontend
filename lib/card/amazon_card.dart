import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingCard extends StatelessWidget {
  final String imageUrl;
  final String productUrl;
  final String title;
  final String numberOfBuyers;
  final String rating;
  final String reviewCount;
  final double price;
  final String? amazonChoice;

  const ListingCard({
    super.key,
    required this.imageUrl,
    required this.productUrl,
    required this.title,
    required this.numberOfBuyers,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.amazonChoice,
  });

  void _launchURL() async {
    try {
      if (await canLaunchUrl(Uri.parse(productUrl))) {
        await launchUrl(Uri.parse(productUrl));
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
                // Wrap the image in a Container with the same background color
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Match the card's background color
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          16.0), // Match the card's top border radius
                    ),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain, // Keep the image size unchanged
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    numberOfBuyers,
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
                            '$rating ($reviewCount reviews)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
            if (amazonChoice != null && amazonChoice!.isNotEmpty)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(80, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    amazonChoice!,
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
              imageUrl:
                  "https://m.media-amazon.com/images/I/81fvJauBWDL._AC_UY218_.jpg",
              productUrl: "https://www.amazon.in/s?k=laptop#",
              title:
                  "Lenovo IdeaPad Slim 3 12th Gen Intel Core i5-12450H 14\" (35.5cm) FHD 250 Nits Thin & Light Laptop...",
              numberOfBuyers: "200+ bought in past month",
              rating: "3.9",
              reviewCount: "454",
              price: 50061,
              amazonChoice: 'Best seller',
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
