// about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue
              Color(0xFF98FB98), // Pale green
              Color(0xFFFFE4B5), // Moccasin
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header với cloud decoration
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Icon toán học vui nhộn
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF7B68EE)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.calculate_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '🧮 Trắc Nghiệm Toán Tiểu Học 🎓',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E5BBA),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Nội dung chính với các icon minh họa
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Mô tả ứng dụng
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF8DC), Color(0xFFF0E68C)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Ứng dụng giúp các em học sinh từ lớp 1 đến lớp 5 luyện tập toán học một cách vui vẻ và thú vị! 🌟',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A4A4A),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Các tính năng với icon
                          _buildFeatureItem(
                            icon: '➕',
                            title: 'Cộng - Trừ',
                            description: 'Luyện tập phép tính cơ bản',
                            color: const Color(0xFFFFB6C1),
                          ),

                          const SizedBox(height: 15),

                          _buildFeatureItem(
                            icon: '✖️',
                            title: 'Nhân - Chia',
                            description: 'Thành thạo bảng cửu chương',
                            color: const Color(0xFFDDA0DD),
                          ),

                          const SizedBox(height: 15),

                          _buildFeatureItem(
                            icon: '📐',
                            title: 'Hình học',
                            description: 'Khám phá các hình dạng',
                            color: const Color(0xFF98FB98),
                          ),

                          const SizedBox(height: 15),

                          _buildFeatureItem(
                            icon: '📚',
                            title: 'Toán có lời văn',
                            description: 'Giải quyết bài toán thực tế',
                            color: const Color(0xFFFFA07A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Nút quay lại với thiết kế vui nhộn
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: const Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E5BBA),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}