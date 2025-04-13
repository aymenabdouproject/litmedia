import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/CategoryButton.dart';
import 'package:litmedia/widget/bookcard.dart';

class Homepage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.favorite,
      'name': 'favorite',
    },
    {
      'icon': Icons.notifications,
      'name': 'notification',
    },
    {
      'icon': Icons.flag,
      'name': 'challenge',
    },
    {
      'icon': Icons.create,
      'name': 'create content',
    },
    {
      'icon': Icons.menu_book,
      'name': 'publish a book',
    },
    {
      'icon': Icons.local_offer,
      'name': 'Promotions',
    },
    {
      'icon': Icons.settings,
      'name': 'Settings',
    },
    {
      'icon': Icons.logout,
      'name': 'Log out',
    },
  ];
  final List<Map<String, String>> books = [
    {
      "title": "Qahirah - stories",
      "author": "@author1",
    },
    {
      "title": "arabe civilization",
      "author": "@author2",
    },
    {
      "title": "my first and only love",
      "author": "@author2",
    },
  ];
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: AppColors.darkPurple,
          child: IconTheme(
              data: IconThemeData(
                color: AppColors.offWhite,
                size: 30,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: AppColors.grayPurple,
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.2,
                              )),
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Medelci Abdou",
                              style: TextStyle(color: AppColors.offWhite),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent), // No splash
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.zero), // Remove padding
                                tapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // Minimizes clickable area
                              ),
                              onPressed: () {},
                              child: Text("more details"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            menuItems[index]['icon'],
                            color: AppColors.offWhite,
                          ),
                          title: Text(
                            menuItems[index]['name'],
                            style: TextStyle(color: AppColors.offWhite),
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(size: 30, color: AppColors.offWhite),
          backgroundColor: AppColors.gris,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
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
                            ));
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Categorybutton(
                          label: 'fictions',
                          backgroundColor: AppColors.darkPurple),
                      Categorybutton(
                          label: 'fictions',
                          backgroundColor: AppColors.darkPurple),
                      Categorybutton(
                          label: 'fictions',
                          backgroundColor: AppColors.darkPurple),
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
