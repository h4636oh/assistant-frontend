// lib/card/restaurant.dart
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String number; // e.g. number of reviews
  final String rating;
  final String image_url;
  final String restaurant_url;
  final List<String> tags;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.number,
    required this.rating,
    required this.image_url,
    required this.restaurant_url,
    required this.tags,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(restaurant_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $restaurant_url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> displayedTags =
        tags.length > 3 ? tags.sublist(0, 3) : tags;

    return GestureDetector(
      onTap: () {
        // Show a confirmation dialog before proceeding.
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "Do you want to proceed to the restaurant listing?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
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
      child: FractionallySizedBox(
        widthFactor: 0.75, // 3/4 of the viewport width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 2,
          // Optionally set a background color if needed:
          // color: Colors.grey[900],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant image
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
              // Restaurant name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Rating and number of reviews
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '$rating ($number)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Display tags as plain text styled like a "Breakfast Included" tag
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  spacing: 8.0,
                  children: displayedTags.map((tag) {
                    return Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ).animate().fade(duration: 300.ms).slideX(),
      ),
    );
  }
}

// Example data generator for RestaurantCard widgets
List<RestaurantCard> getRestaurantCards(List<Map<String, String>> response) {
  final List<Map<String, String>> restaurantDataList = response;

  return restaurantDataList.map((response) {
    return RestaurantCard(
      image_url: response["image"] ?? "",
      restaurant_url: response["url"] ?? "",
      name: response["name"] ?? "",
      rating: response["star"] ?? "",
      number: response["number_of_reviews"] ?? "",
      tags: (response["tags"] ?? "").split(",").map((e) => e.trim()).toList()
    );
  }).toList();
}
