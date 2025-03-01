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
      appBar: AppBar(title: Text("ข้อมูลทีม: ${widget.team.teamName}")),
      body: Consumer<TeamProvider>(
        builder: (context, provider, child) {
          final updatedTeam = provider.teams.firstWhere(
            (t) => t.keyID == widget.team.keyID,
            orElse: () => widget.team,
          );

          bool isFinalized = updatedTeam.status == "จบการแข่งขัน";

          return SingleChildScrollView(
            // ✅ แก้ปัญหาแถบเหลืองด้วย SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  updatedTeam.imagePath.isNotEmpty
                      ? Image.file(File(updatedTeam.imagePath),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover)
                      : const Text("ไม่มีรูปภาพ"),
                  const SizedBox(height: 10),
                  Text("ชื่อทีม: ${updatedTeam.teamName}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("ชื่อหุ่นยนต์: ${updatedTeam.robotName}",
                      style: const TextStyle(fontSize: 16)),
                  Text("ประเภท: ${updatedTeam.category}",
                      style: const TextStyle(fontSize: 16)),
                  Text("สมาชิกทีม: ${updatedTeam.members.join(', ')}",
                      style: const TextStyle(fontSize: 16)),
                  Text("สถานะ: ${updatedTeam.status}",
                      style: const TextStyle(fontSize: 16, color: Colors.blue)),
                  Text(
                      "วันที่แข่งขัน: ${updatedTeam.competitionDate ?? 'ยังไม่กำหนด'}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  if (!isFinalized) ...[
                    TextFormField(
                      controller: _scoreController,
                      decoration: const InputDecoration(labelText: "คะแนนทีม"),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRank,
                      decoration:
                          const InputDecoration(labelText: "จัดอันดับทีม"),
                      items: ["1", "2", "3", "ไม่ติดอันดับ"].map((rank) {
                        return DropdownMenuItem<String>(
                          value: rank,
                          child: Text("อันดับ: $rank"),
                        );
                      }).toList(),
                      onChanged: (String? newRank) {
                        setState(() {
                          selectedRank = newRank;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (!isFinalized) ...[
                    ElevatedButton(
                      onPressed: () {
                        _showConfirmSaveDialog(context, updatedTeam);
                      },
                      child: const Text("บันทึกข้อมูล"),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isFinalized ||
                          updatedTeam.status ==
                              "กำลังแข่งขัน") // ✅ ทีมที่กำลังแข่งขันให้กดแก้ไขได้
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

  void _showConfirmSaveDialog(BuildContext context, TeamItem team) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("ยืนยันการบันทึก"),
          content: const Text("คุณต้องการบันทึกข้อมูลนี้หรือไม่?"),
          actions: [
            TextButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              child: const Text("ยืนยัน"),
              onPressed: () {
                int newScore =
                    int.tryParse(_scoreController.text) ?? team.score;
                Provider.of<TeamProvider>(context, listen: false)
                    .updateTeamData(
                        team.keyID!, newScore, selectedRank ?? "ไม่ติดอันดับ");

                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
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
