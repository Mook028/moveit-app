import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneSize = 350;
    double offsetX = 120;
    double offsetY = 70;
    double rotateFront = 0.2;
    double rotateBack = -0.2;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HERO SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1B4332),
                    Color(0xFF2D6A4F),
                    Color(0xFF40916C),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LEFT TEXT
                  Flexible(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MoveIT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Track your daily movement\n"
                            "and stay healthy effortlessly.\n\n"
                            "Build better habits, stay consistent,\n"
                            "and take control of your lifestyle with ease.",
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF52B788), Color(0xFF2D6A4F)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                              ),
                              onPressed: () {
                                context.go('/login');
                              },
                              child: Text(
                                'Get Started',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),

                  //  RIGHT MOCK PHONE
                  Flexible(
                    flex: 6,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: rotateBack,
                            child: Image.asset(
                              'assets/images/phone1.png',
                              width: phoneSize,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(offsetX, offsetY),
                            child: Transform.rotate(
                              angle: rotateFront,
                              child: Image.asset(
                                'assets/images/phone2.png',
                                width: phoneSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //  ABOUT SECTION
            Container(
              color: const Color(0xFFD8F3DC),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 LEFT
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ABOUT MOVEIT",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "MoveIT is designed to help you stay active and mindful of your daily lifestyle. "
                          "Track your movements, set achievable goals, and monitor your progress over time. "
                          "With smart insights and personalized tracking, you can better understand your habits "
                          "and continuously improve your health journey.",
                          style: TextStyle(height: 1.6),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Whether you're just starting your fitness journey or maintaining a routine, "
                          "MoveIT helps you stay consistent, motivated, and focused every day.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // 🔹 RIGHT
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 40,
                                offset: const Offset(0, 25),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/phone3.png',
                            width: 250,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 FEATURES ICONS
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FeatureItem(Icons.notifications, "Daily Reminder"),
                  FeatureItem(Icons.calendar_month, "Calendar Tracking"),
                  FeatureItem(Icons.bar_chart, "Progress Overview"),
                  FeatureItem(Icons.favorite, "Health Focus"),
                ],
              ),
            ),

            // 🔥 SCREENSHOT SECTION
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text(
                    "APP PREVIEW",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 40,
                    runSpacing: 40,
                    children: [
                      mockPhone('assets/images/mood.png'),
                      mockPhone('assets/images/tasks.png'),
                      mockPhone('assets/images/stats.png'),
                      mockPhone('assets/images/me.png'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget mockPhone(String imagePath) {
    return Container(
      width: 180,
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}

// 🔥 reusable widget
class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureItem(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Color(0xFF2D6A4F)),
        const SizedBox(height: 10),
        Text(title),
      ],
    );
  }
}
