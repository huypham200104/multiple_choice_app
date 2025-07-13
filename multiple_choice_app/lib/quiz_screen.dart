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

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  List<dynamic> allQuestions = [];
  List<dynamic> selectedQuestions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool? isCorrect;
  bool isLoading = true;
  int correctAnswerIndex = -1;
  int correctAnswersCount = 0;

  // Animation controllers
  late AnimationController _questionController;
  late AnimationController _buttonController;
  late AnimationController _scoreController;
  late Animation<double> _questionAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    loadQuestions();
  }

  void _initializeAnimations() {
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _questionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.bounceOut),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.bounceOut),
    );

    _questionController.forward();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _buttonController.dispose();
    _scoreController.dispose();
    super.dispose();
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
        SnackBar(
          content: Text('Lỗi khi tải câu hỏi: $e'),
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
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
        _scoreController.forward();
      }
    });

    _buttonController.forward();
  }

  void _nextQuestion() {
    if (currentQuestionIndex < selectedQuestions.length - 1) {
      _questionController.reset();
      _buttonController.reset();
      _scoreController.reset();

      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isCorrect = null;
        correctAnswerIndex = -1;
      });

      _questionController.forward();
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
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_history.json');

      final newResult = {
        'userName': widget.userName ?? 'Ẩn danh',
        'gradeLevel': widget.gradeLevel,
        'correctAnswers': correctAnswersCount,
        'totalQuestions': widget.numQuestions,
        'score': double.parse(score.toStringAsFixed(1)),
        'timestamp': DateTime.now().toIso8601String(),
      };

      List<dynamic> history = [];

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

      history.insert(0, newResult);

      if (history.length > 100) {
        history = history.take(100).toList();
      }

      final String jsonString = jsonEncode(history);
      await file.writeAsString(jsonString);

      print('Đã lưu lịch sử vào my_history.json: ${widget.userName}, Lớp ${widget.gradeLevel}, Điểm: $score');
      print('Đường dẫn file: ${file.path}');
    } catch (e) {
      print('Lỗi khi lưu lịch sử: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể lưu lịch sử: $e'),
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

  Color _getAnswerColor(int index) {
    if (selectedAnswerIndex == null) {
      return Colors.white;
    }

    if (index == correctAnswerIndex) {
      return Colors.green.shade400;
    } else if (index == selectedAnswerIndex && index != correctAnswerIndex) {
      return Colors.red.shade400;
    } else {
      return Colors.grey.shade200;
    }
  }

  Color _getAnswerTextColor(int index) {
    if (selectedAnswerIndex == null) {
      return Colors.indigo.shade700;
    }

    if (index == correctAnswerIndex || (index == selectedAnswerIndex && index != correctAnswerIndex)) {
      return Colors.white;
    } else {
      return Colors.grey.shade600;
    }
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white.withOpacity(0.3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / selectedQuestions.length,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow.shade400),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row - Logo and greeting
          Row(
            children: [
              const LogoWidget(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Chào ${widget.userName ?? 'bạn nhỏ'}! 🌟',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Bottom row - Info and progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lớp ${widget.gradeLevel}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Câu ${currentQuestionIndex + 1}/${selectedQuestions.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade700,
                ),
              ),
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scoreAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade400, Colors.green.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$correctAnswersCount',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressBar(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLoading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow.shade400),
                    strokeWidth: 6,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Đang tải câu hỏi...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
                : Column(
              children: [
                // Compact header
                _buildCompactHeader(),
                const SizedBox(height: 16),

                // Main content area - No scrolling needed
                Expanded(
                  child: selectedQuestions.isNotEmpty
                      ? AnimatedBuilder(
                    animation: _questionAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _questionAnimation.value,
                        child: Opacity(
                          opacity: _questionAnimation.value,
                          child: Column(
                            children: [
                              // Question card - More compact
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.blue.shade50,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.help_outline,
                                        color: Colors.blue.shade600,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        selectedQuestions[currentQuestionIndex]['question'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo.shade800,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Answer options - More compact
                              Expanded(
                                child: ListView.builder(
                                  itemCount: selectedQuestions[currentQuestionIndex]['options'].length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: GestureDetector(
                                        onTap: () => _handleAnswer(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: selectedAnswerIndex == null
                                                  ? [Colors.white, Colors.blue.shade50]
                                                  : [_getAnswerColor(index), _getAnswerColor(index)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: selectedAnswerIndex == null
                                                  ? Colors.blue.shade300
                                                  : Colors.transparent,
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: selectedAnswerIndex == null
                                                    ? Colors.blue.withOpacity(0.1)
                                                    : _getAnswerColor(index).withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: selectedAnswerIndex == null
                                                        ? [Colors.blue.shade400, Colors.blue.shade600]
                                                        : [Colors.white.withOpacity(0.9), Colors.white],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.1),
                                                      blurRadius: 3,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    String.fromCharCode(65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: selectedAnswerIndex == null
                                                          ? Colors.white
                                                          : _getAnswerTextColor(index),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  selectedQuestions[currentQuestionIndex]['options'][index],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: _getAnswerTextColor(index),
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              if (selectedAnswerIndex != null)
                                                Icon(
                                                  index == correctAnswerIndex
                                                      ? Icons.check_circle
                                                      : (index == selectedAnswerIndex ? Icons.cancel : Icons.radio_button_unchecked),
                                                  color: _getAnswerTextColor(index),
                                                  size: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : const SizedBox(),
                ),

                // Bottom section - Feedback and buttons
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      // Feedback message
                      if (selectedAnswerIndex != null)
                        AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isCorrect == true
                                        ? [Colors.green.shade400, Colors.green.shade600]
                                        : [Colors.red.shade400, Colors.red.shade600],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isCorrect == true ? Colors.green : Colors.red).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isCorrect == true ? Icons.sentiment_very_satisfied : Icons.sentiment_dissatisfied,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isCorrect == true ? 'Tuyệt vời! 🎉' : 'Cố gắng lần sau nhé! 💪',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      // Action buttons row
                      Row(
                        children: [
                          // Home button
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade400, Colors.red.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Next button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedAnswerIndex != null ? _nextQuestion : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedAnswerIndex != null
                                    ? Colors.yellow.shade400
                                    : Colors.grey.shade300,
                                foregroundColor: selectedAnswerIndex != null
                                    ? Colors.indigo.shade700
                                    : Colors.grey.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: selectedAnswerIndex != null ? 4 : 0,
                                shadowColor: Colors.yellow.withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedAnswerIndex == null
                                        ? 'Chọn đáp án trước nhé!'
                                        : (currentQuestionIndex < selectedQuestions.length - 1
                                        ? 'Câu tiếp theo'
                                        : 'Xem kết quả'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    selectedAnswerIndex == null
                                        ? Icons.touch_app
                                        : (currentQuestionIndex < selectedQuestions.length - 1
                                        ? Icons.arrow_forward_ios
                                        : Icons.celebration),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
}