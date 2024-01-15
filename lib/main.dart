import 'dart:developer';
import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:dynamic_library_path_test/src/common/widget/dropdown_items.dart';
import 'package:dynamic_library_path_test/src/feature/receipt_printer_test.dart';
import 'package:flutter/material.dart';

import 'src/common/toast_message/toast.dart';
import 'src/sigrok_libserialport/enums.dart';
import 'src/sigrok_libserialport/port.dart';
import 'src/sigrok_libserialport/reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serial Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Android Serial Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SerialPort _serialPort;
  late SerialPortReader _serialPortReader;
  final String _portName = '/dev/ttyS6';

  // final String _portName = '/dev/cu.wchusbserial140';
  String _receivedData = '';
  String selectedPort = '';
  int selectedBaudRate = 9600;
  late List<String> availablePorts = [];
  late List<int> availableBaudRates = [];

  @override
  void initState() {
    super.initState();
    try {
      availableBaudRates.addAll([9600, 19200, 38400, 57600, 115200]);
      availablePorts.add('');
      availablePorts.addAll(SerialPort.availablePorts..sort());
    } catch (exception) {
      log(exception.toString());
      // throw Exception(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownItems(
              titleText: 'Port: ',
              selectedItem: selectedPort,
              dropdownList: availablePorts,
              callback: (selectedItem) => setState(() => selectedPort = selectedItem),
            ),
            const SizedBox(height: 30),
            DropdownItems(
              titleText: 'Baud Rate: ',
              selectedItem: selectedBaudRate,
              dropdownList: availableBaudRates,
              callback: (selectedItem) => setState(() => selectedBaudRate = selectedItem),
            ),
            Text(
              availablePorts.map((port) => '$port\n').join(),
            ),
            Text(
              _receivedData,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: openDevice,
            tooltip: 'Open device',
            child: const Icon(Icons.not_started_outlined),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: closeDevice,
            tooltip: 'Close device',
            child: const Icon(Icons.stop_circle_outlined),
          ),
          const SizedBox(width: 10),
          ReceiptPrinterTest(portName: selectedPort, baudRate: selectedBaudRate),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void openDevice() {
    try {
      _serialPort = SerialPort(selectedPort);

      if (_serialPort.open(mode: SerialPortMode.readWrite)) {
        _serialPort.config
          ..baudRate = selectedBaudRate
          ..bits = 8
          ..parity = 0
          ..stopBits = 1
          ..xonXoff = 0
          ..rts = 0
          ..cts = 0
          ..dtr = 0
          ..dsr = 0
          ..setFlowControl(0);

        Toast.showBottomMessage(context, 'Port Open success');
        _listenSerialPort();
      } else {
        Toast.showBottomMessage(context, 'Port Open failed');
        print('Failed to open serial port in read/write mode.[$_portName]');
      }
    } catch (exception) {
      Toast.showBottomMessage(context, exception.toString());
    }
  }

  void _listenSerialPort() {
    _serialPortReader = SerialPortReader(_serialPort);

    _serialPortReader.stream.listen((data) {
      _receivedData += String.fromCharCodes(data);
      print(_receivedData);
      print(data);
    });
  }

  void _writeSerialPort(String command) {
    _serialPort.write(Uint8List.fromList(cp949.encode(command)));
  }

  @override
  void dispose() {
    if (_serialPort.isOpen) {
      _serialPort.close();
    }
    super.dispose();
  }

  void closeDevice() {
    _serialPortReader.close();
    _serialPort.close();
    // if (_serialPort.isOpen) {
    //   Toast.showBottomMessage(context, 'Port Close success');
    // } else {
    //   Toast.showBottomMessage(context, 'Port Close failed');
    // }
  }
}
