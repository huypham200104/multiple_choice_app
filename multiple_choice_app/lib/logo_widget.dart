import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showBackground;

  const LogoWidget({
    Key? key,
    this.size = 120,
    this.showBackground = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debug: In ra path để kiểm tra
    print('🔍 Trying to load: assets/images/logo.png');

    return Container(
      width: size,
      height: size,
      decoration: showBackground ? BoxDecoration(
        color: Colors.lightBlue.shade300,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error loading logo: $error');
            print('📁 Make sure file exists at: assets/images/logo.png');
            print('📝 Check pubspec.yaml has: assets: - assets/images/');

            // Hiển thị fallback với thông báo rõ ràng
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: size * 0.25,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Logo không\ntìm thấy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: size * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Kiểm tra:\n• File tồn tại\n• pubspec.yaml',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: size * 0.06,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Fallback logo nếu không load được ảnh
  Widget _buildFallbackLogo() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: 10,
            left: 15,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 15,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main character
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Fox character
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade600,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      // Ears
                      Positioned(
                        top: 2,
                        left: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      // Eyes
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Nose
                      Positioned(
                        top: 20,
                        left: 22,
                        child: Container(
                          width: 4,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Chalkboard
                Container(
                  width: 35,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.brown, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '2+1=3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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