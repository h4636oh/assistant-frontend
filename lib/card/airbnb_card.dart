import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AirbnbCard extends StatelessWidget {
  final String imageUrl;
  final String paymentUrl;
  final String hotelName;
  final String location;
  final String ratingReviews;
  final double totalPrice;
  final String tagText;

  const AirbnbCard({
    super.key,
    required this.imageUrl,
    required this.paymentUrl,
    required this.hotelName,
    required this.location,
    required this.ratingReviews,
    required this.totalPrice,
    required this.tagText,
  });

  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $paymentUrl");
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
              content: const Text("Do you want to proceed to the Airbnb listing?"),
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
            // ignore: use_build_context_synchronously
            _launchURL(context);
          }
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75, // Set width to 3/4 of viewport
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
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      hotelName,
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
                      location,
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
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              ratingReviews,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(80, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tagText,
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
        ).animate().fade(duration: 500.ms).slideY(),
      ),
    );
  }
}

List<AirbnbCard> getAirbnbCards() {
  final List<Map<String, dynamic>> airbnbDataList = [
    {
      "image_url": "https://i.pinimg.com/564x/7c/7a/f4/7c7af4e2c9d2b6d5e5bfbf8f4c4f2c3c.jpg",
      "payment_url": "https://www.airbnb.co.in/rooms/73498738",
      "hotel_name": "Luxury 3BHK Penthouse in South Delhi",
      "location": "Delhi, India",
      "rating_reviews": "4.95 (135 reviews)",
      "total_price": "₹ 15,000",
      "tag_text": "Luxury"
    },
    {
      "image_url": "https://i.pinimg.com/564x/6c/7f/4a/6c7f4a9f4d7c9b8b02a92a3c4c4d4a3d.jpg",
      "payment_url": "https://www.airbnb.co.in/rooms/73498739",
      "hotel_name": "Cozy 1BHK Flat in South Delhi",
      "location": "Delhi, India",
      "rating_reviews": "4.78 (58 reviews)",
      "total_price": "₹ 8,000",
      "tag_text": "Cozy"
    }
  ];

  return airbnbDataList.map((airbnbData) {
    return AirbnbCard(
      imageUrl: airbnbData["image_url"], 
      paymentUrl: airbnbData["payment_url"],
      hotelName: airbnbData["hotel_name"],
      location: airbnbData["location"],
      ratingReviews: airbnbData["rating_reviews"],
      totalPrice: double.parse(airbnbData["total_price"].replaceAll(RegExp(r'[^0-9.]'), '')),
      tagText: airbnbData["tag_text"],
    );
  }).toList();
}
