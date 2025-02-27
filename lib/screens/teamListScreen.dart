import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'teamDetailScreen.dart';
import 'addTeamScreen.dart';

class TeamListScreen extends StatefulWidget {
  final String category;
  const TeamListScreen({super.key, required this.category});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  String searchQuery = ""; // ✅ ตัวแปรเก็บค่าค้นหา
  String? selectedRank;
  String? selectedSort = "คะแนนสูงสุด"; // ✅ ค่าเริ่มต้น

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายชื่อทีม - ${widget.category}")),
      body: Column(
        children: [
          // 🔍 ช่องค้นหาทีม
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // ✅ อัปเดตค่าค้นหา
                });
              },
              decoration: InputDecoration(
                labelText: "ค้นหาชื่อทีม",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // 🔽 ตัวกรองอันดับ + ปุ่มรีเซ็ต
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRank,
                    decoration: const InputDecoration(
                      labelText: "กรองตามอันดับ",
                      border: OutlineInputBorder(),
                    ),
                    items: ["1", "2", "3", "ไม่ติดอันดับ", "กำลังแข่งขัน"]
                        .map((rank) => DropdownMenuItem(
                              value: rank,
                              child: Text("อันดับ: $rank"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRank = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedRank = null; // ✅ รีเซ็ตตัวกรอง
                    });
                  },
                  child:
                      const Text("รีเซ็ต", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),

          // 🔽 ตัวเลือกเรียงลำดับ
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedSort,
              decoration: const InputDecoration(
                labelText: "เรียงลำดับตาม",
                border: OutlineInputBorder(),
              ),
              items: ["คะแนนสูงสุด", "อันดับสูงสุด"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSort = newValue!;
                });
              },
            ),
          ),

          // 📋 รายชื่อทีมที่ผ่านตัวกรอง
          Expanded(
            child: Consumer<TeamProvider>(
              builder: (context, provider, child) {
                List<TeamItem> teams = provider.teams.where((team) {
                  bool matchesSearch = team.teamName.toLowerCase().contains(
                      searchQuery); // ✅ ตรวจสอบว่าตรงกับการค้นหาหรือไม่

                  bool matchesRank =
                      selectedRank == null || team.rank == selectedRank;

                  return matchesSearch &&
                      matchesRank; // ✅ ค้นหา + กรองอันดับพร้อมกัน
                }).toList();

                return teams.isEmpty
                    ? const Center(child: Text("ไม่พบทีมที่ตรงกับการค้นหา"))
                    : ListView.builder(
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          final team = teams[index];
                          return ListTile(
                            title: Text("ทีม: ${team.teamName}"),
                            subtitle: Text(
                                "อันดับ: ${team.rank} | คะแนน: ${team.score}"),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TeamDetailScreen(team: team),
                                ),
                              );
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),

      // ✅ ปุ่มเพิ่มข้อมูล
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTeamScreen(category: widget.category),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
