import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MovieList extends StatelessWidget {
  final String title;
  final String poster;
  final String ageRating;
  final String movieUrl;
  final String language;

  const MovieList({
    super.key,
    required this.title,
    required this.poster,
    required this.ageRating,
    required this.movieUrl,
    required this.language,
  });

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(movieUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $movieUrl");
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
              content: const Text("Do you want to proceed to the movie page?"),
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
            _launchURL();
          }
        });
      },
      child: FractionallySizedBox(
        widthFactor: 0.75, // 3/4 of the viewport width
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AspectRatio(
                          aspectRatio: 2 / 3, // Default ratio (adjust if needed)
                          child: Image.network(
                            poster,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.image_not_supported, size: 50),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft, // Moved rating to left
                      child: Text(
                        ageRating,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    language,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: 500.ms).slideY(),
        ),
      ),
    );
  }
}

List<MovieList> getMoviesListCards() {
  final List<Map<String, dynamic>> movieListDataList = [
    {
      "title": "Deva",
      "poster":
          "https://assetscdn1.paytm.com/images/cinema/Deva-9e0ee020-dc89-11ef-8051-f1d2444f0349-172a3830-df08-11ef-8d3b-69192b9fb9f8.jpg?format=webp&imwidth=576",
      "link": "https://paytm.com/movies/deva-movie-detail-167607",
      "age_rating": "UA16+",
      "language": "Hindi"
    },
    {
      "title": "Sanam Teri Kasam (2016)",
      "poster":
          "https://assetscdn1.paytm.com/images/cinema/Sanam-Teri-Kasam-c3f6b7e0-de0a-11ef-9a57-a7efe77237ab.jpg?format=webp&imwidth=576",
      "link":
          "https://paytm.com/movies/sanam-teri-kasam-2016-movie-detail-140032",
      "age_rating": "U",
      "language": "Hindi"
    },
    {
      "title": "Loveyapa",
      "poster": "https://assetscdn1.paytm.com/images/cinema/loveyappa-a65cca50-e2bd-11ef-8f0a-13039e72f1f5.jpg?format=webp&imwidth=576",
      "link": "https://paytm.com/movies/loveyapa-movie-detail-185770",
      "age_rating": "UA16+",
      "language": "Hindi"
    }
  ];

  return movieListDataList.map((data) {
    return MovieList(
      poster: data["poster"],
      movieUrl: data["link"],
      title: data["title"],
      language: data["language"],
      ageRating: data["age_rating"],
    );
  }).toList();
}
