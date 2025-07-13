import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'fouth_screen.dart';

class ThirdScreen extends StatefulWidget {
  final String? userName;

  const ThirdScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late List<AnimationController> _buttonControllers;
  late List<Animation<Offset>> _buttonAnimations;

  @override
  void initState() {
    super.initState();

    // Khởi tạo animations
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Khởi tạo animation cho từng nút
    _buttonControllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      );
    });

    _buttonAnimations = _buttonControllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    // Bắt đầu animations
    _fadeController.forward();
    _scaleController.forward();

    // Delay cho từng nút
    for (int i = 0; i < _buttonControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 150)), () {
        if (mounted) {
          _buttonControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    for (var controller in _buttonControllers) {
      controller.dispose();
    }
    super.dispose();
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
                    children: [
                      // Logo section với animation fade
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          height: constraints.maxHeight * 0.25,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
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
                                    child: const LogoWidget(size: 90),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '👋 ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Chào ${widget.userName ?? 'bạn'}!',
                                        style: TextStyle(
                                          fontSize: 18,
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
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Title với animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '🎓 ',
                                  style: TextStyle(fontSize: 22),
                                ),
                                Text(
                                  'Chọn lớp của bạn',
                                  style: TextStyle(
                                    fontSize: 24,
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
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Grade buttons với animation slide từng cái
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < 5; i++)
                              SlideTransition(
                                position: _buttonAnimations[i],
                                child: _buildGradeButton(
                                  text: 'Lớp ${i + 1}',
                                  gradeNumber: i + 1,
                                  backgroundColor: _getGradeColor(i + 1),
                                  emoji: _getGradeEmoji(i + 1),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FiveScreen(
                                          userName: widget.userName,
                                          gradeLevel: i + 1,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Back button với animation
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          height: constraints.maxHeight * 0.12,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.9),
                                    Colors.white.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFF2196F3),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 1:
        return Color(0xFF4CAF50); // Xanh lá
      case 2:
        return Color(0xFF2196F3); // Xanh dương
      case 3:
        return Color(0xFFFF9800); // Cam
      case 4:
        return Color(0xFF9C27B0); // Tím
      case 5:
        return Color(0xFFF44336); // Đỏ
      default:
        return Colors.blue;
    }
  }

  String _getGradeEmoji(int grade) {
    switch (grade) {
      case 1:
        return '🌱';
      case 2:
        return '🌿';
      case 3:
        return '🌳';
      case 4:
        return '🌟';
      case 5:
        return '🏆';
      default:
        return '📚';
    }
  }

  Widget _buildGradeButton({
    required String text,
    required int gradeNumber,
    required Color backgroundColor,
    required String emoji,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.8),
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
              color: backgroundColor.withOpacity(0.4),
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
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 22,
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
            ],
          ),
        ),
      ),
    );
  }
}