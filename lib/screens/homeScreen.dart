import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import 'teamListScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"name": "หุ่นยนต์ต่อสู้", "icon": Icons.sports_mma, "color": Colors.red},
      {
        "name": "หุ่นยนต์วิ่งแข่ง",
        "icon": Icons.directions_run,
        "color": Colors.green
      },
      {
        "name": "หุ่นยนต์ยิงเป้า",
        "icon": Icons.sports_esports,
        "color": Colors.blue
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("เลือกประเภทการแข่งขัน"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Provider.of<TeamProvider>(context, listen: false)
                  .loadTeams(category: category["name"]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TeamListScreen(category: category["name"]),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: category["color"],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category["icon"], color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    category["name"],
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
