import 'package:flutter/material.dart';
import 'background_widget.dart';
import 'logo_widget.dart';
import 'rename_screen.dart';
import 'history_screen.dart';
import 'helpers/history_helper.dart';

class SettingsScreen extends StatefulWidget {
  final String? userName;
  final Function(String)? onNameChanged;

  const SettingsScreen({
    Key? key,
    this.userName,
    this.onNameChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSoundEnabled = true;
  bool _isHistoryEmpty = true;

  @override
  void initState() {
    super.initState();
    _checkHistory();
  }

  Future<void> _checkHistory() async {
    final history = await HistoryHelper.getHistory();
    setState(() {
      _isHistoryEmpty = history.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header with logo
                Column(
                  children: [
                    const LogoWidget(size: 80),
                    const SizedBox(height: 10),
                    Text(
                      'Xin chào ${widget.userName ?? 'bạn'}!',
                      style: const TextStyle(
                        fontSize: 18,
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
                    const SizedBox(height: 5),
                    const Text(
                      'Cài đặt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Settings content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Sound setting
                          _buildSettingCard(
                            icon: Icons.volume_up,
                            iconColor: Colors.blue,
                            title: 'Âm thanh',
                            trailing: Switch(
                              value: isSoundEnabled,
                              onChanged: (value) {
                                setState(() {
                                  isSoundEnabled = value;
                                });
                              },
                              activeColor: Colors.blue,
                              activeTrackColor: Colors.blue.shade200,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Change name button
                          _buildSettingButton(
                            icon: Icons.person,
                            text: 'Đổi tên hiển thị',
                            color: Colors.blue,
                            onPressed: () async {
                              final newName = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RenameScreen(
                                    currentName: widget.userName,
                                  ),
                                ),
                              );
                              if (newName != null && widget.onNameChanged != null) {
                                widget.onNameChanged!(newName);
                              }
                            },
                          ),
                          const SizedBox(height: 15),

                          // History button
                          _buildSettingButton(
                            icon: Icons.history,
                            text: 'Lịch sử làm bài',
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),

                          // Clear history button
                          _buildSettingButton(
                            icon: Icons.delete,
                            text: 'Xóa lịch sử',
                            color: Colors.orange,
                            disabled: _isHistoryEmpty,
                            onPressed: _isHistoryEmpty
                                ? null
                                : () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text(
                                      'Bạn có chắc chắn muốn xóa toàn bộ lịch sử làm bài?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        'Xóa',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await HistoryHelper.clearHistory();
                                setState(() {
                                  _isHistoryEmpty = true;
                                });
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã xóa lịch sử làm bài'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 15),

                          // Back button
                          _buildSettingButton(
                            icon: Icons.arrow_back,
                            text: 'Quay lại',
                            color: Colors.purple,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
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

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSettingButton({
    required IconData icon,
    required String text,
    required Color color,
    bool disabled = false,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(disabled ? 0.5 : 1.0),
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}