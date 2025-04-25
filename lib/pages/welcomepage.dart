import 'package:flutter/material.dart';
import 'package:litmedia/pages/wrapper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Welcome to LitMedia!",
      "subtitle": "Your gateway to the world of books!",
      "description":
          "Discover books through engaging videos\n, podcasts, and interactive content.\nMake reading a habit,\n one story at a time!",
      "color": Color(0xFF242038),
      "imagePath": "images/welcome.png",
    },
    {
      "title": "Discover Books in a New Way!",
      "subtitle": "Explore books through multimedia",
      "description":
          "Not sure what to read next? Watch book \ntrailers, listen to reviews, and dive into \ninteractive content to find your next favorite \nread.",
      "color": Color(0xFF8D86C9),
      "imagePath": "images/discover.png",
    },
    {
      "title": "Build a Reading Habit!",
      "subtitle": "Small Steps, Big Change",
      "description":
          "Set reading goals, track your progress, and \nget daily inspiration to make reading an \nenjoyable habit.",
      "color": Color(0xFF725AC1),
      "imagePath": "images/habit.png",
    },
    {
      "title": "Connect & Share!",
      "subtitle": "Join a community of book lovers",
      "description":
          "Share your favorite books, discuss ideas, and \nget personalized recommendations based on \nyour interests.",
      "color": Color(0xFF242038),
      "imagePath": "images/connect.png",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Onboarding finished → Navigate to Wrapper
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => wrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _pages[index]["title"],
                subtitle: _pages[index]["subtitle"],
                description: _pages[index]["description"],
                color: _pages[index]["color"],
                imagePath: _pages[index]["imagePath"],
                onNext: _nextPage,
                isSecondPage: index == 1,
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final String imagePath;
  final VoidCallback onNext;
  final bool isSecondPage;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.imagePath,
    required this.onNext,
    this.isSecondPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: color,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath,
                  height: screenHeight * 0.4, width: screenWidth * 0.8),
              SizedBox(height: screenHeight * 0.02),
              isSecondPage
                  ? RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Discover Books\n",
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontFamily: "Newsreader",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "in a New Way!",
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontFamily: "Newsreader",
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontFamily: "Newsreader",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontFamily: "Bebas_Neue",
                  letterSpacing: 1.5,
                  color: Color(0xFFF7ECE1),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontFamily: "Lora",
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.05, // Responsive positioning
            right: screenWidth * 0.05,
            child: GestureDetector(
              onTap: onNext,
              child: Icon(Icons.arrow_forward,
                  color: Colors.white, size: screenWidth * 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
