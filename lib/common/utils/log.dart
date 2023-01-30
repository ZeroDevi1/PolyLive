import 'package:logging/logging.dart';

class Log {
  static final Log _singleton = Log._internal();

  factory Log() {
    return _singleton;
  }

  Log._internal() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('[${record.level.name}] ${record.time}: ${record.message}');
    });
  }

  void d(String message) {
    _log(Level.FINE, message);
  }

  void i(String message) {
    _log(Level.INFO, message);
  }

  void w(String message) {
    _log(Level.WARNING, message);
  }

  void e(String message) {
    _log(Level.SEVERE, message);
  }

  void _log(Level level, String message) {
    Logger.root.log(level, message);
  }
}
