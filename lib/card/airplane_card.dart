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
              content: const Text(
                  "Do you want to proceed to the airplane website?"),
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
          width: MediaQuery.of(context).size.width * 0.75, // 3/4 of viewport width
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
                    nonstop.toLowerCase() == "yes" ? "Nonstop" : nonstop.toLowerCase() == "no" ? "Layover" : "N/A",
                    style: TextStyle(color: nonstop.toLowerCase() == "yes" ? Colors.green : Colors.red),
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
      ).animate().fade(duration: 500.ms).slideY(), // Adding animation
    );
  }
}

/// Returns a list of AirplaneCard widgets using sample airplane data.
List<AirplaneCard> getAirplaneCards() {
  final List<Map<String, dynamic>> airplaneDataList = [
    {
      "plane_name": "IndiGo",
      "plane_type": "Economy",
      "departure_time": "06:05",
      "departure_date": "10 Feb",
      "arrival_time": "07:35",
      "arrival_date": "10 Feb",
      "duration": "01h 30m",
      "final_price": "1,516",
      "nonstop": "No",
      "seats_available": "20",
      "url": "https://www.goindigo.in/flight-status.html"
    },
    {
      "plane_name": "Emirates",
      "plane_type": "Boeing 747",
      "departure_time": "10:30 AM",
      "departure_date": "15 Mar",
      "arrival_time": "01:45 PM",
      "arrival_date": "15 Mar",
      "duration": "03h 15m",
      "final_price": "750",
      "nonstop": "Yes",
      "seats_available": "45",
      "url":
          "https://tickets.example.com/flight/search/NewYork/LosAngeles/2025-03-15/1"
    }
  ];

  return airplaneDataList.map((airplaneData) {
    return AirplaneCard(
      planeName: airplaneData["plane_name"],
      planeType: airplaneData["plane_type"],
      departureTime: airplaneData["departure_time"],
      departureDate: airplaneData["departure_date"],
      arrivalTime: airplaneData["arrival_time"],
      arrivalDate: airplaneData["arrival_date"],
      duration: airplaneData["duration"],
      finalPrice: airplaneData["final_price"],
      nonstop: airplaneData["nonstop"],
      seatsAvailable: airplaneData["seats_available"],
      url: airplaneData["url"],
    );
  }).toList();
}
