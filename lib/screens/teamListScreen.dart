import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'addTeamScreen.dart';
import 'teamDetailScreen.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            value: rank, child: Text("อันดับ: $rank")))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRank = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),

                // 🔄 ปุ่มรีเซ็ตตัวกรอง
                ElevatedButton.icon(
                  onPressed: resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("รีเซ็ต"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // 🔽 ตัวเลือกเรียงลำดับตามคะแนน
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedSort,
              decoration: const InputDecoration(
                labelText: "เรียงลำดับตาม",
                border: OutlineInputBorder(),
              ),
              items: ["คะแนนสูงสุด", "อันดับสูงสุด"]
                  .map((String value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
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
                        (selectedRank == null ||
                            team.rank == selectedRank ||
                            (selectedRank == "กำลังแข่งขัน" &&
                                team.status == "กำลังแข่งขัน")))
                    .toList();

                if (selectedSort == "คะแนนสูงสุด") {
                  teams.sort((a, b) => (b.score).compareTo(a.score));
                } else if (selectedSort == "อันดับสูงสุด") {
                  teams.sort((a, b) {
                    int rankA = a.rank == "ไม่ติดอันดับ"
                        ? 999
                        : int.tryParse(a.rank) ?? 999;
                    int rankB = b.rank == "ไม่ติดอันดับ"
                        ? 999
                        : int.tryParse(b.rank) ?? 999;
                    return rankA.compareTo(rankB);
                  });
                }

                return teams.isEmpty
                    ? const Center(child: Text("ไม่มีทีมที่ตรงกับเงื่อนไข"))
                    : ListView.builder(
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          final team = teams[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Text("ทีม: ${team.teamName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "คะแนน: ${team.score} | อันดับ: ${team.rank}"),
                              trailing: const Icon(Icons.arrow_forward_ios),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTeamScreen(category: widget.category)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
