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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header with logo and greeting
                Column(
                  children: [
                    const LogoWidget(size: 80),
                    const SizedBox(height: 20),
                    Text(
                      'Kết quả của ${userName ?? 'bạn'}',
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
                  ],
                ),

                // Main content area
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Result card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Trophy icon
                              Icon(
                                _getTrophyIcon(),
                                size: 80,
                                color: _getTrophyColor(),
                              ),
                              const SizedBox(height: 16),

                              // Grade level
                              Text(
                                'Lớp $gradeLevel',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Score display
                              Text(
                                '${score.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(),
                                ),
                              ),
                              Text(
                                'điểm',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Correct answers
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Đúng $correctAnswers/$totalQuestions câu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Performance message
                              Text(
                                _getPerformanceMessage(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Play again button
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context); // Go back to question selection
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text(
                                'Chơi lại',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Home button
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.popUntil(context, (route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              icon: const Icon(Icons.home),
                              label: const Text(
                                'Trang chủ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  IconData _getTrophyIcon() {
    if (score >= 90) return Icons.emoji_events;
    if (score >= 80) return Icons.star;
    if (score >= 70) return Icons.thumb_up;
    if (score >= 60) return Icons.trending_up;
    return Icons.sentiment_neutral;
  }

  Color _getTrophyColor() {
    if (score >= 90) return Colors.amber;
    if (score >= 80) return Colors.orange;
    if (score >= 70) return Colors.blue;
    if (score >= 60) return Colors.green;
    return Colors.grey;
  }

  Color _getScoreColor() {
    if (score >= 90) return Colors.amber.shade700;
    if (score >= 80) return Colors.orange.shade700;
    if (score >= 70) return Colors.blue.shade700;
    if (score >= 60) return Colors.green.shade700;
    return Colors.red.shade700;
  }

  String _getPerformanceMessage() {
    if (score >= 90) return 'Xuất sắc! Bạn đã làm rất tốt! 🎉';
    if (score >= 80) return 'Tốt lắm! Bạn đã hiểu bài rất tốt! 👍';
    if (score >= 70) return 'Khá tốt! Hãy tiếp tục cố gắng! 💪';
    if (score >= 60) return 'Đạt yêu cầu! Bạn có thể làm tốt hơn! 📚';
    return 'Cần cố gắng thêm! Hãy ôn tập và thử lại! 🔥';
  }
}