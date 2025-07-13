import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HistoryHelper {
  static Future<List<dynamic>> getHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_history.json');

      if (!await file.exists()) {
        return [];
      }

      final String jsonString = await file.readAsString();
      if (jsonString.isEmpty) {
        return [];
      }

      final dynamic jsonData = jsonDecode(jsonString);
      if (jsonData is List) {
        return jsonData;
      } else if (jsonData is Map && jsonData['history'] != null) {
        return jsonData['history'];
      }

      return [];
    } catch (e) {
      print('Lỗi khi đọc lịch sử: $e');
      return [];
    }
  }

  static Future<String> getHistoryFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/my_history.json';
  }

  static Future<bool> historyFileExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_history.json');
    return await file.exists();
  }

  static Future<void> clearHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_history.json');

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Lỗi khi xóa lịch sử: $e');
    }
  }
}