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
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
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
    _loadUserName();
  }

  // Hàm xác định kích thước màn hình
  DeviceType _getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final diagonal = MediaQuery.of(context).size.shortestSide;

    if (diagonal < 600) {
      return DeviceType.phone;
    } else if (diagonal < 800) {
      return DeviceType.tablet7;
    } else {
      return DeviceType.tablet10;
    }
  }

  // Hàm lấy responsive values với tối ưu hóa không gian
  ResponsiveValues _getResponsiveValues(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final availableHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;

    // Tính toán kích thước dựa trên chiều cao available
    final scaleFactor = availableHeight / 800; // Base height 800px
    final clampedScale = scaleFactor.clamp(0.7, 1.3);

    switch (deviceType) {
      case DeviceType.phone:
        return ResponsiveValues(
          logoSize: isLandscape ? (60 * clampedScale) : (80 * clampedScale),
          titleFontSize: isLandscape ? (18 * clampedScale) : (22 * clampedScale),
          greetingFontSize: isLandscape ? (14 * clampedScale) : (16 * clampedScale),
          buttonHeight: isLandscape ? (45 * clampedScale) : (50 * clampedScale),
          buttonFontSize: isLandscape ? (15 * clampedScale) : (17 * clampedScale),
          horizontalPadding: 16,
          verticalSpacing: isLandscape ? (8 * clampedScale) : (12 * clampedScale),
          logoContainerPadding: isLandscape ? (15 * clampedScale) : (20 * clampedScale),
        );
      case DeviceType.tablet7:
        return ResponsiveValues(
          logoSize: isLandscape ? (100 * clampedScale) : (120 * clampedScale),
          titleFontSize: isLandscape ? (24 * clampedScale) : (28 * clampedScale),
          greetingFontSize: isLandscape ? (18 * clampedScale) : (20 * clampedScale),
          buttonHeight: isLandscape ? (55 * clampedScale) : (65 * clampedScale),
          buttonFontSize: isLandscape ? (18 * clampedScale) : (20 * clampedScale),
          horizontalPadding: 24,
          verticalSpacing: isLandscape ? (12 * clampedScale) : (18 * clampedScale),
          logoContainerPadding: isLandscape ? (20 * clampedScale) : (25 * clampedScale),
        );
      case DeviceType.tablet10:
        return ResponsiveValues(
          logoSize: isLandscape ? (120 * clampedScale) : (140 * clampedScale),
          titleFontSize: isLandscape ? (28 * clampedScale) : (32 * clampedScale),
          greetingFontSize: isLandscape ? (20 * clampedScale) : (22 * clampedScale),
          buttonHeight: isLandscape ? (65 * clampedScale) : (75 * clampedScale),
          buttonFontSize: isLandscape ? (20 * clampedScale) : (22 * clampedScale),
          horizontalPadding: 32,
          verticalSpacing: isLandscape ? (15 * clampedScale) : (20 * clampedScale),
          logoContainerPadding: isLandscape ? (25 * clampedScale) : (30 * clampedScale),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsiveValues = _getResponsiveValues(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = screenWidth > screenHeight;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: responsiveValues.horizontalPadding,
              vertical: 8,
            ),
            child: isLandscape
                ? _buildLandscapeLayout(context, responsiveValues)
                : _buildPortraitLayout(context, responsiveValues),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, ResponsiveValues values) {
    return Column(
      children: [
        // Top spacer - flexible
        Flexible(flex: 1, child: SizedBox()),

        // Logo
        _buildLogo(values),

        // Spacing after logo
        SizedBox(height: values.verticalSpacing),

        // Title
        _buildTitle(values),

        // Spacing after title
        SizedBox(height: values.verticalSpacing * 0.8),

        // Greeting
        _buildGreeting(values),

        // Spacing before buttons
        SizedBox(height: values.verticalSpacing * 1.2),

        // Menu buttons
        _buildMenuButtons(values),

        // Bottom spacer - flexible
        Flexible(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, ResponsiveValues values) {
    return Row(
      children: [
        // Left side - Logo and Title
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(values),
              SizedBox(height: values.verticalSpacing),
              _buildTitle(values),
              SizedBox(height: values.verticalSpacing * 0.6),
              _buildGreeting(values),
            ],
          ),
        ),
        SizedBox(width: values.horizontalPadding * 0.5),
        // Right side - Menu buttons
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuButtons(values),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(ResponsiveValues values) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.all(values.logoContainerPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(values.logoContainerPadding * 1.3),
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
            child: LogoWidget(size: values.logoSize),
          ),
        );
      },
    );
  }

  Widget _buildTitle(ResponsiveValues values) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: values.horizontalPadding * 0.75,
        vertical: values.verticalSpacing * 0.6,
      ),
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
          fontSize: values.titleFontSize,
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
    );
  }

  Widget _buildGreeting(ResponsiveValues values) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: values.horizontalPadding * 0.6,
        vertical: values.verticalSpacing * 0.5,
      ),
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
            style: TextStyle(fontSize: values.greetingFontSize * 1.2),
          ),
          Flexible(
            child: Text(
              'Xin chào ${storedName ?? widget.userName ?? 'bạn'}!',
              style: TextStyle(
                fontSize: values.greetingFontSize,
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
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButtons(ResponsiveValues values) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuButton(
            text: '🚀 Bắt đầu học',
            gradientColors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
            ],
            shadowColor: Color(0xFF4CAF50),
            values: values,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThirdScreen(userName: storedName ?? widget.userName),
                ),
              );
            },
          ),
          SizedBox(height: values.verticalSpacing),
          _buildMenuButton(
            text: '⚙️ Cài đặt',
            gradientColors: [
              Color(0xFFFF9800),
              Color(0xFFE65100),
            ],
            shadowColor: Color(0xFFFF9800),
            values: values,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onNameChanged: _updateUserName,
                  ),
                ),
              );

              if (result != null && result is String && result.isNotEmpty) {
                _updateUserName(result);
              }
            },
          ),
          SizedBox(height: values.verticalSpacing),
          _buildMenuButton(
            text: '📖 Giới thiệu',
            gradientColors: [
              Color(0xFF9C27B0),
              Color(0xFF6A1B9A),
            ],
            shadowColor: Color(0xFF9C27B0),
            values: values,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required List<Color> gradientColors,
    required Color shadowColor,
    required ResponsiveValues values,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: values.buttonHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(values.buttonHeight / 2),
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
            borderRadius: BorderRadius.circular(values.buttonHeight / 2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: values.buttonFontSize,
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

// Enum để xác định loại thiết bị
enum DeviceType {
  phone,
  tablet7,
  tablet10,
}

// Class chứa các giá trị responsive
class ResponsiveValues {
  final double logoSize;
  final double titleFontSize;
  final double greetingFontSize;
  final double buttonHeight;
  final double buttonFontSize;
  final double horizontalPadding;
  final double verticalSpacing;
  final double logoContainerPadding;

  ResponsiveValues({
    required this.logoSize,
    required this.titleFontSize,
    required this.greetingFontSize,
    required this.buttonHeight,
    required this.buttonFontSize,
    required this.horizontalPadding,
    required this.verticalSpacing,
    required this.logoContainerPadding,
  });
}