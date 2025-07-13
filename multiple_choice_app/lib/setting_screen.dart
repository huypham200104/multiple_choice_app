import 'package:flutter/material.dart';
import 'background_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Settings container
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          // Settings title
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Sound toggle
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Âm thanh On / Off',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Switch(
                                  value: isSoundEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      isSoundEnabled = value;
                                    });
                                  },
                                  activeColor: Colors.cyan,
                                  activeTrackColor: Colors.cyan.shade200,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Setting buttons
                          _buildSettingButton(
                            text: 'Đổi tên hiển thị',
                            backgroundColor: Colors.blue.shade400,
                            onPressed: () {
                              // Handle change display name
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildSettingButton(
                            text: 'Lịch sử làm bài',
                            backgroundColor: Colors.red.shade400,
                            onPressed: () {
                              // Handle history
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildSettingButton(
                            text: 'Xóa lịch sử',
                            backgroundColor: Colors.purple.shade400,
                            onPressed: () {
                              // Handle clear history
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildSettingButton(
                            text: 'Quay lại',
                            backgroundColor: Colors.purple.shade300,
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

  Widget _buildSettingButton({
    required String text,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}