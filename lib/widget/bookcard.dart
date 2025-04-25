import 'package:flutter/material.dart';

class Bookcard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  const Bookcard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 101,
            height: 141,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 101,
                height: 141,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            author,
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }
}
