// main_screen.dart
import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'second_screen.dart';
import 'helpers/database_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Sử dụng singleton
  late AnimationController _bounceController;
  late AnimationController _rotationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _loadSavedName();

    // Khởi tạo animations
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _bounceController.forward();
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bounceController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedName() async {
    try {
      final name = await _dbHelper.getUserName();
      if (name != null && mounted) {
        setState(() {
          _nameController.text = name;
        });
        print('Loaded name successfully: $name');
      }
    } catch (e) {
      print('Error loading name: $e');
    }
  }

  Future<void> _saveName(String name) async {
    try {
      await _dbHelper.insertUserName(name);
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
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Logo và tiêu đề với animation
                        AnimatedBuilder(
                          animation: _bounceAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _bounceAnimation.value,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(35),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 25,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          blurRadius: 15,
                                          offset: const Offset(0, -5),
                                        ),
                                      ],
                                    ),
                                    child: AnimatedBuilder(
                                      animation: _rotationAnimation,
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: _rotationAnimation.value * 0.1,
                                          child: const LogoWidget(size: 120),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.35),
                                          Colors.white.withOpacity(0.2),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '🌟 Siêu Toán Nhí 🌟',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(0, 3),
                                            blurRadius: 6,
                                            color: Colors.black.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Form nhập tên với thiết kế đáng yêu hơn
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '👋 ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Tên bạn là gì?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.98),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Color(0xFF4CAF50).withOpacity(0.3),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 8),
                                    blurRadius: 20,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    offset: const Offset(0, -2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                                decoration: const InputDecoration(
                                  hintText: '✨ Nhập tên của bạn ✨',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF2E7D32),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4CAF50).withOpacity(0.4),
                                    offset: const Offset(0, 8),
                                    blurRadius: 20,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
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
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '💾 ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const Text(
                                      'Lưu và Tiếp tục',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
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