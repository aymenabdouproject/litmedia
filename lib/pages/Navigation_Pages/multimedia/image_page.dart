import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class BookDetailPage extends StatelessWidget {
  final String booktitle;
  final String quote;
  final String mediaUrl;
  final String? caption;
  final String? mediatitle;
  final String? desc;
  final List<String>? tags;
  final String bookId;
  final String mediaType;
  final String? createdBy;

  BookDetailPage({
    required this.booktitle,
    required this.quote,
    required this.mediaUrl,
    this.caption,
    this.mediatitle,
    this.desc,
    this.tags,
    required this.bookId,
    required this.mediaType,
    this.createdBy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 149, 194),
      appBar: AppBar(
        title: Text(booktitle),
        backgroundColor: AppColors.lightPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gallery Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                mediaUrl,
                fit: BoxFit
                    .contain, // use BoxFit.cover if you want it to crop and fill
                width: double.infinity,
                // Don't set a fixed height – it will size naturally
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  height: 200,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),

            const SizedBox(height: 10),
            // Quote Section
            Text(
              '"$quote"',
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 19, 18, 18),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Information Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media Title
                  if (mediatitle != null)
                    Text(
                      'Title: $mediatitle',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Book Title
                  Text(
                    'Book Title: $booktitle',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  if (desc != null)
                    Text(
                      'Description: $desc',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Tags
                  if (tags != null && tags!.isNotEmpty)
                    Text(
                      'Tags: ${tags!.join(', ')}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Created By
                  if (createdBy != null)
                    Text(
                      'Created By: $createdBy',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Media Type
                  Text(
                    'Media Type: $mediaType',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Book ID
                  Text(
                    'Book ID: $bookId',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Caption
                  if (caption != null)
                    Text(
                      'Caption: $caption',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
