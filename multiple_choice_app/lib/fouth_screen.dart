import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'quiz_screen.dart';

class FiveScreen extends StatelessWidget {
  final String? userName;
  final int gradeLevel;

  const FiveScreen({Key? key, this.userName, required this.gradeLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header compact
                _buildCompactHeader(),
                const SizedBox(height: 16),

                // Main content
                Expanded(
                  child: Column(
                    children: [
                      // Title card
                      _buildTitleCard(),
                      const SizedBox(height: 20),

                      // Game buttons - Grid layout
                      Expanded(
                        child: _buildGameButtonsGrid(context),
                      ),
                    ],
                  ),
                ),

                // Bottom navigation
                _buildBottomNavigation(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Row(
      children: [
        // Logo nhỏ gọn
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.yellow.shade300,
                Colors.orange.shade400,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const LogoWidget(size: 40),
        ),
        const SizedBox(width: 16),

        // Thông tin người dùng
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào ${userName ?? 'bạn nhỏ'}! 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lớp $gradeLevel',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.purple.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🎯 Chọn độ khó',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy chọn số câu hỏi phù hợp với bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameButtonsGrid(BuildContext context) {
    return Column(
      children: [
        // Button 1: Dễ dàng - 10 câu
        Expanded(
          child: _buildModernGameButton(
            context: context,
            number: 10,
            emoji: '🌟',
            title: 'Dễ dàng',
            subtitle: 'Khởi động nhẹ nhàng',
            primaryColor: Colors.green.shade400,
            secondaryColor: Colors.teal.shade300,
          ),
        ),
        const SizedBox(height: 12),

        // Button 2: Thú vị - 20 câu
        Expanded(
          child: _buildModernGameButton(
            context: context,
            number: 20,
            emoji: '🚀',
            title: 'Thú vị',
            subtitle: 'Phiêu lưu cùng toán học',
            primaryColor: Colors.blue.shade400,
            secondaryColor: Colors.indigo.shade300,
          ),
        ),
        const SizedBox(height: 12),

        // Button 3: Siêu thách thức - 30 câu
        Expanded(
          child: _buildModernGameButton(
            context: context,
            number: 30,
            emoji: '🏆',
            title: 'Siêu thách thức',
            subtitle: 'Cho các cao thủ nhí',
            primaryColor: Colors.orange.shade400,
            secondaryColor: Colors.red.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildModernGameButton({
    required BuildContext context,
    required int number,
    required String emoji,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left side - Emoji and number
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$number',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Right side - Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$number câu hỏi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}