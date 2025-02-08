import 'package:flutter/material.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({super.key});

  final List<Map<String, dynamic>> theaters = const [
    {
      "theater": "Cinepolis, Viviana Mall, Eastern Express Highway, Thane",
      "shows": [
        {"time": "06:30 PM", "special": "INSIGNIA", "format": "2D"},
        {"time": "08:40 PM", "special": "LASER", "format": "2D"}
      ]
    },
    {
      "theater": "PVR Cinemas, Phoenix Marketcity, LBS Road, Mumbai",
      "shows": [
        {"time": "07:00 PM", "special": "4DX", "format": "3D"},
        {"time": "09:30 PM", "special": "IMAX", "format": "2D"}
      ]
    },
    {
      "theater": "INOX Megaplex, Inorbit Mall Malad, Mumbai",
      "shows": [
        {"time": "05:00 PM", "special": "DOLBY", "format": "2D"},
        {"time": "10:00 PM", "special": "LASER", "format": "2D"}
      ]
    }
  ];

  Map<String, String> parseTheater(String theater) {
    List<String> parts = theater.split(", ");
    return {
      "name": parts[0],
      "location": parts.sublist(1, parts.length - 1).join(", "),
      "mainLocation": parts.last
    };
  }

  void showVenueDetails(BuildContext context, String name, String location, String mainLocation) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "$location, $mainLocation",
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(backgroundColor: Colors.grey.shade700),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeight = (theaters.length * 80).toDouble().clamp(200, 400);

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: cardHeight,
            child: SingleChildScrollView(
              child: Column(
                children: theaters.map((theaterData) {
                  final venue = parseTheater(theaterData["theater"]!);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () => showVenueDetails(
                          context, venue["name"]!, venue["location"]!, venue["mainLocation"]!,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                venue["name"]!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                "${venue["location"]}, ${venue["mainLocation"]}",
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
