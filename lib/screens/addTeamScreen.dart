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
  DateTime? _selectedDate; // 🔥 ตัวแปรเก็บวันที่แข่งขัน
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
            : '', // ✅ บันทึกวันที่แข่งขัน
        imagePath: _image?.path ?? '',
      );

      Provider.of<TeamProvider>(context, listen: false).addTeam(newTeam);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มชื่อทีม")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _image != null ? Image.file(_image!, height: 150) : const Text("ไม่มีรูปภาพ"),
                TextButton(onPressed: _pickImage, child: const Text("เลือกภาพหุ่นยนต์")),
                TextFormField(controller: _teamNameController, decoration: const InputDecoration(labelText: "ชื่อทีม")),
                TextFormField(controller: _robotNameController, decoration: const InputDecoration(labelText: "ชื่อหุ่นยนต์")),
                Text("ประเภท: ${widget.category}"),
                TextFormField(controller: _member1Controller, decoration: const InputDecoration(labelText: "สมาชิก 1")),
                TextFormField(controller: _member2Controller, decoration: const InputDecoration(labelText: "สมาชิก 2")),
                TextFormField(controller: _member3Controller, decoration: const InputDecoration(labelText: "สมาชิก 3")),
                TextButton(
                  onPressed: _pickDate,
                  child: Text(
                    _selectedDate == null 
                        ? "เลือกวันที่แข่งขัน" 
                        : "วันที่แข่งขัน: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _saveTeam, child: const Text("เพิ่มทีม")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
