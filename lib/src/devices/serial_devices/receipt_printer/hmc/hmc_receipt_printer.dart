import 'dart:async';
import '../../../command/receipt_printer/hmc/hmc_receipt_printer_parsing.dart';
import '../../../external/receipt_printer/hmc_receipt_printer_external.dart';
import '../../serial_device.dart';

class HmcReceiptPrinter {
  late HmcReceiptPrinterExternal _external;
  bool isConnected = false;

  HmcReceiptPrinter();

  Future<bool> connect(Map<String, dynamic> configuration) async {
    try {
      _external = HmcReceiptPrinterExternal(
        SerialPortInfo(
          portName: configuration['portName'],
          baudRate: configuration['baudRate'],
          dataBits: configuration['dataBits'],
          parity: configuration['parity'],
          stopBits: configuration['stopBits'],
          xOnxOff: configuration['xOnxOff'],
          requestToSend: configuration['requestToSend'],
          cleanToSend: configuration['cleanToSend'],
          dataTerminalReady: configuration['dataTerminalReady'],
          dataSetReady: configuration['dataSetReady'],
          flowControl: configuration['flowControl'],
        ),
      );
      isConnected = true;
      return isConnected;
    } catch (e) {
      isConnected = false;
      throw Exception('Serial Connect error occurred.');
    }
  }

  void send(HmcReceiptPrinterCommand command) {
    command.execute(_external);
  }

  Future<bool> disconnect() async {
    isConnected = false;
    try {
      await _external.close();
      return true;
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }
}
