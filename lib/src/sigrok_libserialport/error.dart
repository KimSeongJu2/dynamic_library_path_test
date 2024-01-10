import 'dart:io';

// ignore_for_file: no_runtimetype_tostring

class SerialPortError extends OSError {
  const SerialPortError([super.message = '', super.errorCode = OSError.noErrorCode]);

  @override
  String toString() {
    return super.toString().replaceFirst('OS Error', runtimeType.toString());
  }
}
