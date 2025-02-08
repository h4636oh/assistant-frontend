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
              content:
                  const Text("Do you want to proceed to the Airbnb listing?"),
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
        width: MediaQuery.of(context).size.width *
            0.75, // Set width to 3/4 of viewport
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
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        );
                      },
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
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
        ).animate().fade(duration: 300.ms).slideX(),
      ),
    );
  }
}

List<AirbnbCard> getAirbnbCards() {
  final List<Map<String, dynamic>> airbnbDataList = [
    {
      "image_url":
          "https://a0.muscache.com/im/pictures/6645a719-dc78-44a3-9a05-38920c2ac527.jpg?im_w=720&im_format=avif",
      "payment_url":
          "https://www.airbnb.co.in/rooms/1252006468109509167?adults=1&search_mode=regular_search&check_in=2025-02-09&check_out=2025-02-14&source_impression_id=p3_1738780338_P3mUh3vS69u3_BV-&previous_page_section_name=1000&federated_search_id=c8193494-d40f-4203-9131-a4d179497cad",
      "payment_link":
          "https://www.airbnb.co.in/rooms/1252006468109509167?adults=1&search_mode=regular_search&check_in=2025-02-09&check_out=2025-02-14&source_impression_id=p3_1738780338_P3mUh3vS69u3_BV-&previous_page_section_name=1000&federated_search_id=c8193494-d40f-4203-9131-a4d179497cad",
      "hotel_name": "Flat in Calangute",
      "location": "Flat in Calangute",
      "rating_reviews": "4.92 (36)",
      "total_price": "₹6,495 total",
      "tag_text": "Superhost",
    },
    {
      "image_url":
          "https://a0.muscache.com/im/pictures/miso/Hosting-836057693936248879/original/30b2b61d-3aa4-4653-8751-83252cdf7071.jpeg?im_w=720&im_format=avif",
      "payment_link":
          "https://www.airbnb.co.in/rooms/1252006468109509167?adults=1&search_mode=regular_search&check_in=2025-02-09&check_out=2025-02-14&source_impression_id=p3_1738780338_P3mUh3vS69u3_BV-&previous_page_section_name=1000&federated_search_id=c8193494-d40f-4203-9131-a4d179497cad",
      "hotel_name": "Flat in Calangute",
      "location": "Flat in Calangute near Scenic studio apartment at Baga",
      "rating_reviews": "4.86 (74)",
      "total_price": "₹6,495 total",
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
      totalPrice: double.parse(
          airbnbData["total_price"].replaceAll(RegExp(r'[^0-9.]'), '')),
      tagText: airbnbData["tag_text"],
    );
  }).toList();
}
