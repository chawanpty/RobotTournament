import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // ✅ นำเข้า fl_chart
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏆 Leaderboard & สถิติการแข่งขัน")),
      body: Consumer<TeamProvider>(
        builder: (context, provider, child) {
          List<TeamItem> sortedTeams = List.from(provider.teams);
          sortedTeams.sort((a, b) => b.score.compareTo(a.score));

          // ✅ แยกทีมตามประเภทการแข่งขัน
          Map<String, List<TeamItem>> categoryTeams = {};
          for (var team in sortedTeams) {
            categoryTeams.putIfAbsent(team.category, () => []).add(team);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categoryTeams.entries.map((entry) {
                  String category = entry.key;
                  List<TeamItem> teams = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🏆 ประเภท: $category",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...teams.take(5).map((team) => Card(
                            child: ListTile(
                              leading: CircleAvatar(child: Text(team.rank)),
                              title:
                                  Text("${team.teamName} - ${team.robotName}"),
                              subtitle: Text("คะแนน: ${team.score}"),
                            ),
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: teams.map((team) {
                              return BarChartGroupData(
                                x: teams.indexOf(team),
                                barRods: [
                                  BarChartRodData(
                                    toY: team.score.toDouble(),
                                    width: 15,
                                    color: Colors.blue,
                                  )
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) =>
                                      Text("${value.toInt()}"),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < teams.length) {
                                      return Text(teams[index].teamName);
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
