// setting_screen.dart
import 'package:flutter/material.dart';
import 'background_widget.dart';
import 'logo_widget.dart';
import 'rename_screen.dart';
import 'history_screen.dart';
import 'helpers/history_helper.dart';
import 'helpers/database_helper.dart';
import 'helpers/sound_settings_helper.dart';
import 'music_player.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String)? onNameChanged;

  const SettingsScreen({
    Key? key,
    this.onNameChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSoundEnabled = true;
  bool _isHistoryEmpty = true;
  String? _userName;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SoundSettingsHelper _soundSettings = SoundSettingsHelper.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.wait([
      _loadUserName(),
      _checkHistory(),
      _loadSoundSettings(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadSoundSettings() async {
    try {
      final soundEnabled = await _soundSettings.isSoundEnabled();
      if (mounted) {
        setState(() {
          isSoundEnabled = soundEnabled;
        });
      }
    } catch (e) {
      print('Error loading sound settings: $e');
    }
  }

  Future<void> _loadUserName() async {
    try {
      final name = await _dbHelper.getUserName();
      if (mounted) {
        setState(() {
          _userName = name;
        });
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  Future<void> _checkHistory() async {
    try {
      final history = await HistoryHelper.getHistory();
      if (mounted) {
        setState(() {
          _isHistoryEmpty = history.isEmpty;
        });
      }
    } catch (e) {
      print('Error checking history: $e');
      if (mounted) {
        setState(() {
          _isHistoryEmpty = true;
        });
      }
    }
  }

  Future<void> _toggleSound(bool value) async {
    setState(() {
      isSoundEnabled = value;
    });

    // Cập nhật cài đặt âm thanh thông qua helper
    await _soundSettings.setSoundEnabled(value);

    // Hiển thị thông báo
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                value ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                value ? 'Đã bật âm thanh' : 'Đã tắt âm thanh',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: value ? Colors.green : Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: AppBackground(
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 20),

                // Settings content
                Expanded(
                  child: _buildSettingsGrid(),
                ),

                // Back button
                _buildBackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào ${_userName ?? 'bạn'}! 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cài đặt ứng dụng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.settings,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGrid() {
    return Column(
      children: [
        // Sound setting card
        _buildSoundCard(),
        const SizedBox(height: 16),

        // Settings buttons grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildSettingCard(
                icon: Icons.person_outline,
                title: 'Đổi tên',
                subtitle: 'Thay đổi tên hiển thị',
                color: Colors.blue,
                onTap: () async {
                  final newName = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RenameScreen(
                        currentName: _userName,
                      ),
                    ),
                  );
                  if (newName != null && newName.isNotEmpty) {
                    setState(() {
                      _userName = newName;
                    });
                    if (widget.onNameChanged != null) {
                      widget.onNameChanged!(newName);
                    }
                    await _loadUserName(); // Làm mới tên từ cơ sở dữ liệu
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Đã đổi tên thành: $newName',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              _buildSettingCard(
                icon: Icons.history,
                title: 'Lịch sử',
                subtitle: 'Xem kết quả đã làm',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  ).then((_) => _checkHistory());
                },
              ),
              _buildSettingCard(
                icon: Icons.delete_outline,
                title: 'Xóa lịch sử',
                subtitle: 'Xóa toàn bộ dữ liệu',
                color: _isHistoryEmpty ? Colors.grey : Colors.orange,
                disabled: _isHistoryEmpty,
                onTap: _isHistoryEmpty ? null : () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Xác nhận'),
                        ],
                      ),
                      content: const Text(
                          'Bạn có chắc chắn muốn xóa toàn bộ lịch sử làm bài?\n\nHành động này không thể hoàn tác!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
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
                    if (mounted) {
                      setState(() {
                        _isHistoryEmpty = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Đã xóa lịch sử làm bài',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              _buildSettingCard(
                icon: Icons.info_outline,
                title: 'Thông tin',
                subtitle: 'Về ứng dụng',
                color: Colors.purple,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.purple),
                          SizedBox(width: 8),
                          Text('Thông tin ứng dụng'),
                        ],
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🌟 Siêu Toán Nhí',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('📱 Ứng dụng toán học dành cho trẻ em'),
                          SizedBox(height: 4),
                          Text('🔢 Phiên bản: 1.0.0'),
                          SizedBox(height: 4),
                          Text('👨‍💻 Phát triển bởi: Đội ngũ phát triển'),
                          SizedBox(height: 8),
                          Text(
                            'Ứng dụng giúp trẻ em học toán một cách vui vẻ và hiệu quả!',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoundCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSoundEnabled ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSoundEnabled ? Icons.volume_up : Icons.volume_off,
              color: isSoundEnabled ? Colors.blue.shade600 : Colors.grey.shade600,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Âm thanh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSoundEnabled ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isSoundEnabled ? 'Bật âm thanh trong game' : 'Tắt âm thanh trong game',
                  style: TextStyle(
                    fontSize: 13,
                    color: isSoundEnabled ? Colors.grey.shade600 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isSoundEnabled,
            onChanged: _toggleSound,
            activeColor: Colors.blue.shade600,
            activeTrackColor: Colors.blue.shade200,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool disabled = false,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade200 : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: disabled
                ? []
                : [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: disabled ? Colors.grey.shade300 : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: disabled ? Colors.grey : color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: disabled ? Colors.grey : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: disabled ? Colors.grey : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, _userName), // Trả về tên hiện tại
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade600,
            foregroundColor: Colors.white,
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
          label: const Text(
            'Quay lại',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}