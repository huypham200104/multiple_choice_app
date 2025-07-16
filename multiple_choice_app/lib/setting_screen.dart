// setting_screen.dart - Fixed version
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

  // Enhanced responsive design logic
  Map<String, dynamic> _getResponsiveValues(Size screenSize) {
    final width = screenSize.width;
    final height = screenSize.height;
    final isTablet = width > 600;
    final isLargeTablet = width > 900;
    final isSmallPhone = width < 360;
    final aspectRatio = height / width;

    return {
      'isTablet': isTablet,
      'isLargeTablet': isLargeTablet,
      'isSmallPhone': isSmallPhone,
      'isShortScreen': aspectRatio < 1.5, // Detect short/wide screens
      // Header sizes - reduced for better fit
      'headerHeight': isTablet ? 85.0 : (isSmallPhone ? 70.0 : 75.0),
      'headerPadding': isTablet ? 16.0 : (isSmallPhone ? 12.0 : 14.0),
      'headerRadius': isTablet ? 18.0 : 12.0,
      'logoSize': isTablet ? 40.0 : (isSmallPhone ? 28.0 : 32.0),
      'headerFontSize': isTablet ? 20.0 : (isSmallPhone ? 16.0 : 18.0),
      'headerSubtitleSize': isTablet ? 14.0 : (isSmallPhone ? 12.0 : 13.0),
      'headerIconSize': isTablet ? 26.0 : (isSmallPhone ? 20.0 : 24.0),
      // Sound card sizes - reduced
      'soundCardHeight': isTablet ? 75.0 : (isSmallPhone ? 55.0 : 65.0),
      'soundCardPadding': isTablet ? 16.0 : (isSmallPhone ? 8.0 : 12.0),
      'soundCardRadius': isTablet ? 14.0 : 10.0,
      'soundIconSize': isTablet ? 26.0 : (isSmallPhone ? 18.0 : 22.0),
      'soundFontSize': isTablet ? 16.0 : (isSmallPhone ? 11.0 : 13.0),
      'soundSubtitleSize': isTablet ? 12.0 : (isSmallPhone ? 9.0 : 10.0),
      // Grid settings
      'gridCrossAxisCount': isLargeTablet ? 4 : (isTablet ? 3 : 2),
      'gridAspectRatio': isLargeTablet ? 1.1 : (isTablet ? 1.0 : 1.0),
      'gridSpacing': isTablet ? 14.0 : (isSmallPhone ? 6.0 : 8.0),
      'gridItemPadding': isTablet ? 14.0 : (isSmallPhone ? 8.0 : 10.0),
      'gridItemRadius': isTablet ? 14.0 : 10.0,
      'gridIconSize': isTablet ? 24.0 : (isSmallPhone ? 16.0 : 20.0),
      'gridTitleSize': isTablet ? 14.0 : (isSmallPhone ? 10.0 : 12.0),
      'gridSubtitleSize': isTablet ? 11.0 : (isSmallPhone ? 8.0 : 10.0),
      // Button sizes
      'buttonHeight': isTablet ? 60.0 : (isSmallPhone ? 40.0 : 45.0),
      'buttonFontSize': isTablet ? 16.0 : (isSmallPhone ? 11.0 : 13.0),
      'buttonIconSize': isTablet ? 22.0 : (isSmallPhone ? 14.0 : 18.0),
      'buttonRadius': isTablet ? 14.0 : 10.0,
      // Spacing - reduced for better fit
      'sectionSpacing': isTablet ? 12.0 : (isSmallPhone ? 6.0 : 8.0),
      'containerPadding': isTablet ? 16.0 : (isSmallPhone ? 8.0 : 12.0),
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final responsive = _getResponsiveValues(screenSize);

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Main scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(responsive['containerPadding']),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight -
                              responsive['buttonHeight'] -
                              (responsive['containerPadding'] * 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Container(
                              height: responsive['headerHeight'],
                              child: _buildHeader(responsive),
                            ),

                            SizedBox(height: responsive['sectionSpacing']),

                            // Sound card
                            Container(
                              height: responsive['soundCardHeight'],
                              child: _buildSoundCard(responsive),
                            ),

                            SizedBox(height: responsive['sectionSpacing']),

                            // Settings grid
                            _buildSettingsGrid(responsive),

                            SizedBox(height: responsive['sectionSpacing']),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Back button - Fixed at bottom
                  Container(
                    padding: EdgeInsets.all(responsive['containerPadding']),
                    child: SizedBox(
                      height: responsive['buttonHeight'],
                      child: _buildBackButton(responsive),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> responsive) {
    return Container(
      padding: EdgeInsets.all(responsive['headerPadding']),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.purple.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive['headerRadius']),
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
            padding: EdgeInsets.all(responsive['isTablet'] ? 6.0 : 4.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: LogoWidget(size: responsive['logoSize']),
          ),
          SizedBox(width: responsive['isTablet'] ? 12.0 : 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Xin chào ${_userName ?? 'bạn'}! 👋',
                  style: TextStyle(
                    fontSize: responsive['headerFontSize'],
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  'Cài đặt ứng dụng',
                  style: TextStyle(
                    fontSize: responsive['headerSubtitleSize'],
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
            size: responsive['headerIconSize'],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundCard(Map<String, dynamic> responsive) {
    return Container(
      padding: EdgeInsets.all(responsive['soundCardPadding']),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(responsive['soundCardRadius']),
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
            padding: EdgeInsets.all(responsive['isTablet'] ? 8.0 : 5.0),
            decoration: BoxDecoration(
              color: isSoundEnabled ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isSoundEnabled ? Icons.volume_up : Icons.volume_off,
              color: isSoundEnabled ? Colors.blue.shade600 : Colors.grey.shade600,
              size: responsive['soundIconSize'],
            ),
          ),
          SizedBox(width: responsive['isTablet'] ? 12.0 : 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Âm thanh',
                  style: TextStyle(
                    fontSize: responsive['soundFontSize'],
                    fontWeight: FontWeight.w600,
                    color: isSoundEnabled ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                Text(
                  isSoundEnabled ? 'Bật âm thanh trong game' : 'Tắt âm thanh trong game',
                  style: TextStyle(
                    fontSize: responsive['soundSubtitleSize'],
                    color: isSoundEnabled ? Colors.grey.shade600 : Colors.grey.shade500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: responsive['isTablet'] ? 1.0 : 0.9,
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

  Widget _buildSettingsGrid(Map<String, dynamic> responsive) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: responsive['gridCrossAxisCount'],
      crossAxisSpacing: responsive['gridSpacing'],
      mainAxisSpacing: responsive['gridSpacing'],
      childAspectRatio: responsive['gridAspectRatio'],
      children: [
        _buildSettingCard(
          icon: Icons.person_outline,
          title: 'Đổi tên',
          subtitle: 'Thay đổi tên hiển thị',
          color: Colors.blue,
          responsive: responsive,
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
          responsive: responsive,
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
          responsive: responsive,
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
          responsive: responsive,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'Thông tin ứng dụng',
                      style: TextStyle(
                        fontSize: responsive['isTablet'] ? 18 : 14,
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
                          fontSize: responsive['isTablet'] ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📱 Ứng dụng toán học dành cho trẻ em',
                        style: TextStyle(
                          fontSize: responsive['isTablet'] ? 12 : 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🔢 Phiên bản: 1.0.0',
                        style: TextStyle(
                          fontSize: responsive['isTablet'] ? 12 : 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '👨‍💻 Phát triển bởi: Đội ngũ phát triển',
                        style: TextStyle(
                          fontSize: responsive['isTablet'] ? 12 : 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ứng dụng giúp trẻ em học toán một cách vui vẻ và hiệu quả!',
                        style: TextStyle(
                          fontSize: responsive['isTablet'] ? 12 : 10,
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
                        fontSize: responsive['isTablet'] ? 14 : 12,
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
    required Map<String, dynamic> responsive,
    bool disabled = false,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive['gridItemRadius']),
        child: Container(
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade200 : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(responsive['gridItemRadius']),
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
            padding: EdgeInsets.all(responsive['gridItemPadding']),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(responsive['isTablet'] ? 10.0 : 6.0),
                  decoration: BoxDecoration(
                    color: disabled ? Colors.grey.shade300 : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: disabled ? Colors.grey : color,
                    size: responsive['gridIconSize'],
                  ),
                ),
                SizedBox(height: responsive['isTablet'] ? 6.0 : 4.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive['gridTitleSize'],
                    fontWeight: FontWeight.w700,
                    color: disabled ? Colors.grey : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive['isTablet'] ? 3.0 : 2.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: responsive['gridSubtitleSize'],
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

  Widget _buildBackButton(Map<String, dynamic> responsive) {
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
            borderRadius: BorderRadius.circular(responsive['buttonRadius']),
          ),
          padding: EdgeInsets.symmetric(
            vertical: responsive['isTablet'] ? 14.0 : 10.0,
          ),
        ),
        icon: Icon(Icons.arrow_back, size: responsive['buttonIconSize']),
        label: Text(
          'Quay lại',
          style: TextStyle(
            fontSize: responsive['buttonFontSize'],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}