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
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: resetFilters,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
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

                // ✅ เรียงลำดับตามคะแนนจากมากไปน้อย
                teams.sort((a, b) => b.score.compareTo(a.score));

                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text("ทีม: ${team.teamName}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("คะแนน: ${team.score} | อันดับ: ${team.rank}"),
                            Text("สถานะ: ${team.status}"),
                          ],
                        ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddTeamScreen(category: widget.category)),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("เพิ่มทีม"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
