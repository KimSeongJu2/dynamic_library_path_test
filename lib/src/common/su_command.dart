import 'package:flutter/services.dart';

class SuCommand {
  static const platform = MethodChannel('kr.co.greendote/su');

  static Future<String> runSuCommand(String command) async {
    try {
      final String result = await platform.invokeMethod('runSuCommand', {'command': command});
      return result;
    } on PlatformException catch (e) {
      return "Failed to Run: '${e.message}'.";
    }
  }
}