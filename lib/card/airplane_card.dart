// lib/airplane_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AirplaneCard extends StatelessWidget {
  final String planeName;
  final String planeType;
  final String departureTime;
  final String departureDate;
  final String arrivalTime;
  final String arrivalDate;
  final String duration;
  final String finalPrice;
  final String nonstop;
  final String seatsAvailable;
  final String url;

  const AirplaneCard({
    super.key,
    required this.planeName,
    required this.planeType,
    required this.departureTime,
    required this.departureDate,
    required this.arrivalTime,
    required this.arrivalDate,
    required this.duration,
    required this.finalPrice,
    required this.nonstop,
    required this.seatsAvailable,
    required this.url,
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
    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content:
                  const Text("Do you want to proceed to the airplane website?"),
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
        child: Container(
          width:
              MediaQuery.of(context).size.width * 0.75, // 3/4 of viewport width
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plane name and type
              Text(
                planeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                planeType,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 10),
              // Departure and arrival information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Departure",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "$departureTime, $departureDate",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Arrival",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "$arrivalTime, $arrivalDate",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Duration, nonstop status, seats available, and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Duration: $duration",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    nonstop.toLowerCase() == "yes"
                        ? "Nonstop"
                        : nonstop.toLowerCase() == "no"
                            ? "Layover"
                            : "N/A",
                    style: TextStyle(
                        color: nonstop.toLowerCase() == "yes"
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seats: $seatsAvailable",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Price: ₹$finalPrice",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(), // Adding animation
    );
  }
}

/// Returns a list of AirplaneCard widgets using sample airplane data.
List<AirplaneCard> getAirplaneCards(List<Map<String, String>> response) {
  final List<Map<String, String>> airplaneDataList = response;

  return airplaneDataList.map((response) {
    return AirplaneCard(
      planeName: response["plane_name"] ?? "",
      planeType: response["plane_type"] ?? "",
      departureTime: response["departure_time"] ?? "",
      departureDate: response["departure_date"] ?? "",
      arrivalTime: response["arrival_time"] ?? "",
      arrivalDate: response["arrival_date"] ?? "",
      duration: response["duration"] ?? "",
      finalPrice: response["final_price"] ?? "",
      nonstop: response["nonstop"] ?? "",
      seatsAvailable: response["seats_available"] ?? "",
      url: response["url"] ?? "",
    );
  }).toList();
}
