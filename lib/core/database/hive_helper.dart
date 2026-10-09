import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final hiveHelperProvider = Provider<HiveHelper>((ref) {
  return HiveHelper.instance;
});

class HiveHelper {
  static final HiveHelper instance = HiveHelper._init();
  static const String coursesBoxName = 'courses_box';
  Box<dynamic>? _coursesBox;

  HiveHelper._init();

  Future<Box<dynamic>> get coursesBox async {
    if (_coursesBox != null && _coursesBox!.isOpen) {
      return _coursesBox!;
    }
    _coursesBox = await _initHive();
    return _coursesBox!;
  }

  Future<Box<dynamic>> _initHive() async {
    if (!Hive.isBoxOpen(coursesBoxName)) {
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocDir.path);
      } catch (_) {
        // Fallback for environments where path_provider is mocked or isolated
      }
      return await Hive.openBox<dynamic>(coursesBoxName);
    }
    return Hive.box<dynamic>(coursesBoxName);
  }

  Future<void> clearAll() async {
    final box = await coursesBox;
    await box.clear();
  }

  Future<void> close() async {
    if (_coursesBox != null && _coursesBox!.isOpen) {
      await _coursesBox!.close();
      _coursesBox = null;
    }
  }
}
