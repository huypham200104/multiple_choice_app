import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'fouth_screen.dart';

class ThirdScreen extends StatelessWidget {
  final String? userName;

  const ThirdScreen({Key? key, this.userName}) : super(key: key);

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
                      // Logo section - Fixed height
                      SizedBox(
                        height: constraints.maxHeight * 0.2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const LogoWidget(size: 80),
                              const SizedBox(height: 10),
                              Text(
                                'Chào ${userName ?? 'bạn'}!',
                                style: TextStyle(
                                  fontSize: 16,
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
                            ],
                          ),
                        ),
                      ),

                      // Title "Chọn lớp của bạn"
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Chọn lớp của bạn',
                          style: TextStyle(
                            fontSize: 22,
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
                      ),

                      // Grade buttons - Expanded to fill remaining space
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildGradeButton(
                              text: 'Lớp 1',
                              backgroundColor: Colors.blue.shade600,  // Màu xanh dương đậm
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FiveScreen(userName: userName)
                                  ),
                                );
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 2',
                              backgroundColor: Colors.green.shade600,  // Màu xanh lá đậm
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FiveScreen(userName: userName),
                                  ),
                                );
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 3',
                              backgroundColor: Colors.orange.shade600,  // Màu cam đậm
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FiveScreen(userName: userName),
                                  ),
                                );
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 4',
                              backgroundColor: Colors.purple.shade600,  // Màu tím đậm
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FiveScreen(userName: userName),
                                  ),
                                );
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 5',
                              backgroundColor: Colors.red.shade600,  // Màu đỏ đậm
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FiveScreen(userName: userName),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Back button - Fixed height
                      SizedBox(
                        height: constraints.maxHeight * 0.15,
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGradeButton({
    required String text,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}