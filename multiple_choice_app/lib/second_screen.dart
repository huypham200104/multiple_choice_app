// second_screen.dart
import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'third_screen.dart';
import 'setting_screen.dart';
import 'about_screen.dart';
import 'helpers/database_helper.dart';

class SecondScreen extends StatefulWidget {
  final String? userName;

  const SecondScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> with TickerProviderStateMixin {
  String? storedName;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Sử dụng singleton
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserName();

    // Khởi tạo animations
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    try {
      final name = await _dbHelper.getUserName();
      if (mounted) {
        setState(() {
          storedName = name ?? widget.userName;
        });
      }
    } catch (e) {
      print('Error loading name: $e');
      if (mounted) {
        setState(() {
          storedName = widget.userName;
        });
      }
    }
  }

  void _updateUserName(String newName) {
    setState(() {
      storedName = newName;
    });
    _loadUserName(); // Làm mới tên từ cơ sở dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),

                      // Logo với animation xoay nhẹ
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: const LogoWidget(size: 140),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // Tiêu đề với hiệu ứng đẹp hơn
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
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          '🌟 Siêu Toán Nhí 🌟',
                          style: TextStyle(
                            fontSize: 28,
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

                      const SizedBox(height: 40),

                      // Lời chào với emoji đáng yêu
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                            color: Colors.white.withOpacity(0.5),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '👋 ',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              'Xin chào ${storedName ?? widget.userName ?? 'bạn'}!',
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

                      const SizedBox(height: 50),

                      // Menu buttons với animation slide
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              _buildMenuButton(
                                text: '🚀 Bắt đầu học',
                                gradientColors: [
                                  Color(0xFF4CAF50),
                                  Color(0xFF2E7D32),
                                ],
                                shadowColor: Color(0xFF4CAF50),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ThirdScreen(userName: storedName ?? widget.userName),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 25),
                              _buildMenuButton(
                                text: '⚙️ Cài đặt',
                                gradientColors: [
                                  Color(0xFFFF9800),
                                  Color(0xFFE65100),
                                ],
                                shadowColor: Color(0xFFFF9800),
                                onPressed: () async {
                                  // Truyền callback function vào SettingsScreen
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsScreen(
                                        onNameChanged: _updateUserName,
                                      ),
                                    ),
                                  );

                                  // Nếu có tên mới được trả về, cập nhật
                                  if (result != null && result is String && result.isNotEmpty) {
                                    _updateUserName(result);
                                  }
                                },
                              ),
                              const SizedBox(height: 25),
                              _buildMenuButton(
                                text: '📖 Giới thiệu',
                                gradientColors: [
                                  Color(0xFF9C27B0),
                                  Color(0xFF6A1B9A),
                                ],
                                shadowColor: Color(0xFF9C27B0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required List<Color> gradientColors,
    required Color shadowColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.5),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 25,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.5),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
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
      ),
    );
  }
}