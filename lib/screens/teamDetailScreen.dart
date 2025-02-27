import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'editTeamScreen.dart';
import 'dart:io';

class TeamDetailScreen extends StatelessWidget {
  final TeamItem team;
  const TeamDetailScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ข้อมูลทีม: ${team.teamName}")),
      body: Consumer<TeamProvider>(
        builder: (context, provider, child) {
          final updatedTeam = provider.teams.firstWhere(
            (t) => t.keyID == team.keyID,
            orElse: () => team,
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                updatedTeam.imagePath.isNotEmpty
                    ? Image.file(File(updatedTeam.imagePath), height: 150)
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

                // ✅ ปุ่มให้คะแนน พร้อม Pop-up ยืนยัน
                ElevatedButton(
                  onPressed: () {
                    _showConfirmScoreDialog(context, updatedTeam);
                  },
                  child: Text(
                      "ให้คะแนนทีมนี้ (คะแนนปัจจุบัน: ${updatedTeam.score})"),
                ),

                // ✅ ปุ่มโหวตทีม พร้อม Pop-up ยืนยัน
                ElevatedButton(
                  onPressed: () {
                    _showConfirmVoteDialog(context, updatedTeam);
                  },
                  child:
                      Text("โหวตทีมนี้ (โหวตปัจจุบัน: ${updatedTeam.votes})"),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Colors.yellow, size: 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditTeamScreen(team: updatedTeam),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 30),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, updatedTeam);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showConfirmScoreDialog(BuildContext context, TeamItem team) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("ยืนยันการให้คะแนน"),
          content: const Text("คุณต้องการเพิ่มคะแนนให้ทีมนี้หรือไม่?"),
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
                int newScore = team.score + 10;
                Provider.of<TeamProvider>(context, listen: false)
                    .updateScore(team.keyID!, newScore);
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmVoteDialog(BuildContext context, TeamItem team) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("ยืนยันการโหวต"),
          content: const Text("คุณต้องการโหวตให้ทีมนี้หรือไม่?"),
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
                Provider.of<TeamProvider>(context, listen: false)
                    .updateVotes(team.keyID!);
                Navigator.pop(dialogContext);
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
          title: const Text("ยืนยันการลบ"),
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
