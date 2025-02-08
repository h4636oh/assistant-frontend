// lib/card/bus_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BusCard extends StatelessWidget {
  final String busName;
  final String busType;
  final String departureTime;
  final String departureDate;
  final String arrivalTime;
  final String arrivalDate;
  final String duration;
  final String finalPrice;
  final String rating;
  final String seatsAvailable;
  final String url;

  const BusCard({
    super.key,
    required this.busName,
    required this.busType,
    required this.departureTime,
    required this.departureDate,
    required this.arrivalTime,
    required this.arrivalDate,
    required this.duration,
    required this.finalPrice,
    required this.rating,
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
    // Wrap the card in a GestureDetector to add a confirmation dialog on tap.
    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text("Do you want to proceed to the bus website?"),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus name and type.
              Text(
                busName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                busType,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 10),
              // Departure and arrival information.
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
              // Duration, rating, seats available, and price.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Duration: $duration",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Rating: $rating",
                    style: const TextStyle(color: Colors.white),
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

/// Returns a list of BusCard widgets using sample bus data.
List<BusCard> getBusCards() {
  final List<Map<String, dynamic>> busDataList = [
    {
      "bus_name": "NueGo",
      "bus_type": "AC Seater 2+2 Electric",
      "departure_time": "11:30 PM",
      "departure_date": "10 Feb",
      "arrival_time": "05:05 AM",
      "arrival_date": "11 Feb",
      "duration": "05h 35m",
      "final_price": "346",
      "rating": "3.5",
      "seats_available": "17",
      "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
    },
    {
      "bus_name": "NueGo",
      "bus_type": "AC Seater 2+2 Electric",
      "departure_time": "11:00 PM",
      "departure_date": "10 Feb",
      "arrival_time": "04:35 AM",
      "arrival_date": "11 Feb",
      "duration": "05h 35m",
      "final_price": "346",
      "rating": "3.6",
      "seats_available": "20",
      "url": "https://tickets.paytm.com/bus/search/Delhi/Jaipur/2025-02-10/1"
    }
  ];

  return busDataList.map((busData) {
    return BusCard(
      busName: busData["bus_name"],
      busType: busData["bus_type"],
      departureTime: busData["departure_time"],
      departureDate: busData["departure_date"],
      arrivalTime: busData["arrival_time"],
      arrivalDate: busData["arrival_date"],
      duration: busData["duration"],
      finalPrice: busData["final_price"],
      rating: busData["rating"],
      seatsAvailable: busData["seats_available"],
      url: busData["url"],
    );
  }).toList();
}
