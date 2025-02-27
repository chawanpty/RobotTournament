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
  String? selectedSort = "คะแนนสูงสุด"; // ✅ เพิ่มตัวเลือกเริ่มต้น

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
              items: ["1", "2", "3", "ไม่ติดอันดับ"]
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

          // 🔽 ตัวเลือกเรียงลำดับตามคะแนนหรือโหวต
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedSort,
              decoration: const InputDecoration(
                labelText: "เรียงลำดับตาม",
                border: OutlineInputBorder(),
              ),
              items: ["คะแนนสูงสุด", "โหวตสูงสุด"].map((String value) {
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

          // 📋 รายชื่อทีมที่ผ่านการค้นหา / คัดกรอง / เรียงลำดับ
          Expanded(
            child: Consumer<TeamProvider>(
              builder: (context, provider, child) {
                List<TeamItem> teams = provider.teams
                    .where((team) =>
                        team.category == widget.category &&
                        team.teamName.toLowerCase().contains(searchQuery) &&
                        (selectedRank == null || team.rank == selectedRank))
                    .toList();

                // ✅ เรียงลำดับทีมตามคะแนนหรือโหวต
                if (selectedSort == "คะแนนสูงสุด") {
                  teams.sort((a, b) => b.score.compareTo(a.score));
                } else if (selectedSort == "โหวตสูงสุด") {
                  teams.sort((a, b) => b.votes.compareTo(a.votes));
                }

                if (teams.isEmpty) {
                  return const Center(child: Text("ไม่มีทีมที่ตรงกับเงื่อนไข"));
                }

                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return ListTile(
                      title: Text("ทีม: ${team.teamName}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("อันดับ: ${team.rank}"),
                          Text("คะแนน: ${team.score} | โหวต: ${team.votes}"),
                        ],
                      ),
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
