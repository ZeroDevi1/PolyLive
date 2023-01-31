import 'package:logging/logging.dart';

class Log {
  static final Log _singleton = Log._internal();

  static Log get instance => _singleton;

  Log._internal() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('[${record.level.name}] ${record.time}: ${record.message}');
    });
  }

  static void d(String message) {
    instance._log(Level.FINE, message);
  }

  static void i(String message) {
    instance._log(Level.INFO, message);
  }

  static void w(String message) {
    instance._log(Level.WARNING, message);
  }

  static void e(String message) {
    instance._log(Level.SEVERE, message);
  }

  void _log(Level level, String message) {
    Logger.root.log(level, message);
  }
}
