import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'background_widget.dart';
import 'logo_widget.dart';

class RenameScreen extends StatefulWidget {
  final String? currentName;

  const RenameScreen({Key? key, this.currentName}) : super(key: key);

  @override
  State<RenameScreen> createState() => _RenameScreenState();
}

class _RenameScreenState extends State<RenameScreen> {
  final TextEditingController _nameController = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
    _initDatabase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _database?.close();
    super.dispose();
  }

  Future<void> _initDatabase() async {
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'user_data.db'),
        version: 1,
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _saveName(String name, BuildContext context) async {
    if (_database == null) await _initDatabase();
    try {
      await _database!.insert(
        'users',
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Saved new name successfully: $name');
      Navigator.pop(context, name); // Use the BuildContext passed to the method
    } catch (e) {
      print('Error saving name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                Column(
                  children: [
                    const LogoWidget(size: 80),
                    const SizedBox(height: 20),
                    Text(
                      'Đổi tên hiển thị',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Name input form
                Column(
                  children: [
                    Text(
                      'Nhập tên mới của bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tên mới',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          String newName = _nameController.text.trim();
                          if (newName.isNotEmpty) {
                            await _saveName(newName, context); // Pass context to _saveName
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Lưu tên mới',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Back button
                SizedBox(
                  height: 60,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.blue.shade600,
                      ),
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
}