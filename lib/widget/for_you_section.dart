import 'package:flutter/material.dart';

class ForYouSection extends StatelessWidget {
  final String title;
  final String likes;
  final double rating;
  const ForYouSection(
      {super.key,
      required this.title,
      required this.likes,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 215,
      height: 130,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    rating.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: Color(0xFFD9CFFF),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      likes,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.purple),
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
