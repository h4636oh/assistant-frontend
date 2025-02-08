// lib/card/uber_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UberCard extends StatelessWidget {
  final String type;
  final String url;
  final String pickupName;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String dropoffName;
  final String dropoffAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;

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
List<UberCard> getUberCards() {
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
    },
  ];

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
