import 'dart:developer';

import 'package:flutter/services.dart';

class AndroidCommand {
  static const platform = MethodChannel('kr.co.greendote/android_command');

  static Future<String> runSuCommand(String command) async {
    try {
      final String result = await platform.invokeMethod('runSuCommand', {'command': command});
      return result;
    } on PlatformException catch (e) {
      return "Failed to Run: '${e.message}'.";
    }
  }

  static Future<void> runSttyCommand(String portName, int baudRate) async {
    try {
      await platform.invokeMethod("runSttyCommand", <String, dynamic>{"portName": portName, "baudRate": baudRate});
    } on Exception catch (e) {
      log("Failed to runSttyCommand: '${e.toString()}'.");
    }
  }
}
