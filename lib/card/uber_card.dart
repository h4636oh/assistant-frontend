// lib/card/uber_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UberCard extends StatelessWidget {
  final String type;
  final String url;
  final String pickupName;
  final String pickupAddress;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropoffName;
  final String dropoffAddress;
  final String dropoffLatitude;
  final String dropoffLongitude;

  const UberCard({
    super.key,
    required this.type,
    required this.url,
    required this.pickupName,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffName,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
  });

  /// Launches the URL in an external application.
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.75;

    return GestureDetector(
      onTap: () {
        // Show a confirmation dialog before proceeding.
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content:
                  const Text("Do you want to proceed to the Uber website?"),
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
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: cardWidth, // 75% of the screen width.
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the ride type.
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Pickup details.
                Text(
                  "Pickup",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  "$pickupName\n$pickupAddress",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
                // Dropoff details.
                Text(
                  "Dropoff",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  "$dropoffName\n$dropoffAddress",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(), // Adding animation
    );
  }
}

/// Returns a list of UberCard widgets using the provided Uber data.
List<UberCard> getUberCards(dynamic response) {
  final List<Map<String, dynamic>> uberDataList = response;

  return uberDataList.map((uberData) {
    final pickup = uberData['pickup'];
    final dropoff = uberData['dropoff'];

    return UberCard(
      type: uberData['type'],
      url: uberData['url'],
      pickupName: pickup['name'],
      pickupAddress: pickup['address'],
      pickupLatitude: pickup['latitude'],
      pickupLongitude: pickup['longitude'],
      dropoffName: dropoff['name'],
      dropoffAddress: dropoff['address'],
      dropoffLatitude: dropoff['latitude'],
      dropoffLongitude: dropoff['longitude'],
    );
  }).toList();
}
