import 'package:flutter/material.dart';

class Quotewidget extends StatelessWidget {
  final String quote;
  final String author;
  const Quotewidget({super.key, required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
          border:
              Border(left: BorderSide(color: Colors.grey.shade700, width: 4))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$quote"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "— $author",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
