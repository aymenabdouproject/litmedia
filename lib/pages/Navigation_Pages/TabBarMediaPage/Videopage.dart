import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Videopage extends StatelessWidget {
  const Videopage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> Category = [
      "All",
      "History",
      "Sci-Fi",
      "Fantasy",
      "Classics",
    ];
    final screewidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    border: Border.all(color: Colors.grey.withOpacity(0.8)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text(
                    Category[index],
                    style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                  )),
                );
              },
            ),
          ),
          Text("Continue Watching"),
          Center(
            child: Container(
              height: screenheight * 0.14,
            ),
          ),
          Text(
            "Author Interviews",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Container(
              height: screenheight * 0.1,
            ),
          ),
          Center(
            child: Container(
              height: screenheight * 0.1,
            ),
          ),
          Text(
            "Books Trailes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Container(
              height: screenheight * 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
