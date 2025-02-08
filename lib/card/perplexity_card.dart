import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  final Map<String, dynamic> newsData = const {
    'response_content': "The Delhi Assembly Elections 2025 have resulted in a significant political shift, with the Bharatiya Janata Party (BJP) set to form the government in Delhi after 27 years[1]. The BJP is leading in over 47 out of 70 assembly seats, while the Aam Aadmi Party (AAP), which previously ruled for two terms, is ahead in only 20+ seats[1].\n\nKey points from the election results:\n\n- BJP's comeback: The BJP is poised to return to power in Delhi after more than two decades[1][2].",
    'response_url': [
      'https://www.youtube.com/watch?v=jj2MjbYzPec',
      'https://indianexpress.com/article/india/election-commission-of-india-eci-delhi-election-results-2025-live-updates-on-eciresults-nic-in-results-eci-gov-in-aap-kejriwal-bjp-9823664/',
      'https://www.hindustantimes.com/india-news/new-delhi-election-2025-results-live-updates-arvind-kejriwal-parvesh-verma-sandeep-dikshit-assembly-latest-february-8-101738970249936.html'
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900], // Dark background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Keeps height dynamic
          children: [
            _buildNewsContent(),
            if (newsData['response_url'] != null && newsData['response_url'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(thickness: 1, color: Colors.grey[700]),
              const SizedBox(height: 6),
              _buildSources(),
            ],
          ],
        ),
      ),
    );
  }

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'\[\d+\]'), ''); // Removes [1], [2], etc.
  }

  Widget _buildNewsContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50), // Dynamic height
          child: SingleChildScrollView(
            child: Text(
              _cleanText(newsData['response_content'] ?? 'No news available'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Light text for dark mode
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSources() {
    List<dynamic> sources = newsData['response_url'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sources:",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Column(
          children: sources.map((url) => _buildSourceItem(url)).toList(),
        ),
      ],
    );
  }

  Widget _buildSourceItem(String url) {
    return InkWell(
      onTap: () async {
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.link, size: 18, color: Colors.blueAccent),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
2