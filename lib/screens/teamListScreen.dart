import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'addTeamScreen.dart';
import 'teamDetailScreen.dart';
import 'dart:io';

class TeamListScreen extends StatefulWidget {
  final String category;

  const TeamListScreen({super.key, required this.category});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  String searchQuery = "";
  String? selectedRank;
  String selectedSort = "คะแนนสูงสุด";

  void resetFilters() {
    setState(() {
      searchQuery = "";
      selectedRank = null;
      selectedSort = "คะแนนสูงสุด";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "รายชื่อทีม - ${widget.category}",
          style: const TextStyle(
            color: Colors.white, // ✅ ทำให้ข้อความ AppBar ชัดเจนขึ้น
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            Colors.black.withOpacity(0.8), // ✅ เพิ่มความเข้มของพื้นหลัง
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.white), // ✅ ทำให้ไอคอน Back เป็นสีขาว
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80), // Space for AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                style: const TextStyle(
                    color: Colors.white), // ✅ สีข้อความให้ชัดเจน
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  hintText: "🔍 ค้นหาชื่อทีม",
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedRank,
                      dropdownColor: Colors.blueGrey[900],
                      decoration: InputDecoration(
                        labelText: "กรองตามอันดับ",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ["1", "2", "3", "ไม่ติดอันดับ", "กำลังแข่งขัน"]
                          .map((rank) => DropdownMenuItem(
                              value: rank,
                              child: Text("อันดับ: $rank",
                                  style: const TextStyle(color: Colors.white))))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRank = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: resetFilters,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text("รีเซ็ต"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<TeamProvider>(
                builder: (context, provider, child) {
                  List<TeamItem> teams = provider.teams
                      .where((team) =>
                          team.category == widget.category &&
                          team.teamName.toLowerCase().contains(searchQuery) &&
                          (selectedRank == null ||
                              team.rank == selectedRank ||
                              (selectedRank == "กำลังแข่งขัน" &&
                                  team.status == "กำลังแข่งขัน")))
                      .toList();

                  teams.sort((a, b) => b.score.compareTo(a.score));

                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return Card(
                        color: Colors.black87,
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white10,
                            radius: 30,
                            child: team.imagePath.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.file(File(team.imagePath),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover),
                                  )
                                : Image.asset("assets/robot_placeholder.png",
                                    height: 50, width: 50),
                          ),
                          title: Text(
                            "ทีม: ${team.teamName}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.cyanAccent),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "🏆 อันดับ: ${team.rank}   ⭐ คะแนน: ${team.score}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              Text("📌 สถานะ: ${team.status}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: team.status == "จบการแข่งขัน"
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent)),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white70),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TeamDetailScreen(team: team)),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddTeamScreen(category: widget.category)),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("เพิ่มทีม",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
