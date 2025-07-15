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

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

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

    _fadeController.forward();
    _scaleController.forward();

    for (int i = 0; i < _buttonControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 150)), () {
        if (mounted) _buttonControllers[i].forward();
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
              final bool isSmallScreen = constraints.maxHeight < 600;
              final double logoSize = isSmallScreen ? 60 : 80;
              final double buttonHeight = isSmallScreen ? 50 : 60;
              final double buttonWidth = isSmallScreen ? 200 : 250;
              final double titleFontSize = isSmallScreen ? 20 : 24;
              final double buttonFontSize = isSmallScreen ? 18 : 22;

              return Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Logo and greeting
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
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
                              child: LogoWidget(size: logoSize),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.15),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Chào ${widget.userName ?? 'bạn'}! 👋',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.35),
                              Colors.white.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'Chọn lớp của bạn 🎓',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Buttons
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          for (int i = 0; i < 5; i++)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 6 : 8),
                              child: SlideTransition(
                                position: _buttonAnimations[i],
                                child: _buildGradeButton(
                                  text: 'Lớp ${i + 1}',
                                  gradeNumber: i + 1,
                                  backgroundColor: _getGradeColor(i + 1),
                                  emoji: _getGradeEmoji(i + 1),
                                  buttonHeight: buttonHeight,
                                  buttonWidth: buttonWidth,
                                  buttonFontSize: buttonFontSize,
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
                            ),
                        ],
                      ),
                    ),

                    // Back button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGradeButton({
    required String text,
    required int gradeNumber,
    required Color backgroundColor,
    required String emoji,
    required double buttonHeight,
    required double buttonWidth,
    required double buttonFontSize,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: Colors.white.withOpacity(0.4),
              width: 2,
            ),
          ),
          elevation: 5,
          shadowColor: backgroundColor.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: buttonFontSize)),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 1: return Color(0xFF4CAF50);
      case 2: return Color(0xFF2196F3);
      case 3: return Color(0xFFFF9800);
      case 4: return Color(0xFF9C27B0);
      case 5: return Color(0xFFF44336);
      default: return Colors.blue;
    }
  }

  String _getGradeEmoji(int grade) {
    switch (grade) {
      case 1: return '🌱';
      case 2: return '🌿';
      case 3: return '🌳';
      case 4: return '🌟';
      case 5: return '🏆';
      default: return '📚';
    }
  }
}