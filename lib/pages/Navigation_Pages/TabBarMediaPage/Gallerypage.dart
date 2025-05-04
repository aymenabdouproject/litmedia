import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Gallerypage extends StatefulWidget {
  const Gallerypage({super.key});

  @override
  State<Gallerypage> createState() => _GallerypageState();
}

class _GallerypageState extends State<Gallerypage> {
  List<String> Category = [
    "All",
    "History",
    "Sci-Fi",
    "Fantasy",
    "Classics",
  ];

  final List<Map<String, dynamic>> items = [
    {"title": "Item 1", "color": Colors.purple},
    {"title": "Item 2", "color": Colors.blue},
    {"title": "Item 3", "color": Colors.green},
    {"title": "Item 4", "color": Colors.orange},
    {"title": "Item 5", "color": Colors.red},
    {"title": "Item 6", "color": Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: Category.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text(Category[index])),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      Container(
                        height: 170,
                        width: 300,
                        decoration: BoxDecoration(
                          color: item['color'],
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Text(items[index]["title"])
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
