import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AmazonCard extends StatelessWidget {
  final String imageUrl;
  final String productUrl;
  final String title;
  final String numberOfBuyers;
  final String rating;
  final String reviewCount;
  final double price;
  final String? amazonChoice;

  const AmazonCard({
    super.key,
    required this.imageUrl,
    required this.productUrl,
    required this.title,
    required this.numberOfBuyers,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.amazonChoice,
  });

  /// Launches the product URL in an external application.
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(productUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $productUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.75;

    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                "Do you want to proceed to the product website?",
              ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: SizedBox(
          width: cardWidth,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
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
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      numberOfBuyers,
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
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '$rating ($reviewCount reviews)',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              if (amazonChoice != null && amazonChoice!.isNotEmpty)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(80, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      amazonChoice!,
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
        ),
      ),
    );
  }
}

List<AmazonCard> getAmazonCards() {
  final List<Map<String, dynamic>> amazonDataList = [
    {
      "image_url":"https://m.media-amazon.com/images/I/71cbbGm02pL._AC_UY218_.jpg",
      "product_url": "https://www.amazon.in/HP-Laptop-255-G9-Ryzen/dp/B0DJCWBY7G/ref=sr_1_4?dib=eyJ2IjoiMSJ9.Kq6xvSBkUHQcGOUtNjakx1stJc-FOxGMg_wDgGo2ewAsydvzy7IIg4trdjIYYcSe1UQAYDNeBb18c0i3X52N2rKlQfkf9DjI7-9JMqsPnAagE4tRrPcdmAYpp5oGOCXkcsfKAl43BrbJMywTRweI452gK43IixDLgEzXaS4rm4oPD9lNaJWL60ygdaiEtU2v-JoTNtUjf9MowmkC5LDZ60wHpItlj-MuoSqoa47ov4A.h34Z0afduo2vmZ80d_KRRj70tEiNCuETqC6Le8DEf1A&dib_tag=se&keywords=laptop&qid=1738950587&sr=8-4",
      "title": "HP Laptop 255 G9 AMD Ryzen 3 3250U Dual Core - (8GB/512GB SSD/AMD Radeon Graphics) Thin and Light Business Laptop/15.6\" (39.62cm)/Black/1.47 kg",
      "number_of_buyers": "200+ bought in past month",
      "rating": "3.8",
      "review_count": "454",
      "price":24299,
      "amazon_choice": "Best seller",
    },
    {
      "image_url": "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_UY218_.jpg",
      "product_url": "https://www.amazon.in/Apple-MacBook-Chip-13-inch-256GB/dp/B08N5W4NNB/ref=sr_1_14?dib=eyJ2IjoiMSJ9.Kq6xvSBkUHQcGOUtNjakx1stJc-FOxGMg_wDgGo2ewAsydvzy7IIg4trdjIYYcSe1UQAYDNeBb18c0i3X52N2rKlQfkf9DjI7-9JMqsPnAagE4tRrPcdmAYpp5oGOCXkcsfKAl43BrbJMywTRweI452gK43IixDLgEzXaS4rm4oPD9lNaJWL60ygdaiEtU2v-JoTNtUjf9MowmkC5LDZ60wHpItlj-MuoSqoa47ov4A.h34Z0afduo2vmZ80d_KRRj70tEiNCuETqC6Le8DEf1A&dib_tag=se&keywords=laptop&qid=1738950587&sr=8-14",
      "title": "Apple MacBook Air Laptop: Apple M1 chip, 13.3-inch/33.74 cm Retina Display, 8GB RAM, 256GB SSD Storage, Backlit Keyboard, FaceTime HD Camera, Touch ID. Works with iPhone/iPad; Space Grey",
      "number_of_buyers":  "200+ bought in past month",
      "rating": "4.6",
      "review_count": "150",
      "price": 67990,
      "amazon_choice": "Best seller",
    }
  ];

  return amazonDataList.map((amazonData) {
    return AmazonCard(
      imageUrl: amazonData["image_url"],
      productUrl: amazonData["product_url"],
      title: amazonData["title"],
      numberOfBuyers: amazonData["number_of_buyers"],
      rating: amazonData["rating"],
      reviewCount: amazonData["review_count"],
      price: amazonData["price"].toDouble(),
      amazonChoice: amazonData["amazon_choice"],
    );
  }).toList();
}
