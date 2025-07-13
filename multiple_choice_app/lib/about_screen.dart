// about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu ứng dụng'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trắc Nghiệm Toán Tiểu Học',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ứng dụng giúp học sinh từ lớp 1 đến lớp 5 luyện tập các kỹ năng toán học thông qua các bài trắc nghiệm phù hợp với từng cấp lớp. '
                  'Nội dung bao gồm cộng, trừ, nhân, chia, hình học, giải toán có lời văn và nhiều chủ đề khác.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Quay lại màn hình trước
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
