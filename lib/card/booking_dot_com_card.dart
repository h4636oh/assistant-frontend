// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingCard extends StatelessWidget {
  final String image_url;
  final String hotel_url;
  final String title;
  final double rating;
  final int review_count;
  final String review_comment;
  final double price;
  final bool Breakfast_included;

  const BookingCard({
    super.key,
    required this.image_url,
    required this.hotel_url,
    required this.title,
    required this.rating,
    required this.review_count,
    required this.review_comment,
    required this.price,
    required this.Breakfast_included,
  });

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(hotel_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $hotel_url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text("Do you want to proceed to the Booking.com listing?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
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
            _launchURL();
          }
        });
      },
      child: FractionallySizedBox(
        widthFactor: 0.75, // 3/4 of the viewport width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  image_url,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                        child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child:
                          Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  review_comment,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Breakfast_included ? Icons.restaurant : Icons.no_meals,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Breakfast_included ? "Breakfast Included" : "No Breakfast",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($review_count reviews)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ).animate().fade(duration: 400.ms).slideY(),
      ),
    );
  }
}

List<BookingCard> getBookingCards() {
  final List<Map<String, dynamic>> scrapedDataList = [
    {
      "image_url": "https://cf.bstatic.com/xdata/images/hotel/square600/467538050.webp?k=4dc63210102a80dd6904d8585500732c30b2e16c643a461699fcca1649ee92ee&o=",
      "hotel_url": "https://www.booking.com/hotel/73498739",
      "title": "Cozy 1BHK Flat in South Delhi",
      "review_comment": "Comfortable and peaceful stay.",
      "rating": 4.78,
      "review_count": 58,
      "price": 8000.0,
      "Breakfast_included": true
    }
  ];

  return scrapedDataList.map((data) {
    return BookingCard(
      image_url: data["image_url"],
      hotel_url: data["hotel_url"],
      title: data["title"],
      review_comment: data["review_comment"],
      rating: data["rating"],
      review_count: data["review_count"],
      price: data["price"],
      Breakfast_included: data["Breakfast_included"],
    );
  }).toList();
}
