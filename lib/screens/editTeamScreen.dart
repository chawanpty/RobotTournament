import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'dart:io';

class EditTeamScreen extends StatefulWidget {
  final TeamItem team;
  const EditTeamScreen({super.key, required this.team});

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _teamNameController;
  late TextEditingController _robotNameController;
  late TextEditingController _member1Controller;
  late TextEditingController _member2Controller;
  late TextEditingController _member3Controller;
  File? _image;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.team.teamName);
    _robotNameController = TextEditingController(text: widget.team.robotName);
    _member1Controller = TextEditingController(
        text: widget.team.members.isNotEmpty ? widget.team.members[0] : '');
    _member2Controller = TextEditingController(
        text: widget.team.members.length > 1 ? widget.team.members[1] : '');
    _member3Controller = TextEditingController(
        text: widget.team.members.length > 2 ? widget.team.members[2] : '');

    if (widget.team.imagePath.isNotEmpty) {
      _image = File(widget.team.imagePath);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("ยืนยันการแก้ไข"),
          content: const Text("คุณต้องการบันทึกการแก้ไขหรือไม่?"),
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
                Navigator.pop(dialogContext);
                _saveEdit(); // ✅ บันทึกข้อมูลหลังจากผู้ใช้กดยืนยัน
              },
            ),
          ],
        );
      },
    );
  }

  void _saveEdit() {
    if (_formKey.currentState!.validate()) {
      List<String> members = [
        _member1Controller.text,
        _member2Controller.text,
        _member3Controller.text
      ].where((member) => member.isNotEmpty).toList();

      TeamItem updatedTeam = TeamItem(
        keyID: widget.team.keyID,
        teamName: _teamNameController.text,
        robotName: _robotNameController.text,
        category: widget.team.category,
        members: members, // ✅ บันทึกสมาชิกที่แก้ไข
        imagePath: _image?.path ?? widget.team.imagePath,
      );

      Provider.of<TeamProvider>(context, listen: false).updateTeam(updatedTeam);
      Navigator.pop(
          context, updatedTeam); // ✅ ส่งข้อมูลกลับไปยัง `teamDetailScreen`
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // ✅ ปรับ UI ให้ไม่เกิด Overflow เมื่อคีย์บอร์ดขึ้น
      appBar: AppBar(title: const Text("แก้ไขข้อมูลทีม")),
      body: SingleChildScrollView(
        // ✅ ทำให้สามารถเลื่อนขึ้นลงได้
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _image != null
                      ? Image.file(_image!, height: 150, fit: BoxFit.cover)
                      : const Text("ไม่มีรูปภาพ"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _teamNameController,
                  decoration: const InputDecoration(labelText: "ชื่อทีม"),
                  validator: (value) =>
                      value!.isEmpty ? "กรุณากรอกชื่อทีม" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _robotNameController,
                  decoration: const InputDecoration(labelText: "ชื่อหุ่นยนต์"),
                  validator: (value) =>
                      value!.isEmpty ? "กรุณากรอกชื่อหุ่นยนต์" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _member1Controller,
                  decoration: const InputDecoration(labelText: "สมาชิก 1"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _member2Controller,
                  decoration: const InputDecoration(labelText: "สมาชิก 2"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _member3Controller,
                  decoration: const InputDecoration(labelText: "สมาชิก 3"),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _showConfirmationDialog,
                    child: const Text("บันทึก"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
