import 'package:flutter/material.dart';

void main() {
  runApp(const MoveItApp());
}

class MoveItApp extends StatelessWidget {
  const MoveItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // รายการท่าออกกำลังกาย
  List<String> workouts = ["Push Up", "Sit Up", "Squat", "Plank"];

  // ฟังก์ชันแสดง Dialog
  void _showAddWorkoutDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Workout"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter workout name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    workouts.add(controller.text);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoveIT')),

      // แสดงรายการ
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(workouts[index]),
            leading: const Icon(Icons.fitness_center),
          );
        },
      ),

      // ปุ่ม +
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWorkoutDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
