import 'package:flutter/material.dart';
import 'background_widget.dart';
import 'helpers/history_helper.dart';
import 'logo_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header với thiết kế trẻ em
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.history_edu,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            '📊 Lịch sử làm bài',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E5BBA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Xem lại thành tích học tập của bạn! 🌟',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // History list
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: HistoryHelper.getHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4A90E2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Đang tải lịch sử...',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE4B5).withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.sentiment_neutral,
                                    size: 60,
                                    color: Color(0xFF4A90E2),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Chưa có lịch sử làm bài',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E5BBA),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Hãy bắt đầu làm bài để xem kết quả nhé! 🚀',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final history = snapshot.data!;
                      return ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryItem(history[index], index);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Back button với animation
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
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

  Widget _buildHistoryItem(dynamic item, int index) {
    final historyItem = item is Map ? item : (item['history'] != null ? item['history'] : item);

    final userName = historyItem['userName'] ?? 'Ẩn danh';
    final gradeLevel = historyItem['gradeLevel'] ?? 0;
    final correctAnswers = historyItem['correctAnswers'] ?? 0;
    final totalQuestions = historyItem['totalQuestions'] ?? 0;
    final score = (historyItem['score'] ?? 0).toDouble();
    final timestamp = historyItem['timestamp'] != null
        ? DateTime.parse(historyItem['timestamp'])
        : DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.95),
                  Colors.white.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getGradeColor(gradeLevel),
                                  _getGradeColor(gradeLevel).withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E5BBA),
                                  ),
                                ),
                                Text(
                                  'Lớp $gradeLevel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Kết quả với thiết kế thân thiện
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: _getScoreColor(score).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _getScoreColor(score).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đúng $correctAnswers/$totalQuestions câu',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                _getTrophyIcon(score),
                                color: _getTrophyColor(score),
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${score.toStringAsFixed(1)}đ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(score),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: score / 100,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getEncouragementText(score),
                        style: TextStyle(
                          fontSize: 14,
                          color: _getScoreColor(score),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Ranking badge
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getRankingColor(index),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 1: return const Color(0xFFFF6B6B);
      case 2: return const Color(0xFFFFE66D);
      case 3: return const Color(0xFF4ECDC4);
      case 4: return const Color(0xFF45B7D1);
      case 5: return const Color(0xFF96CEB4);
      default: return const Color(0xFF9013FE);
    }
  }

  Color _getRankingColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFFFD700); // Gold
      case 1: return const Color(0xFFC0C0C0); // Silver
      case 2: return const Color(0xFFCD7F32); // Bronze
      default: return const Color(0xFF4A90E2); // Blue
    }
  }

  IconData _getTrophyIcon(double score) {
    if (score >= 90) return Icons.emoji_events;
    if (score >= 80) return Icons.star;
    if (score >= 70) return Icons.thumb_up;
    if (score >= 60) return Icons.trending_up;
    return Icons.sentiment_neutral;
  }

  Color _getTrophyColor(double score) {
    if (score >= 90) return const Color(0xFFFFD700);
    if (score >= 80) return const Color(0xFFFF8C00);
    if (score >= 70) return const Color(0xFF4A90E2);
    if (score >= 60) return const Color(0xFF32CD32);
    return Colors.grey;
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return const Color(0xFFFFD700);
    if (score >= 80) return const Color(0xFFFF8C00);
    if (score >= 70) return const Color(0xFF4A90E2);
    if (score >= 60) return const Color(0xFF32CD32);
    return const Color(0xFFFF6B6B);
  }

  String _getEncouragementText(double score) {
    if (score >= 90) return "🏆 Xuất sắc! Bạn là siêu sao!";
    if (score >= 80) return "🌟 Giỏi lắm! Tiếp tục phát huy!";
    if (score >= 70) return "👍 Tốt đấy! Cố gắng thêm nhé!";
    if (score >= 60) return "💪 Khá rồi! Lần sau sẽ tốt hơn!";
    return "🚀 Đừng bỏ cuộc! Cố gắng lên!";
  }
}