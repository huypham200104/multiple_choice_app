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

    await _soundSettings.setSoundEnabled(value);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                value ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                value ? 'Đã bật âm thanh' : 'Đã tắt âm thanh',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isLargeTablet = screenSize.width > 800;

    if (_isLoading) {
      return Scaffold(
          body: AppBackground(
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
      );
    }

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16.0 : 8.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                // Header
                SizedBox(
                  height: isTablet ? 80 : 70,
                  child: _buildHeader(isTablet, screenSize.width),
                ),

                SizedBox(height: isTablet ? 12 : 8),

                // Sound card
                SizedBox(
                  height: isTablet ? 80 : 70,
                  child: _buildSoundCard(isTablet),
                ),

                SizedBox(height: isTablet ? 12 : 8),

                // Settings grid - Expanded to fill remaining space
                Expanded(
                  child: _buildSettingsGrid(isTablet, isLargeTablet, screenSize),
                ),

                SizedBox(height: isTablet ? 12 : 8),

                // Back button
                SizedBox(
                  height: isTablet ? 60 : 50,
                  child: _buildBackButton(isTablet),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet, double screenWidth) {
    final fontSize = isTablet ? 20.0 : 16.0;
    final subtitleSize = isTablet ? 14.0 : 12.0;
    final logoSize = isTablet ? 40.0 : 30.0;
    final iconSize = isTablet ? 28.0 : 22.0;

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.purple.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 14),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 8 : 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: LogoWidget(size: logoSize),
          ),
          SizedBox(width: isTablet ? 16 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Xin chào ${_userName ?? 'bạn'}! 👋',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cài đặt ứng dụng',
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
            size: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildSoundCard(bool isTablet) {
    final fontSize = isTablet ? 16.0 : 14.0;
    final subtitleSize = isTablet ? 12.0 : 10.0;
    final iconSize = isTablet ? 28.0 : 22.0;

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 10 : 6),
            decoration: BoxDecoration(
              color: isSoundEnabled ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isSoundEnabled ? Icons.volume_up : Icons.volume_off,
              color: isSoundEnabled ? Colors.blue.shade600 : Colors.grey.shade600,
              size: iconSize,
            ),
          ),
          SizedBox(width: isTablet ? 16 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Âm thanh',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: isSoundEnabled ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                Text(
                  isSoundEnabled ? 'Bật âm thanh trong game' : 'Tắt âm thanh trong game',
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: isSoundEnabled ? Colors.grey.shade600 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: isTablet ? 1.1 : 1.0,
            child: Switch(
              value: isSoundEnabled,
              onChanged: _toggleSound,
              activeColor: Colors.blue.shade600,
              activeTrackColor: Colors.blue.shade200,
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGrid(bool isTablet, bool isLargeTablet, Size screenSize) {
    final crossAxisCount = isLargeTablet ? 4 : (isTablet ? 2 : 2);
    final childAspectRatio = isLargeTablet ? 1.0 : (isTablet ? 1.2 : 1.0);

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: isTablet ? 12.0 : 8.0,
      mainAxisSpacing: isTablet ? 12.0 : 8.0,
      childAspectRatio: childAspectRatio,
      children: [
        _buildSettingCard(
          icon: Icons.person_outline,
          title: 'Đổi tên',
          subtitle: 'Thay đổi tên hiển thị',
          color: Colors.blue,
          isTablet: isTablet,
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
              await _loadUserName();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Đã đổi tên thành: $newName',
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
          isTablet: isTablet,
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
          isTablet: isTablet,
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
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Đã xóa lịch sử làm bài',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
          isTablet: isTablet,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    Icon(Icons.info, color: Colors.purple),
                    SizedBox(width: 8),
                    Text(
                      'Thông tin ứng dụng',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌟 Siêu Toán Nhí',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '📱 Ứng dụng toán học dành cho trẻ em',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '🔢 Phiên bản: 1.0.0',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '👨‍💻 Phát triển bởi: Đội ngũ phát triển',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ứng dụng giúp trẻ em học toán một cách vui vẻ và hiệu quả!',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Đóng',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isTablet,
    bool disabled = false,
    required VoidCallback? onTap,
  }) {
    final titleSize = isTablet ? 14.0 : 12.0;
    final subtitleSize = isTablet ? 11.0 : 9.0;
    final iconSize = isTablet ? 26.0 : 20.0;
    final padding = isTablet ? 12.0 : 8.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        child: Container(
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade200 : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            boxShadow: disabled
                ? []
                : [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 10 : 6),
                  decoration: BoxDecoration(
                    color: disabled ? Colors.grey.shade300 : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: disabled ? Colors.grey : color,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: disabled ? Colors.grey : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 4 : 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: subtitleSize,
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

  Widget _buildBackButton(bool isTablet) {
    final fontSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 22.0 : 18.0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context, _userName),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade600,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
        ),
        icon: Icon(Icons.arrow_back, size: iconSize),
        label: Text(
          'Quay lại',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}