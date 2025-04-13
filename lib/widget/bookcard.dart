import 'package:flutter/material.dart';

class Bookcard extends StatelessWidget {
  final String title;
  final String author;

  const Bookcard({
    super.key,
    required this.title,
    required this.author,

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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),

              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                )
              ],
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
