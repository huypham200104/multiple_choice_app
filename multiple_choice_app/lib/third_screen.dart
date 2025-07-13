import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

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
                        child: const Center(
                          child: LogoWidget(size: 120),
                        ),
                      ),

                      // Grade buttons - Expanded to fill remaining space
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildGradeButton(
                              text: 'Lớp 1',
                              backgroundColor: Colors.pink.shade400,
                              onPressed: () {
                                // Handle grade 1
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 2',
                              backgroundColor: Colors.green.shade400,
                              onPressed: () {
                                // Handle grade 2
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 3',
                              backgroundColor: Colors.orange.shade400,
                              onPressed: () {
                                // Handle grade 3
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 4',
                              backgroundColor: Colors.yellow.shade400,
                              onPressed: () {
                                // Handle grade 4
                              },
                            ),
                            _buildGradeButton(
                              text: 'Lớp 5',
                              backgroundColor: Colors.grey.shade300,
                              onPressed: () {
                                // Handle grade 5
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