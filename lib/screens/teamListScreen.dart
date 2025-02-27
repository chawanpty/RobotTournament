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
  String searchQuery = "";
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
                  searchQuery = value.toLowerCase();
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

          // 🔽 ตัวกรองอันดับ
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedRank,
              decoration: const InputDecoration(
                labelText: "กรองตามอันดับ",
                border: OutlineInputBorder(),
              ),
              items:
                  ["1", "2", "3", "ไม่ติดอันดับ", "กำลังแข่งขัน"].map((rank) {
                return DropdownMenuItem<String>(
                  value: rank,
                  child: Text("อันดับ: $rank"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRank = value;
                });
              },
            ),
          ),

          // 📋 รายชื่อทีม (แสดงทุกทีมที่จบการแข่งขันแล้ว)
          Expanded(
            child: Consumer<TeamProvider>(
              builder: (context, provider, child) {
                List<TeamItem> teams = provider.teams.where((team) {
                  if (selectedRank != null) {
                    return team.rank == selectedRank;
                  }
                  return true; // ✅ แสดงทุกทีม ไม่กรองโดยค่าเริ่มต้น
                }).toList();

                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return ListTile(
                      title: Text("ทีม: ${team.teamName}"),
                      subtitle:
                          Text("อันดับ: ${team.rank} | คะแนน: ${team.score}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamDetailScreen(team: team),
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

      // ✅ ปุ่มเพิ่มข้อมูลกลับมา
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
