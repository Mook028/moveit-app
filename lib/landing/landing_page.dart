import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
              height: 500,
              child: Stack(
                children: [
                  //  1. BACKGROUND
                  Container(
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
                  ),

                  //  2. IMAGE LAYER
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.25,
                      child: Image.asset(
                        'assets/images/fitness.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //  3. OVERLAY
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),

                  // 4. CONTENT
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 80,
                      horizontal: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🔹LEFT TEXT
                        Flexible(
                          flex: 4,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "MoveIT",
                                  style: GoogleFonts.prompt(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Track your daily movement\n"
                                  "and stay healthy effortlessly.\n\n"
                                  "Build better habits, stay consistent,\n"
                                  "and take control of your lifestyle with ease.",
                                  style: GoogleFonts.prompt(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF52B788),
                                        Color(0xFF2D6A4F),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                    ),
                                    onPressed: () {
                                      context.go('/login');
                                    },
                                    child: Text(
                                      'Get Started',
                                      style: GoogleFonts.prompt(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 40),

                        // 🔹 RIGHT PHONE
                        Flexible(
                          flex: 6,
                          child: Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Transform.rotate(
                                  angle: -0.2,
                                  child: Image.asset(
                                    'assets/images/phone1.png',
                                    width: 350,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(120, 70),
                                  child: Transform.rotate(
                                    angle: 0.2,
                                    child: Image.asset(
                                      'assets/images/phone2.png',
                                      width: 350,
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
                        Text(
                          "ABOUT MOVEIT",
                          style: GoogleFonts.prompt(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "MoveIT is designed to help you stay active and mindful of your daily lifestyle. "
                          "Track your movements, set achievable goals, and monitor your progress over time. "
                          "With smart insights and personalized tracking, you can better understand your habits "
                          "and continuously improve your health journey.",
                          style: GoogleFonts.prompt(height: 1.6),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Whether you're just starting your fitness journey or maintaining a routine, "
                          "MoveIT helps you stay consistent, motivated, and focused every day.",
                          style: GoogleFonts.prompt(),
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

            const SizedBox(width: 40),

            // 🔥 FEATURES ICONS
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 40),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FeatureItem(Icons.notifications, "Daily Reminder"),
                  FeatureItem(Icons.calendar_today, "Calendar Tracking"),
                  FeatureItem(Icons.bar_chart, "Progress Overview"),
                  FeatureItem(Icons.favorite, "Health Focus"),
                ],
              ),
            ),

            const SizedBox(width: 40),

            // how to use section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Image.asset('assets/images/phone4.png', width: 250),
                  ),

                  const SizedBox(width: 40),

                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How to Use MoveIT",
                          style: GoogleFonts.prompt(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const StepItem(
                          "1. Choose your mood",
                          "Select how you feel today to personalize your plan.",
                        ),

                        const SizedBox(height: 15),

                        const StepItem(
                          "2. Follow daily tasks",
                          "Complete activities tailored to your energy level.",
                        ),

                        const SizedBox(height: 15),

                        const StepItem(
                          "3. Track your progress",
                          "Monitor your streaks and daily improvements.",
                        ),

                        const SizedBox(height: 15),

                        const StepItem(
                          "4. Stay consistent",
                          "Build healthy habits with reminders and insights.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // How are you feeling today?
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  LEFT (PHONE)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Image.asset('assets/images/mood.png', width: 260),

                        const SizedBox(height: 15),

                        Text(
                          "How are you feeling today?",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 60),

                  //  RIGHT (TEXT)
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.mood,
                          size: 40,
                          color: Color(0xFF2D6A4F),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "How are you feeling today?",
                          style: GoogleFonts.prompt(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Start your day by selecting how you feel. MoveIT uses your mood to personalize activities and recommendations, helping you stay balanced, motivated, and on track with your wellness goals. "
                          "Each mood unlocks tailored tasks designed to match your energy level, so you can stay productive without feeling overwhelmed and gradually build a healthier, more consistent lifestyle.",
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tasks to excirse your body and mind
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 LEFT (TEXT)
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.checklist,
                          size: 40,
                          color: Color(0xFF2D6A4F),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Tasks to excirse your body and mind",
                          style: GoogleFonts.prompt(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Improve your physical and mental well-being with tailored daily tasks that match your energy level. "
                          "Whether it’s a quick workout, mindful meditation, or small productive habits, MoveIT helps you stay "
                          "active, focused, and consistent — turning simple actions into long-term healthy routines.",
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 60),

                  // 🔹 RIGHT (PHONE)
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/tasks2.png',
                          width: 800,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(height: 15),

                        Text(
                          "Tasks",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //How many days have you been exercising?
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  LEFT (PHONE)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Image.asset('assets/images/stats.png', width: 260),

                        const SizedBox(height: 15),

                        Text(
                          "Stats",
                          style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 60),

                  //  RIGHT (TEXT)
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 40,
                          color: Color(0xFF2D6A4F),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "How many days have you been exercising?",
                          style: GoogleFonts.prompt(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Track your exercise consistency and build a stronger routine over time. "
                          "MoveIT helps you visualize how many days you’ve stayed active, giving you a clear view of your progress and motivation to keep going. "
                          "By maintaining your streak and reviewing your activity history, you can stay committed, celebrate small wins, and gradually develop long-term healthy habits.",
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 SCREENSHOT SECTION
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Text(
                    "OUR SCREENSHOT",
                    style: GoogleFonts.prompt(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
        color: Colors.transparent,
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
        Text(title, style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureRow(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFEDE9FE),
          child: Icon(icon, color: Colors.purple),
        ),
        const SizedBox(width: 15),
        Text(title, style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class StepItem extends StatelessWidget {
  final String title;
  final String desc;

  const StepItem(this.title, this.desc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF2D6A4F)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
              ),
              Text(desc, style: GoogleFonts.prompt(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
