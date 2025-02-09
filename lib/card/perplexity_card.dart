import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PerplexityCard extends StatelessWidget {
  final String content;
  final List<String> sources;

  const PerplexityCard({
    super.key,
    required this.content,
    required this.sources,
  });

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'\[\d+\]'), '');
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPerplexityContent(),
              if (sources.isNotEmpty) ...[
                const SizedBox(height: 12),
                Divider(thickness: 1, color: Colors.grey[700]),
                const SizedBox(height: 6),
                _buildPerplexitySources(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerplexityContent() {
    return Text(
      _cleanText(content),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPerplexitySources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sources:",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Column(
          children:
              sources.map((url) => _buildPerplexitySourceItem(url)).toList(),
        ),
      ],
    );
  }

  Widget _buildPerplexitySourceItem(String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.link, size: 18, color: Colors.purple),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.purple,
                  // decoration: TextDecoration.underline,
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

List<PerplexityCard> getPerplexityCards(dynamic response) {
  final Map<String, dynamic> newsData = response;

  return [
    PerplexityCard(
      content: newsData['response_content'],
      sources: List<String>.from(newsData['response_url']),
    )
  ];
}
