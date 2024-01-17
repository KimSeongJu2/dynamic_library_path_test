import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
    // var config = _serialPort.config;

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
      List<int> dataBytes = [0x41]; // Uint8List.fromList(cp949.encode(data));
      int result = _serialPort.write(Uint8List.fromList(dataBytes));
      print('result: $result');
      print(_serialPort.signals);
      //_serialPort.write(Uint8List.fromList(cp949.encode(data)));
      sleep(const Duration(milliseconds: 20));
    });
  }

  // Bigendian 전송 테스트
  // void _listenInputStream() {
  //   _inputStream.stream.listen((data) {
  //     // 데이터를 바이트 배열로 변환
  //     List<int> dataBytes = Uint8List.fromList(cp949.encode(data));
  //
  //     // 바이트 배열을 big-endian으로 변환
  //     List<int> bigEndianData = [];
  //     for (int i = dataBytes.length - 1; i >= 0; i--) {
  //       bigEndianData.add(dataBytes[i]);
  //     }
  //
  //     // _serialPort로 보내기
  //     _serialPort.write(Uint8List.fromList(bigEndianData));
  //
  //     sleep(const Duration(milliseconds: 20));
  //   });
  // }

  // Asciicode 전송 테스트
  // void _listenInputStream() {
  //   _inputStream.stream.listen((data) {
  //     try {
  //       // ASCII로 인코딩합니다. ASCII 범위 밖의 문자가 있으면 예외가 발생할 수 있습니다.
  //       var asciiData = ascii.encode(data);
  //       _serialPort.write(Uint8List.fromList(asciiData));
  //     } catch (e) {
  //       // ASCII 인코딩 중에 오류가 발생하면 처리합니다.
  //       print("Error encoding data to ASCII: $e");
  //     }
  //     sleep(const Duration(milliseconds: 20));
  //   });
  // }

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
