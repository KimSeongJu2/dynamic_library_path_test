import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:dynamic_library_path_test/src/devices/external/interface/external.dart';
import 'package:rxdart/rxdart.dart';

import '../../../sigrok_libserialport/enums.dart';
import '../../../sigrok_libserialport/port.dart';
import '../../../sigrok_libserialport/reader.dart';
import '../../serial_devices/serial_device.dart';

class HmcReceiptPrinterExternal implements External {
  bool get isOpened => _serialPort.isOpen;

  final StreamController<String> _inputStream = StreamController<String>();
  final PublishSubject<String> _outputStream = PublishSubject<String>();
  final SerialPortInfo serialPortInfo;
  late SerialPortReader _serialPortReader;
  late final SerialPort _serialPort;

  HmcReceiptPrinterExternal(this.serialPortInfo) {
    try {
      _serialPort = SerialPort(serialPortInfo.portName);
    } catch (e) {
      throw Exception('The serial port named ${serialPortInfo.portName} does not exist.');
    }

    if (_serialPort.open(mode: SerialPortMode.readWrite)) {
      _serialPort.config
        ..baudRate = serialPortInfo.baudRate
        ..bits = serialPortInfo.dataBits
        ..stopBits = serialPortInfo.stopBits
        ..parity = serialPortInfo.parity
        ..xonXoff = serialPortInfo.xOnxOff
        ..rts = serialPortInfo.requestToSend
        ..cts = serialPortInfo.cleanToSend
        ..dtr = serialPortInfo.dataTerminalReady
        ..dsr = serialPortInfo.dataSetReady
        ..setFlowControl(serialPortInfo.flowControl);

      _listenSerialPort();
      _listenInputStream();
      return;
    }
    throw Exception('Failed to open serial port in read/write mode.[${serialPortInfo.portName}]');
  }

  @override
  Future<String> request(params) async {
    if (!_serialPort.isOpen) throw Exception('Receipt Printer Serial port is not open.');
    try {
      final inputCommand = params.templatizeToString();

      _inputStream.sink.add(inputCommand);
      return '';
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  void _listenInputStream() {
    _inputStream.stream.listen((data) {
      _serialPort.write(Uint8List.fromList(cp949.encode(data)));
      sleep(const Duration(milliseconds: 20));
    });
  }

  void _listenSerialPort() {
    _serialPortReader = SerialPortReader(_serialPort);

    _serialPortReader.stream.listen((data) {
      _outputStream.sink.add(String.fromCharCodes(data));
    });
  }

  @override
  FutureOr<void> close() async {
    if (_serialPort.isOpen) {
      await _inputStream.close();
      await _outputStream.close();
      _serialPortReader.close();
      _serialPort
        ..close()
        ..dispose();
    }
  }

  @override
  void initialize() {}
}
