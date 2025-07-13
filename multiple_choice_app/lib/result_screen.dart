import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'background_widget.dart';

class ResultScreen extends StatelessWidget {
  final String? userName;
  final int gradeLevel;
  final int correctAnswers;
  final int totalQuestions;
  final double score;

  const ResultScreen({
    Key? key,
    this.userName,
    required this.gradeLevel,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Compact header
                _buildCompactHeader(),

                // Main content with constrained size
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Result card with compact design
                      _buildCompactResultCard(),

                      // Action buttons
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Column(
      children: [
        const LogoWidget(size: 60),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade300,
                Colors.pink.shade300,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Kết quả của ${userName ?? 'bạn'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactResultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getBorderColor(),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: _getBorderColor().withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji and congratulation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getResultEmoji(),
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _getCongratulationMessage(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _getTrophyColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grade level badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏫', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  'Lớp $gradeLevel',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Score display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getScoreColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _getScoreColor(),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${score.toStringAsFixed(1)} điểm',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: _getScoreColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Đúng $correctAnswers/$totalQuestions câu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Encouragement message
          Text(
            _getEncouragementMessage(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Play again button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade400,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Làm lại',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Home button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Về trang chủ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper functions remain the same
  String _getResultEmoji() {
    if (score >= 90) return '🏆';
    if (score >= 80) return '🌟';
    if (score >= 70) return '👍';
    if (score >= 60) return '😊';
    return '🤗';
  }

  String _getCongratulationMessage() {
    if (score >= 90) return 'Tuyệt vời!';
    if (score >= 80) return 'Rất tốt!';
    if (score >= 70) return 'Giỏi lắm!';
    if (score >= 60) return 'Khá tốt!';
    return 'Cố gắng lên!';
  }

  Color _getTrophyColor() {
    if (score >= 90) return Colors.amber.shade600;
    if (score >= 80) return Colors.orange.shade600;
    if (score >= 70) return Colors.blue.shade600;
    if (score >= 60) return Colors.green.shade600;
    return Colors.grey.shade600;
  }

  Color _getBorderColor() {
    if (score >= 90) return Colors.amber.shade400;
    if (score >= 80) return Colors.orange.shade400;
    if (score >= 70) return Colors.blue.shade400;
    if (score >= 60) return Colors.green.shade400;
    return Colors.grey.shade400;
  }

  Color _getScoreColor() {
    if (score >= 90) return Colors.amber.shade700;
    if (score >= 80) return Colors.orange.shade700;
    if (score >= 70) return Colors.blue.shade700;
    if (score >= 60) return Colors.green.shade700;
    return Colors.red.shade700;
  }

  String _getEncouragementMessage() {
    if (score >= 90) return 'Xuất sắc! Bạn thật là một thiên tài toán học!';
    if (score >= 80) return 'Tuyệt vời! Bạn đã làm rất tốt!';
    if (score >= 70) return 'Khá tốt! Bạn đang tiến bộ rất nhiều!';
    if (score >= 60) return 'Không tệ! Bạn đã cố gắng tốt!';
    return 'Đừng lo lắng! Ôn tập và thử lại, bạn sẽ làm tốt hơn!';
  }
}