import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
  DateTime? _selectedDate;
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

    if (widget.team.competitionDate != null &&
        widget.team.competitionDate!.isNotEmpty) {
      _selectedDate =
          DateFormat('dd/MM/yyyy').parse(widget.team.competitionDate!);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.yellowAccent),
              SizedBox(width: 10),
              Text("ยืนยันการแก้ไข", style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            "คุณต้องการบันทึกการแก้ไขหรือไม่?",
            style: TextStyle(color: Colors.white70),
          ),
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
                Navigator.pop(dialogContext);
                _saveEdit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[700],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text("ยืนยัน"),
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
        members: members,
        competitionDate: _selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
            : widget.team.competitionDate,
        imagePath: _image?.path ?? widget.team.imagePath,
      );

      Provider.of<TeamProvider>(context, listen: false).updateTeam(updatedTeam);
      Navigator.pop(context, updatedTeam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("แก้ไขข้อมูลทีม"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(_image!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                            )
                          : const Text("ไม่มีรูปภาพ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text(
                          "📸 เลือกรูปใหม่",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(_teamNameController, "ชื่อทีม"),
                _buildTextField(_robotNameController, "ชื่อหุ่นยนต์"),
                _buildTextField(_member1Controller, "สมาชิก 1"),
                _buildTextField(_member2Controller, "สมาชิก 2"),
                _buildTextField(_member3Controller, "สมาชิก 3"),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate == null
                          ? "📅 เลือกวันที่แข่งขัน"
                          : "📅 วันที่แข่งขัน: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                      style: const TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _showConfirmationDialog,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "บันทึก",
                      style: TextStyle(fontSize: 18),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) => value!.isEmpty ? "กรุณากรอกข้อมูล $label" : null,
      ),
    );
  }
}
