import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';

class FiveScreen extends StatelessWidget {
  final String? userName;

  const FiveScreen({Key? key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header with logo and greeting
                Column(
                  children: [
                    const LogoWidget(size: 80),
                    const SizedBox(height: 20),
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

                // Main content area - Vertical number boxes
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Thêm dòng chữ "Chọn gói câu hỏi"
                        Text(
                          'Chọn gói câu hỏi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                        const SizedBox(height: 30), // Khoảng cách giữa tiêu đề và các ô số

                        // Các ô số 10, 20, 30
                        _buildNumberBox(number: '10'),
                        const SizedBox(height: 20),
                        _buildNumberBox(number: '20'),
                        const SizedBox(height: 20),
                        _buildNumberBox(number: '30'),
                      ],
                    ),
                  ),
                ),

                // Back button
                SizedBox(
                  height: 60,
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
        ),
      ),
    );
  }

  Widget _buildNumberBox({required String number}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}