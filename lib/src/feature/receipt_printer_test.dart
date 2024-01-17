import 'package:dynamic_library_path_test/src/devices/serial_devices/receipt_printer/hmc/hmc_receipt_printer.dart';
import 'package:flutter/material.dart';

import '../devices/command/receipt_printer/hmc/hmc_receipt_printer_parsing.dart';

class ReceiptPrinterTest extends StatefulWidget {
  const ReceiptPrinterTest({
    super.key,
    required this.portName,
    required this.baudRate,
  });

  final String portName;
  final int baudRate;

  @override
  State<ReceiptPrinterTest> createState() => _ReceiptPrinterTestState();
}

class _ReceiptPrinterTestState extends State<ReceiptPrinterTest> {
  HmcReceiptPrinter? _receiptPrinter;

  late Map<String, dynamic> fakes;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _startPrint,
      tooltip: 'Start Print',
      backgroundColor: Colors.yellow,
      child: const Icon(Icons.print_outlined),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _startPrint() {
    fakes = {
      'portName': widget.portName,
      'baudRate': widget.baudRate,
      'dataBits': 8,
      'parity': 0,
      'handshake': 2,
      'stopBits': 1,
      'xOnxOff': 0,
      'requestToSend': 1,
      'cleanToSend': 0,
      'dataTerminalReady': 0,
      'dataSetReady': 0,
      'flowControl': 0,
    };

    if (_receiptPrinter == null || !_receiptPrinter!.isConnected) {
      _receiptPrinter = HmcReceiptPrinter();
      _receiptPrinter!.connect(fakes);
    }

    if (_receiptPrinter!.isConnected) {
      HmcReceiptPrinterParsing parsing = HmcReceiptPrinterParsing();

      String data = 'C';
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText:  data, isNewLine: false));
      // _receiptPrinter!.send(HmcReceiptPrinterCommand.lineFeed(feedHeight: parsing.feedHeight5));
      // _receiptPrinter!.send(HmcReceiptPrinterCommand.paperCutting());

      /*_receiptPrinter!.send(HmcReceiptPrinterCommand.textAlign(align: parsing.centerAlign));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Test Print Data'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: DateTime.now().toString()));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 1'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 2'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 3'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 4'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 5'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 6'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 1'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 2'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 3'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 4'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 5'));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.printText(printText: 'Line 6'));
      *//*_receiptPrinter!.send(HmcReceiptPrinterCommand.printTextSpaceBetween(
          printText: ' 좌측정렬 ${parsing.splitter}우측정렬', splitter: parsing.splitter));*//*
      _receiptPrinter!.send(HmcReceiptPrinterCommand.zoomFont(zoomFormat: parsing.clearFormat));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.textAlign(align: parsing.leftAlign));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.lineFeed(feedHeight: parsing.feedHeight5));
      _receiptPrinter!.send(HmcReceiptPrinterCommand.paperCutting());*/
    }
  }
}
