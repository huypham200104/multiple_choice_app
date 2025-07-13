import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50), // Xanh lá tươi sáng
            Color(0xFF2196F3), // Xanh dương rực rỡ
            Color(0xFF9C27B0), // Tím hồng vui tươi
            Color(0xFFFF9800), // Cam rực rỡ
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.transparent,
              Colors.white.withOpacity(0.05),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Thêm các hình trang trí nhẹ nhàng
            Positioned(
              top: 50,
              right: 30,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 40,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 50,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: 20,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}