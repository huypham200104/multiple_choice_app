import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.05;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
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
                          const Icon(Icons.calculate, size: 60, color: Colors.deepPurple),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                              children: [
                                const WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.calendar_month, size: 24, color: Colors.orange),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Trắc Nghiệm Toán Tiểu Học',
                                  style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(1, 1),
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

                  // Description Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '🌟 Học Toán Vui Nhộn 🌟',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ứng dụng giúp các em học sinh từ lớp 1 đến lớp 5 luyện tập toán học một cách vui vẻ và thú vị! Với các bài tập từ cơ bản đến nâng cao, hình ảnh minh họa sinh động và giao diện thân thiện.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Features Section
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12, left: 8),
                    child: Text(
                      'Các chuyên đề:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  _buildCategoryCard(
                    Icons.add_circle_outline,
                    "Cộng - Trừ",
                    "Luyện tập phép tính cơ bản từ dễ đến khó",
                    Colors.orange.withOpacity(0.9),
                    Icons.arrow_forward_ios,
                  ),
                  _buildCategoryCard(
                    Icons.close,
                    "Nhân - Chia",
                    "Thành thạo bảng cửu chương và phép tính",
                    Colors.purple.withOpacity(0.9),
                    Icons.arrow_forward_ios,
                  ),
                  _buildCategoryCard(
                    Icons.shape_line,
                    "Hình học",
                    "Nhận biết và tính toán các hình dạng cơ bản",
                    Colors.green.withOpacity(0.9),
                    Icons.arrow_forward_ios,
                  ),
                  _buildCategoryCard(
                    Icons.question_answer_outlined,
                    "Toán có lời văn",
                    "Giải bài toán thực tế với tình huống gần gũi",
                    Colors.blue.withOpacity(0.9),
                    Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 24),
          label: const Text(
            "Quay lại",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      IconData icon,
      String title,
      String subtitle,
      Color color,
      IconData trailingIcon,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: 32, color: color),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Icon(trailingIcon, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        tileColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}