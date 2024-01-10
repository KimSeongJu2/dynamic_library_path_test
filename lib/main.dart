import 'package:dynamic_library_path_test/src/common/su_command.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_library_path_test/src/sigrok_libserialport/enums.dart';
import 'package:dynamic_library_path_test/src/sigrok_libserialport/reader.dart';

import 'src/sigrok_libserialport/port.dart';

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
  late final SerialPort _serialPort;
  late SerialPortReader _serialPortReader;
  final String _portName = '/dev/ttyS6';
  // final String _portName = '/dev/cu.wchusbserial140';
  String _receivedData = '';
  String _availablePorts = '';

  @override
  void initState() {
    super.initState();
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
            Text(
              _availablePorts,
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
            onPressed: availablePorts,
            tooltip: 'View available ports',
            child: const Icon(Icons.list_rounded),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: openDevice,
          tooltip: 'Open device',
            child: const Icon(Icons.file_open),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void openDevice() {
    _serialPort = SerialPort(_portName);
    _serialPort.config
      ..baudRate = 9600
      ..bits = 8
      ..parity = 0
      ..stopBits = 1
      ..xonXoff = 0
      ..rts = 0
      ..cts = 0
      ..dtr = 0
      ..dsr = 0
      ..setFlowControl(0);

    if (_serialPort.open(mode: SerialPortMode.readWrite)) {
      _listenSerialPort();
    } else {
      print('Failed to open serial port in read/write mode.[$_portName]');
    }
  }

  void _listenSerialPort() {
    _serialPortReader = SerialPortReader(_serialPort);

    _serialPortReader.stream.listen((data) {
      _receivedData += String.fromCharCodes(data);
      print(data);
    });
  }

  @override
  void dispose() {
    if (_serialPort.isOpen) {
      _serialPort.close();
    }
    super.dispose();
  }

  void availablePorts() {
    final ports = SerialPort.availablePorts;
    setState(() {
      _availablePorts = ports.toString();
    });
    print(ports);
  }
}
