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
      {"name": "หุ่นยนต์ซ่อมแซม", "icon": Icons.build, "color": Colors.orange},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "เลือกประเภทการแข่งขัน",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InkWell(
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
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: category["color"],
                        boxShadow: [
                          BoxShadow(
                            color: category["color"].withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(3, 5),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category["icon"], color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            category["name"],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
