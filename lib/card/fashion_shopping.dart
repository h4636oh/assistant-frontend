import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FashionShopping extends StatelessWidget {
  final String imageUrl;
  final double price;
  final String title;
  final String brand;
  final String productUrl;

  const FashionShopping({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.title,
    required this.brand,
    required this.productUrl,
  });

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(productUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $productUrl");
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
                  const Text("Do you want to proceed to the product page?"),
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
                    child: FutureBuilder<Size>(
                      future: _getImageSize(imageUrl),
                      builder: (context, snapshot) {
                        double aspectRatio = snapshot.hasData
                            ? snapshot.data!.width / snapshot.data!.height
                            : 3 / 4;
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child:
                                    Icon(Icons.image_not_supported, size: 50),
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
                      alignment: Alignment.centerRight,
                      child: Text(
                        '₹${price.toStringAsFixed(0)}',
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
                    brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: 300.ms).slideX(),
        ),
      ),
    );
  }

  Future<Size> _getImageSize(String url) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.network(url);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final Size imageSize = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        completer.complete(imageSize);
      }),
    );

    return completer.future;
  }
}

List<FashionShopping> getFashionCards() {
  final List<Map<String, dynamic>> productDataList = [
    {
      "imageUrl":
          "https://images.bewakoof.com/t1080/men-s-blue-white-color-block-oversized-polo-zipper-t-shirt-637203-1715258319-1.jpg",
      "productUrl":
          "https://www.bewakoof.com/p/mens-blue-white-color-block-oversized-polo-zipper-t-shirt",
      "title": "Men's Blue & White Color Block Oversized Polo Zipper T-shirt",
      "brand": "bewakoof",
      "price": 1170.00,
    },
    {
      "imageUrl":
          "https://images.bewakoof.com/t1080/men-angry-zip-printed-t-shirt-577430-1679027317-1.jpg",
      "productUrl":
          "https://www.bewakoof.com/p/men-angry-zip-printed-t-shirt-men",
      "title": "Men's Blue Angry Zip Graphic Printed T-shirt",
      "brand": "bewakoof",
      "price": 399.00,
    },
    {
      "imageUrl":
          "https://images.bewakoof.com/t1080/men-s-blue-white-color-block-oversized-polo-zipper-t-shirt-637203-1715258319-1.jpg",
      "productUrl":
          "https://www.bewakoof.com/p/mens-blue-white-color-block-oversized-polo-zipper-t-shirt",
      "title": "Men's Blue & White Color Block Oversized Polo Zipper T-shirt",
      "brand": "bewakoof",
      "price": 1170.00,
    },
    {
      "imageUrl":
          "https://wrogn.com/cdn/shop/files/1_35fb28db-cf18-48a0-a994-f614b9fb3aaa.jpg",
      "productUrl":
          "https://wrogn.com/products/urban-pink-aop-oversized-t-shirt?_pos=127&_fid=c3fb51a6d&_ss=c",
      "title": "Urban Pink AOP Oversized T-Shirt",
      "brand": "wrogn",
      "price": 599.00,
    }
  ];

  return productDataList.map((data) {
    return FashionShopping(
      imageUrl: data["imageUrl"],
      productUrl: data["productUrl"],
      title: data["title"],
      brand: data["brand"],
      price: data["price"],
    );
  }).toList();
}
