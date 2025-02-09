import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AirbnbCard extends StatelessWidget {
  final String imageUrl;
  final String paymentUrl;
  final String hotelName;
  final String location;
  final String ratingReviews;
  final String totalPrice;
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
                          totalPrice,
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

List<AirbnbCard> getAirbnbCards(dynamic response) {
  final List<Map<String, dynamic>> airbnbDataList = response;

  return airbnbDataList.map((response) {
    return AirbnbCard(
      imageUrl: response["image_url"] ?? "https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MTI3NTIzMzkxNjA2NTIzNTUxNg%3D%3D/original/4aad2d01-214c-4cf2-9dac-a17a1c2b77ab.jpeg?im_w=720&im_format=avif",           // Default to empty string
      paymentUrl: response["payment_url"] ?? "",
      hotelName: response["hotel_name"] ?? "Unknown",  // Fallback value
      location: response["location"] ?? "Unknown",
      ratingReviews: response["rating_reviews"] ?? "0.0 (0)",
      totalPrice: response["total_price"] ?? "N/A",
      tagText: response["tag_text"] ?? "",
    );
  }).toList();
}
