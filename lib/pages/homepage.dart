import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/CategoryButton.dart';
import 'package:litmedia/widget/bookcard.dart';

class Homepage extends StatelessWidget {
  final List<Map<String, String>> books = [
    {
      "title": "Qahirah - stories",
      "author": "@author1",
      "image": "https://link.to/qahirah.jpg",
    },
    {
      "title": "arabe civilization",
      "author": "@author2",
      "image": "https://link.to/arabciv.jpg",
    },
    {
      "title": "my first and only love",
      "author": "@author2",
      "image": "https://link.to/myfirstlove.jpg",
    },
  ];
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: 35,
            ),
          ),
          backgroundColor: AppColors.gris,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30,
                color: Colors.black,
              ),
            )
          ],
        ),
        backgroundColor: AppColors.offWhite,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(55),
                ),
                color: AppColors.gris,
              ),
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Releases",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.add),
                    ],
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Bookcard(
                              title: book['title']!,
                              author: book['author']!,
                              imageUrl: book['image']!,
                            ));
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Categorybutton(
                            label: 'fictions',
                            backgroundColor: AppColors.darkPurple),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Categorybutton(
                            label: 'fictions',
                            backgroundColor: AppColors.darkPurple),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Categorybutton(
                            label: 'fictions',
                            backgroundColor: AppColors.darkPurple),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
