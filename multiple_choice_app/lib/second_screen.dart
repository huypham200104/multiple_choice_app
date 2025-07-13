import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'third_screen.dart';
import 'setting_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SecondScreen extends StatefulWidget {
  final String? userName;

  const SecondScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String? storedName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'user_data.db'),
      version: 1,
    );
    try {
      final List<Map<String, dynamic>> maps = await database.query('users');
      if (maps.isNotEmpty) {
        setState(() {
          storedName = maps.last['name'] ?? widget.userName; // Lấy bản ghi cuối cùng
        });
      } else {
        setState(() {
          storedName = widget.userName;
        });
      }
    } catch (e) {
      print('Error loading name: $e');
      setState(() {
        storedName = widget.userName;
      });
    } finally {
      await database.close();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                const SizedBox(height: 60),
                Text(
                  'Chào ${storedName ?? widget.userName ?? 'bạn'}!',
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
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      _buildMenuButton(
                        text: 'Bắt đầu',
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ThirdScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildMenuButton(
                        text: 'Cài đặt',
                        backgroundColor: Colors.lightBlue.shade400,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildMenuButton(
                        text: 'Giới thiệu',
                        backgroundColor: Colors.blue.shade600,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27.5),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}