import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/teamProvider.dart';
import '../model/teamItem.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTeamScreen extends StatefulWidget {
  final String category;
  const AddTeamScreen({super.key, required this.category});

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _robotNameController = TextEditingController();
  final _member1Controller = TextEditingController();
  final _member2Controller = TextEditingController();
  final _member3Controller = TextEditingController();
  DateTime? _selectedDate;
  File? _image;

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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTeam() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      List<String> members = [
        _member1Controller.text,
        _member2Controller.text,
        _member3Controller.text
      ].where((member) => member.isNotEmpty).toList();

      TeamItem newTeam = TeamItem(
        teamName: _teamNameController.text,
        robotName: _robotNameController.text,
        category: widget.category,
        members: members,
        competitionDate: _selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
            : '',
        imagePath: _image?.path ?? '',
      );

      Provider.of<TeamProvider>(context, listen: false).addTeam(newTeam);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เพิ่มชื่อทีม"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.blueGrey[900],
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // 📷 ภาพหุ่นยนต์
                          _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(_image!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                )
                              : const Text(
                                  "ไม่มีรูปภาพ",
                                  style: TextStyle(color: Colors.white),
                                ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _pickImage,
                            child: const Text(
                              "📸 เลือกภาพหุ่นยนต์",
                              style: TextStyle(color: Colors.cyanAccent),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 📝 ฟอร์มกรอกข้อมูล
                          _buildTextField(_teamNameController, "ชื่อทีม"),
                          _buildTextField(_robotNameController, "ชื่อหุ่นยนต์"),
                          _buildCategory(widget.category),
                          _buildTextField(_member1Controller, "สมาชิก 1"),
                          _buildTextField(_member2Controller, "สมาชิก 2"),
                          _buildTextField(_member3Controller, "สมาชิก 3"),

                          // 📅 เลือกวันที่แข่งขัน
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _pickDate,
                            child: Text(
                              _selectedDate == null
                                  ? "📆 เลือกวันที่แข่งขัน"
                                  : "📅 วันที่แข่งขัน: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                              style: const TextStyle(color: Colors.cyanAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 ปุ่มเพิ่มทีม
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[400],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _saveTeam,
                    child: const Text("➕ เพิ่มทีม",
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ ฟังก์ชันสร้างช่องกรอกข้อมูล
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelStyle: const TextStyle(color: Colors.cyanAccent),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // ✅ ฟังก์ชันแสดงประเภทหุ่นยนต์
  Widget _buildCategory(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "ประเภท: $category",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
