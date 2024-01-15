abstract class SerialDevice<R, P> {
  SerialDevice();

  Future<R> request(P params);

  Future<void> disconnect();
}

class SerialPortInfo {
  final String portName;
  final int baudRate;
  final int dataBits;
  final int parity;
  final int stopBits;
  final int cleanToSend;
  final int dataSetReady;
  final int dataTerminalReady;
  final int flowControl;
  final int requestToSend;
  final int xOnxOff;

  SerialPortInfo({
    required this.portName,
    required this.baudRate,
    required this.dataBits,
    required this.parity,
    required this.stopBits,
    required this.cleanToSend,
    required this.dataSetReady,
    required this.dataTerminalReady,
    required this.flowControl,
    required this.requestToSend,
    required this.xOnxOff,
  });
}
