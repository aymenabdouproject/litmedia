import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';

class Audiopage extends StatefulWidget {
  const Audiopage({super.key});

  @override
  State<Audiopage> createState() => _AudiopageState();
}

class _AudiopageState extends State<Audiopage> {
  List<String> Category = [
    "All",
    "History",
    "Sci-Fi",
    "Fantasy",
    "Classics",
  ];

  @override
  Widget build(BuildContext context) {
    final screewidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Continue listening"),
          Center(
            child: Container(
              width: screewidth * 0.8,
              height: screenheight * 0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.electricPurple,
              ),
            ),
          ),
          Text("Collections"),
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
          Text(
            "Popular Audiobooks",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screewidth * 0.45,
                height: screenheight * 0.11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.electricPurple,
                ),
              ),
              Container(
                width: screewidth * 0.45,
                height: screenheight * 0.11,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.electricPurple,
                ),
              ),
            ],
          ),
          Text("What's New?"),
        ],
      ),
    );
  }
}
