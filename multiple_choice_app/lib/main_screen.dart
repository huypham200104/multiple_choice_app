import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'second_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _nameController = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadSavedName();
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
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
          );
        },
        version: 1,
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _loadSavedName() async {
    if (_database == null) await _initDatabase();
    try {
      final List<Map<String, dynamic>> maps = await _database!.query('users');
      if (maps.isNotEmpty) {
        setState(() {
          _nameController.text = maps.last['name'] ?? '';
        });
        print('Loaded name successfully: ${maps.last['name']}');
      }
    } catch (e) {
      print('Error loading name: $e');
    }
  }

  Future<void> _saveName(String name) async {
    if (_database == null) await _initDatabase();
    try {
      await _database!.insert(
        'users',
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Saved name successfully: $name');
    } catch (e) {
      print('Error saving name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Logo và tiêu đề
                      Column(
                        children: [
                          const LogoWidget(size: 120),
                          const SizedBox(height: 40),
                          Text(
                            'Siêu Toán Nhí',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Form nhập tên
                      Column(
                        children: [
                          Text(
                            'Tên bạn là ?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
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
                                  offset: const Offset(0, 2),
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
                                hintText: 'Tên bạn',
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
                                String name = _nameController.text.trim();
                                if (name.isNotEmpty) {
                                  await _saveName(name);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SecondScreen(userName: name)),
                                  );
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
                                'Lưu',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Spacer để đẩy content lên
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}