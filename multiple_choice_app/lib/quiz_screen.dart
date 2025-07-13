import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'logo_widget.dart';
import 'background_widget.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String? userName;
  final int numQuestions;
  final int gradeLevel;

  const QuizScreen({
    Key? key,
    this.userName,
    required this.numQuestions,
    required this.gradeLevel,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> allQuestions = [];
  List<dynamic> selectedQuestions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool? isCorrect;
  bool isLoading = true;
  int correctAnswerIndex = -1;
  int correctAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      String fileName = 'assets/questions/class${widget.gradeLevel}.json';
      final String response = await rootBundle.loadString(fileName);
      final dynamic jsonData = jsonDecode(response);

      List<dynamic> data;
      if (jsonData is List) {
        data = jsonData;
      } else if (jsonData is Map<String, dynamic>) {
        data = jsonData['questions'] ?? [];
      } else {
        throw Exception("Invalid JSON format");
      }

      setState(() {
        allQuestions = data;
        selectedQuestions = _selectRandomQuestions(widget.numQuestions);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải câu hỏi: $e')),
      );
    }
  }

  List<dynamic> _selectRandomQuestions(int count) {
    final random = Random();
    final List<dynamic> shuffled = List.from(allQuestions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  void _handleAnswer(int index) {
    if (selectedAnswerIndex != null) return;

    setState(() {
      selectedAnswerIndex = index;
      correctAnswerIndex = selectedQuestions[currentQuestionIndex]['answer'];
      isCorrect = index == correctAnswerIndex;

      if (isCorrect == true) {
        correctAnswersCount++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < selectedQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isCorrect = null;
        correctAnswerIndex = -1;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    double score = (correctAnswersCount / widget.numQuestions) * 100;
    _saveQuizHistory(score);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          userName: widget.userName,
          gradeLevel: widget.gradeLevel,
          correctAnswers: correctAnswersCount,
          totalQuestions: widget.numQuestions,
          score: score,
        ),
      ),
    );
  }

  Future<void> _saveQuizHistory(double score) async {
    try {
      // Lấy thư mục documents của app và tạo file my_history.json
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_history.json');

      // Tạo dữ liệu kết quả mới
      final newResult = {
        'userName': widget.userName ?? 'Ẩn danh',
        'gradeLevel': widget.gradeLevel,
        'correctAnswers': correctAnswersCount,
        'totalQuestions': widget.numQuestions,
        'score': double.parse(score.toStringAsFixed(1)),
        'timestamp': DateTime.now().toIso8601String(),
      };

      List<dynamic> history = [];

      // Đọc dữ liệu cũ nếu file tồn tại
      if (await file.exists()) {
        try {
          final String existingData = await file.readAsString();
          if (existingData.isNotEmpty) {
            final dynamic jsonData = jsonDecode(existingData);
            if (jsonData is List) {
              history = jsonData;
            } else if (jsonData is Map && jsonData['history'] != null) {
              history = jsonData['history'];
            }
          }
        } catch (e) {
          print('Lỗi khi đọc file lịch sử cũ: $e');
          history = [];
        }
      }

      // Thêm kết quả mới vào đầu danh sách
      history.insert(0, newResult);

      // Giới hạn số lượng lịch sử (giữ 100 kết quả gần nhất)
      if (history.length > 100) {
        history = history.take(100).toList();
      }

      // Lưu vào file my_history.json
      final String jsonString = jsonEncode(history);
      await file.writeAsString(jsonString);

      print('Đã lưu lịch sử vào my_history.json: ${widget.userName}, Lớp ${widget.gradeLevel}, Điểm: $score');
      print('Đường dẫn file: ${file.path}');
    } catch (e) {
      print('Lỗi khi lưu lịch sử: $e');
      // Hiển thị thông báo lỗi cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu lịch sử: $e')),
      );
    }
  }

  Color _getAnswerColor(int index) {
    if (selectedAnswerIndex == null) {
      return Colors.white;
    }

    if (index == correctAnswerIndex) {
      return Colors.green;
    } else if (index == selectedAnswerIndex && index != correctAnswerIndex) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Color _getAnswerTextColor(int index) {
    if (selectedAnswerIndex == null) {
      return Colors.blue;
    }

    if (index == correctAnswerIndex || (index == selectedAnswerIndex && index != correctAnswerIndex)) {
      return Colors.white;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Reduced padding
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                // Header section
                Column(
                  children: [
                    const LogoWidget(size: 60), // Reduced size
                    const SizedBox(height: 10),
                    Text(
                      'Chào ${widget.userName ?? 'bạn'}!',
                      style: const TextStyle(
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.w600,
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
                const SizedBox(height: 10),

                // Main content with SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedQuestions.isNotEmpty)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Question card
                              Container(
                                padding: const EdgeInsets.all(12), // Reduced padding
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Lớp ${widget.gradeLevel} - Câu ${currentQuestionIndex + 1}/${selectedQuestions.length}',
                                          style: TextStyle(
                                            fontSize: 14, // Reduced font size
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Text(
                                          'Đúng: $correctAnswersCount',
                                          style: TextStyle(
                                            fontSize: 12, // Reduced font size
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    LinearProgressIndicator(
                                      value: (currentQuestionIndex + 1) / selectedQuestions.length,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      selectedQuestions[currentQuestionIndex]['question'],
                                      style: TextStyle(
                                        fontSize: 18, // Reduced font size
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              // Answer options
                              ...List.generate(
                                selectedQuestions[currentQuestionIndex]['options'].length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0), // Reduced padding
                                  child: GestureDetector(
                                    onTap: () => _handleAnswer(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(12.0), // Reduced padding
                                      decoration: BoxDecoration(
                                        color: _getAnswerColor(index),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getAnswerColor(index) == Colors.white
                                              ? Colors.blue.shade300
                                              : Colors.transparent,
                                          width: 1.5, // Reduced border width
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 3,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30, // Reduced size
                                            height: 30, // Reduced size
                                            decoration: BoxDecoration(
                                              color: _getAnswerTextColor(index) == Colors.white
                                                  ? Colors.white.withOpacity(0.3)
                                                  : Colors.blue.shade100,
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: _getAnswerTextColor(index),
                                                width: 1.5, // Reduced border width
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                String.fromCharCode(65 + index),
                                                style: TextStyle(
                                                  fontSize: 14, // Reduced font size
                                                  fontWeight: FontWeight.bold,
                                                  color: _getAnswerTextColor(index),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10), // Reduced spacing
                                          Expanded(
                                            child: Text(
                                              selectedQuestions[currentQuestionIndex]['options'][index],
                                              style: TextStyle(
                                                fontSize: 16, // Reduced font size
                                                fontWeight: FontWeight.w500,
                                                color: _getAnswerTextColor(index),
                                              ),
                                            ),
                                          ),
                                          if (selectedAnswerIndex != null)
                                            Icon(
                                              index == correctAnswerIndex
                                                  ? Icons.check_circle
                                                  : (index == selectedAnswerIndex ? Icons.cancel : null),
                                              color: _getAnswerTextColor(index),
                                              size: 20, // Reduced icon size
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Feedback and next button
                              if (selectedAnswerIndex != null) ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(10), // Reduced padding
                                  decoration: BoxDecoration(
                                    color: isCorrect == true ? Colors.green.shade100 : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isCorrect == true ? Colors.green : Colors.red,
                                      width: 1.5, // Reduced border width
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isCorrect == true ? Icons.check_circle : Icons.cancel,
                                        color: isCorrect == true ? Colors.green : Colors.red,
                                        size: 18, // Reduced icon size
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isCorrect == true ? 'Chính xác!' : 'Sai rồi!',
                                        style: TextStyle(
                                          fontSize: 14, // Reduced font size
                                          fontWeight: FontWeight.bold,
                                          color: isCorrect == true ? Colors.green.shade800 : Colors.red.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _nextQuestion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade600,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12), // Reduced padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    currentQuestionIndex < selectedQuestions.length - 1
                                        ? 'Câu tiếp theo'
                                        : 'Xem kết quả',
                                    style: const TextStyle(
                                      fontSize: 14, // Reduced font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Back button
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.white,
                    mini: true, // Smaller button
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.blue.shade600,
                      size: 24, // Reduced icon size
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
}