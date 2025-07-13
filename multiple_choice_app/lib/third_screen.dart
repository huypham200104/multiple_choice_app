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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Logo section
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 40),
                  child: const LogoWidget(size: 120),
                ),

                // Grade buttons
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGradeButton(
                        text: 'Lớp 1',
                        backgroundColor: Colors.pink.shade400,
                        onPressed: () {
                          // Handle grade 1
                        },
                      ),
                      const SizedBox(height: 25),
                      _buildGradeButton(
                        text: 'Lớp 2',
                        backgroundColor: Colors.green.shade400,
                        onPressed: () {
                          // Handle grade 2
                        },
                      ),
                      const SizedBox(height: 25),
                      _buildGradeButton(
                        text: 'Lớp 3',
                        backgroundColor: Colors.orange.shade400,
                        onPressed: () {
                          // Handle grade 3
                        },
                      ),
                      const SizedBox(height: 25),
                      _buildGradeButton(
                        text: 'Lớp 4',
                        backgroundColor: Colors.yellow.shade400,
                        onPressed: () {
                          // Handle grade 4
                        },
                      ),
                      const SizedBox(height: 25),
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

                // Back button
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
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
              ],
            ),
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