import 'dart:ffi' as ffi;
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
  print(File('libserialport.$_extension').existsSync() ? File('libserialport.$_extension').path : 'null');

  return _dylib ??= LibSerialPort(
    ffi.DynamicLibrary.open('libserialport.$_extension'),
  );
}
