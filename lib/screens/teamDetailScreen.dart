import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'editTeamScreen.dart';
import 'dart:io';

class TeamDetailScreen extends StatefulWidget {
  final TeamItem team;
  const TeamDetailScreen({super.key, required this.team});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  final _scoreController = TextEditingController();
  String? selectedRank;

  @override
  void initState() {
    super.initState();
    _scoreController.text = widget.team.score.toString();
    selectedRank = widget.team.rank != "กำลังแข่งขัน" ? widget.team.rank : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลทีม: ${widget.team.teamName}"),
        backgroundColor: Colors.orangeAccent,
      ),
      backgroundColor: Colors.black,
      body: Consumer<TeamProvider>(
        builder: (context, provider, child) {
          final updatedTeam = provider.teams.firstWhere(
            (t) => t.keyID == widget.team.keyID,
            orElse: () => widget.team,
          );

          bool isFinalized = updatedTeam.status == "จบการแข่งขัน";

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "robot-${updatedTeam.teamName}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: updatedTeam.imagePath.isNotEmpty
                          ? Image.file(File(updatedTeam.imagePath),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover)
                          : Image.asset("assets/robot_placeholder.png",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.blueGrey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("🤖 ชื่อทีม:", updatedTeam.teamName),
                          _buildDetailRow(
                              "🛠 ชื่อหุ่นยนต์:", updatedTeam.robotName),
                          _buildDetailRow("📌 ประเภท:", updatedTeam.category),
                          _buildDetailRow("📅 วันที่แข่งขัน:",
                              updatedTeam.competitionDate ?? "ยังไม่กำหนด"),
                          _buildDetailRow("📊 สถานะ:", updatedTeam.status),
                          const SizedBox(height: 10),
                          Text(
                            "สมาชิกทีม",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent),
                          ),
                          ...updatedTeam.members.map((member) => Text(
                              "👤 $member",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isFinalized) ...[
                    TextFormField(
                      controller: _scoreController,
                      decoration: const InputDecoration(
                        labelText: "คะแนนทีม",
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedRank,
                      dropdownColor: Colors.blueGrey[900],
                      decoration: const InputDecoration(
                        labelText: "จัดอันดับทีม",
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(),
                      ),
                      items: ["1", "2", "3", "ไม่ติดอันดับ"].map((rank) {
                        return DropdownMenuItem<String>(
                          value: rank,
                          child: Text("อันดับ: $rank",
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newRank) {
                        setState(() {
                          selectedRank = newRank;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showConfirmSaveDialog(context, updatedTeam);
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text("บันทึก"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isFinalized || updatedTeam.status == "กำลังแข่งขัน")
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditTeamScreen(team: updatedTeam),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text("แก้ไข"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[700],
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, updatedTeam);
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text("ลบ"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  void _showConfirmSaveDialog(BuildContext context, TeamItem team) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("ยืนยันการบันทึก",
              style: TextStyle(color: Colors.white)),
          content: const Text("คุณต้องการบันทึกข้อมูลนี้หรือไม่?",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              child: const Text("ยกเลิก",
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            ElevatedButton(
              onPressed: () {
                int newScore =
                    int.tryParse(_scoreController.text) ?? team.score;
                Provider.of<TeamProvider>(context, listen: false)
                    .updateTeamData(
                        team.keyID!, newScore, selectedRank ?? "ไม่ติดอันดับ");

                Navigator.pop(dialogContext); // ปิด Dialog
                Navigator.pop(context); // กลับไปหน้ารายชื่อทีม
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700]),
              child: const Text("ยืนยัน"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, TeamItem team) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("ยืนยันการลบทีม"),
          content: const Text("คุณต้องการลบทีมนี้หรือไม่?"),
          actions: [
            TextButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: const Text("ลบ"),
              onPressed: () {
                Provider.of<TeamProvider>(context, listen: false)
                    .deleteTeam(team.keyID!);
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
