// lib/card/amazon_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AmazonCard extends StatelessWidget {
  final String imageUrl;
  final String productUrl;
  final String title;
  final String numberOfBuyers;
  final String rating;
  final String reviewCount;
  final double price;
  final String? amazonChoice;

  const AmazonCard({
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

  /// Launches the product URL in an external application.
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(productUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $productUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // On tap, show a confirmation dialog before launching the URL.
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                "Do you want to proceed to the product website?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        ).then((confirmed) {
          if (confirmed == true) {
            _launchUrl();
          }
        });
      },
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
                // The image container (UI remains unchanged)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Matches the card's background color
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain, // Keep the image size unchanged
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    numberOfBuyers,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.orange, size: 18),
                          SizedBox(width: 4),
                        ],
                      ),
                      Text(
                        '$rating ($reviewCount reviews)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            // Display amazonChoice badge if available (UI remains unchanged)
            if (amazonChoice != null && amazonChoice!.isNotEmpty)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(80, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    amazonChoice!,
                    style: const TextStyle(
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

List<AmazonCard> getAmazonCards() {
  final List<Map<String, dynamic>> amazonDataList = [
    {
      "image_url":
          "https://m.media-amazon.com/images/I/81fvJauBWDL._AC_UY218_.jpg",
      "product_url": "https://www.amazon.in/s?k=laptop#",
      "title":
          "Lenovo IdeaPad Slim 3 12th Gen Intel Core i5-12450H 14\" (35.5cm) FHD Thin & Light Laptop...",
      "number_of_buyers": "200+ bought in past month",
      "rating": "3.9",
      "review_count": "454",
      "price": 50061,
      "amazon_choice": "Best seller",
    },
    {
      "image_url":
          "https://m.media-amazon.com/images/I/81wO4cOZIvL._AC_UY218_.jpg",
      "product_url": "https://www.amazon.in/s?k=tablet#",
      "title": "Apple iPad (10.2-inch, Wi-Fi, 32GB) - Space Grey",
      "number_of_buyers": "100+ bought in past month",
      "rating": "4.5",
      "review_count": "150",
      "price": 22999,
      "amazon_choice": "",
    }
  ];

  return amazonDataList.map((amazonData) {
    return AmazonCard(
      imageUrl: amazonData["image_url"],
      productUrl: amazonData["product_url"],
      title: amazonData["title"],
      numberOfBuyers: amazonData["number_of_buyers"],
      rating: amazonData["rating"],
      reviewCount: amazonData["review_count"],
      price: amazonData["price"].toDouble(),
      amazonChoice: amazonData["amazon_choice"],
    );
  }).toList();
}
