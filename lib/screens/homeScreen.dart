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
      {"name": "หุ่นยนต์วิ่งแข่ง", "icon": Icons.directions_run, "color": Colors.green},
      {"name": "หุ่นยนต์ยิงเป้า", "icon": Icons.sports_esports, "color": Colors.blue},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("เลือกประเภทการแข่งขัน")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: categories.map((category) {
            return Card(
              color: category["color"], // ✅ สีพื้นหลังของประเภท
              child: ListTile(
                leading: Icon(category["icon"], color: Colors.white, size: 30), // ✅ ไอคอนของประเภท
                title: Text(category["name"], style: const TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Provider.of<TeamProvider>(context, listen: false)
                      .loadTeams(category: category["name"]); // ✅ โหลดทีมตามประเภท
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamListScreen(category: category["name"]),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
