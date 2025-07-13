import 'package:flutter/material.dart';
import 'background_widget.dart';
import 'helpers/history_helper.dart';
import 'logo_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                Column(
                  children: [
                    const LogoWidget(size: 60),
                    const SizedBox(height: 20),
                    const Text(
                      'Lịch sử làm bài',
                      style: TextStyle(
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
                const SizedBox(height: 20),

                // History list
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: HistoryHelper.getHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Không có lịch sử làm bài',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        );
                      }

                      final history = snapshot.data!;
                      return ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          return _buildHistoryItem(item);
                        },
                      );
                    },
                  ),
                ),

                // Back button
                FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(dynamic item) {
    // Handle both old format (Map with 'history' key) and new format (direct List)
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              Text(
                '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lớp $gradeLevel - Đúng $correctAnswers/$totalQuestions',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${score.toStringAsFixed(1)} điểm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(score),
                ),
              ),
              Icon(
                _getTrophyIcon(score),
                color: _getTrophyColor(score),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTrophyIcon(double score) {
    if (score >= 90) return Icons.emoji_events;
    if (score >= 80) return Icons.star;
    if (score >= 70) return Icons.thumb_up;
    if (score >= 60) return Icons.trending_up;
    return Icons.sentiment_neutral;
  }

  Color _getTrophyColor(double score) {
    if (score >= 90) return Colors.amber;
    if (score >= 80) return Colors.orange;
    if (score >= 70) return Colors.blue;
    if (score >= 60) return Colors.green;
    return Colors.grey;
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.amber.shade700;
    if (score >= 80) return Colors.orange.shade700;
    if (score >= 70) return Colors.blue.shade700;
    if (score >= 60) return Colors.green.shade700;
    return Colors.red.shade700;
  }
}