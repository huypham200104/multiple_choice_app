import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'quiz_screen.dart';

class FiveScreen extends StatelessWidget {
  final String? userName;
  final int gradeLevel;

  const FiveScreen({super.key, this.userName, required this.gradeLevel});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24.0 : 16.0,
                  vertical: isTablet ? 16.0 : 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header với hiệu ứng gradient và shadow
                    Container(
                      padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Logo với hiệu ứng bounce
                          Container(
                            padding: EdgeInsets.all(isTablet ? 8.0 : 6.0),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.yellow.shade300,
                                  Colors.orange.shade400,
                                  Colors.red.shade300,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.4),
                                  blurRadius: 8.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            child: LogoWidget(size: isTablet ? 32.0 : 28.0),
                          ),
                          SizedBox(width: isTablet ? 16.0 : 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Lời chào vui vẻ
                                Text(
                                  '👋 Chào ${userName ?? 'bạn nhỏ'}!',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18.0 : 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 2.0,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                // Badge lớp học
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 12.0 : 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade400,
                                        Colors.pink.shade400,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: 4.0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '📚 Lớp $gradeLevel',
                                    style: TextStyle(
                                      fontSize: isTablet ? 12.0 : 10.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 24.0 : 20.0),

                    // Title section với hiệu ứng
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '🎯 ',
                              style: TextStyle(fontSize: isTablet ? 24.0 : 20.0),
                            ),
                            Text(
                              'Chọn độ khó',
                              style: TextStyle(
                                fontSize: isTablet ? 24.0 : 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2.0,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16.0 : 12.0,
                            vertical: isTablet ? 8.0 : 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            '✨ Hãy chọn số câu hỏi phù hợp với bạn nhé!',
                            style: TextStyle(
                              fontSize: isTablet ? 14.0 : 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 24.0 : 20.0),

                    // Difficulty Options với hiệu ứng gradient đẹp
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildDifficultyOption(
                              context: context,
                              emoji: '🌟',
                              title: 'Dễ dàng',
                              subtitle: 'Khởi động nhẹ nhàng',
                              number: 10,
                              colors: [Colors.green.shade400, Colors.teal.shade400],
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(height: isTablet ? 16.0 : 12.0),
                          Expanded(
                            child: _buildDifficultyOption(
                              context: context,
                              emoji: '🚀',
                              title: 'Thú vị',
                              subtitle: 'Phiêu lưu cùng toán học',
                              number: 20,
                              colors: [Colors.blue.shade400, Colors.indigo.shade400],
                              isTablet: isTablet,
                            ),
                          ),
                          SizedBox(height: isTablet ? 16.0 : 12.0),
                          Expanded(
                            child: _buildDifficultyOption(
                              context: context,
                              emoji: '🏆',
                              title: 'Siêu thách thức',
                              subtitle: 'Cho các cao thủ nhí',
                              number: 30,
                              colors: [Colors.orange.shade400, Colors.red.shade400],
                              isTablet: isTablet,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 20.0 : 16.0),

                    // Back Button với hiệu ứng đẹp
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20.0 : 16.0,
                              vertical: isTablet ? 8.0 : 6.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: isTablet ? 16.0 : 14.0,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  'Quay lại',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 16.0 : 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyOption({
    required BuildContext context,
    required String emoji,
    required String title,
    required String subtitle,
    required int number,
    required List<Color> colors,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              userName: userName,
              numQuestions: number,
              gradeLevel: gradeLevel,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors[0].withOpacity(0.25),
              colors[1].withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
          border: Border.all(
            color: colors[0].withOpacity(0.4),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.2),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji container với hiệu ứng
            Container(
              width: isTablet ? 56.0 : 48.0,
              height: isTablet ? 56.0 : 48.0,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    colors[0].withOpacity(0.6),
                    colors[1].withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(isTablet ? 16.0 : 12.0),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withOpacity(0.3),
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(
                    fontSize: isTablet ? 28.0 : 24.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: isTablet ? 16.0 : 12.0),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 18.0 : 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2.0,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isTablet ? 12.0 : 11.0,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Number badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12.0 : 8.0,
                vertical: isTablet ? 6.0 : 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: isTablet ? 18.0 : 16.0,
                  fontWeight: FontWeight.bold,
                  color: colors[0],
                ),
              ),
            ),
            SizedBox(width: isTablet ? 12.0 : 8.0),

            // Arrow icon
            Container(
              padding: EdgeInsets.all(isTablet ? 8.0 : 6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: isTablet ? 18.0 : 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}