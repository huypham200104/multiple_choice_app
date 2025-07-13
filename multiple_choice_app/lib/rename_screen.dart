import 'package:flutter/material.dart';
import 'background_widget.dart';
import 'logo_widget.dart';
import 'helpers/database_helper.dart';

class RenameScreen extends StatefulWidget {
  final String? currentName;

  const RenameScreen({
    Key? key,
    this.currentName,
  }) : super(key: key);

  @override
  State<RenameScreen> createState() => _RenameScreenState();
}

class _RenameScreenState extends State<RenameScreen>
    with TickerProviderStateMixin {
  late TextEditingController _nameController;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _isLoading = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName ?? '');

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _bounceController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      _showSnackBar('Vui lòng nhập tên mới', Colors.red);
      return;
    }

    if (newName == widget.currentName) {
      _showSnackBar('Tên mới không được trùng với tên hiện tại', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _dbHelper.insertUserName(newName);
      _showSnackBar('Đã cập nhật tên thành công!', Colors.green);

      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        Navigator.pop(context, newName);
      }
    } catch (e) {
      _showSnackBar('Có lỗi xảy ra: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          _buildHeader(),

                          const SizedBox(height: 20),

                          // Content - Expanded to take available space
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Current name
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tên hiện tại:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.currentName ?? 'Chưa có tên',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Arrow icon
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // New name input
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                                        child: Text(
                                          'Tên mới:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        controller: _nameController,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập tên mới của bạn',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              16, 8, 16, 12),
                                        ),
                                        enabled: !_isLoading,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Note
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.orange.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Tên mới sẽ được hiển thị trên tất cả các màn hình',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Buttons at the bottom
                          _buildButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.indigo.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const LogoWidget(size: 40),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đổi tên người dùng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Thay đổi tên hiển thị của bạn',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // Save button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveName,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 3,
              shadowColor: Colors.blue.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            icon: _isLoading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.save, size: 18),
            label: Text(
              _isLoading ? 'Đang lưu...' : 'Lưu thay đổi',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Cancel button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
              foregroundColor: Colors.white,
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text(
              'Quay lại',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}