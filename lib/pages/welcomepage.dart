import 'package:flutter/material.dart';
import 'package:litmedia/pages/Navigation_Pages/homepage.dart';
import 'package:litmedia/static/colors.dart';
import 'package:litmedia/widget/OnboardingPage%20.dart';
import 'package:litmedia/widget/navigationbar.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  PageController _controller = PageController();
  int _currentPage = 0;

  List<Widget> pages = [
    OnboardingPage(
      bgColor: AppColors.darkPurple,
      image: "images/welcome1.png",
      title: 'Welcome to LitMedia !',
      subtitle: 'YOUR GATEWAY TO THE WORLD OF BOOKS !',
      description:
          'Discover books through engaging videos, podcasts, and interactive content. Make reading a habit, one story at a time!',
    ),
    OnboardingPage(
      bgColor: AppColors.mediumPurple,
      image: "images/welcome2.png",
      title: 'Discover Books\nin a New Way !',
      subtitle: 'EXPLORE BOOKS THROUGH MULTIMEDIA',
      description:
          'Watch book trailers, listen to reviews, and dive into interactive content to find your next favorite read.',
    ),
    OnboardingPage(
      bgColor: AppColors.lightPurple,
      image: "images/welcome3.png",
      title: 'Build a Reading Habit !',
      subtitle: 'SMALL STEPS, BIG CHANGE',
      description:
          'Set goals, track progress, and get inspiration to make reading an enjoyable habit.',
    ),
    OnboardingPage(
      bgColor: AppColors.darkPurple,
      image: "images/welcome4.png",
      title: 'Connect & Share !',
      subtitle: 'JOIN A COMMUNITY OF BOOK LOVERS',
      description:
          'Share your favorite books, get recommendations, and connect with other readers.',
    ),
  ];
  void nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    } else {
      // Navigate to home or main screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Navigationbar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) => Stack(
          children: [
            pages[index],
            Positioned(
              bottom: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 30),
                onPressed: nextPage,
              ),
            )
          ],
        ),
      ),
    );
  }
}
