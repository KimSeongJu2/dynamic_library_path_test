import 'dart:ffi' as ffi;
import 'package:path/path.dart' as path;
import 'dart:io' show Directory, File, Platform;

import 'bindings.dart';

LibSerialPort? _dylib;

String get _extension {
  if (Platform.isWindows) return 'dll';
  if (Platform.isAndroid) return 'so';
  if (Platform.isMacOS) return 'dylib';
  throw UnsupportedError('This library cannot be used on platforms other than Windows, Android, and Linux.');
}
LibSerialPort get dylib {
  String filePath = 'libserialport.$_extension';

  if (!Platform.isAndroid) {
    filePath = path.join(Directory.current.path, 'dlls', filePath);
  }

  return _dylib ??= LibSerialPort(
    ffi.DynamicLibrary.open(filePath),
  );
}
