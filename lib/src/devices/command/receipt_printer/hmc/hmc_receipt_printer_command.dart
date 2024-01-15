part of 'hmc_receipt_printer_parsing.dart';

sealed class HmcReceiptPrinterCommand implements Command<HmcReceiptPrinterExternal> {
  factory HmcReceiptPrinterCommand.printText({required String printText, bool isNewLine}) = PrintText._;

  factory HmcReceiptPrinterCommand.printTextSpaceBetween(
      {required String printText, required String splitter, bool isNewLine}) = PrintTextSpaceBetween._;

  /// 0x1B(ESC) + 'a' + 0x30
  ///
  /// (Left : 0x30, Center : 0x31, Right : 0x32)
  factory HmcReceiptPrinterCommand.textAlign({required String align}) = TextAlign._;

  /// 0x1B(ESC) + 'i'
  ///
  /// (i : full Cutting(풀 컷팅), m : partial Cutting(하프 컷팅))
  factory HmcReceiptPrinterCommand.paperCutting() = PaperCutting._;

  /// 0x1C(FS) + 'W' + n
  ///
  /// n = 0 일때 가로2배, 세로2배 확대를 해제한다.
  /// n = 1 일때 가로2배, 세로2배 확대를 지정한다.
  factory HmcReceiptPrinterCommand.zoomFont({required String zoomFormat}) = ZoomFont._;

  factory HmcReceiptPrinterCommand.lineFeed({required String feedHeight}) = LineFeed._;

  factory HmcReceiptPrinterCommand.printerReset() = PrinterReset._;

  factory HmcReceiptPrinterCommand.printerBufferClear() = PrinterBufferClear._;

  factory HmcReceiptPrinterCommand.printerStatus(CommandCallback<String, String> callback) = PrinterStatus._;

  late HmcReceiptPrinterParsing serialDataParsing;
}

final class PrintText implements HmcReceiptPrinterCommand {
  final String printText;
  final bool isNewLine;

  PrintText._({required this.printText, this.isNewLine = true});

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  @override
  String templatizeToString() {
    String text = printText + (isNewLine ? serialDataParsing.newline : '');
    log(text);
    return text;
  }

  @override
  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();
}

final class PrintTextSpaceBetween implements HmcReceiptPrinterCommand {
  final String printText;
  final String splitter;
  final bool isNewLine;

  PrintTextSpaceBetween._({required this.printText, required this.splitter, this.isNewLine = true});

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  @override
  String templatizeToString() {
    String originalText = printText.replaceAll(splitter, '');
    int spareLength = calculateTextLength(originalText);
    String text;
    if (spareLength <= 0) {
      text = printText.replaceAll(splitter, '') + (isNewLine ? serialDataParsing.newline : '');
    } else {
      text = printText.replaceAll(splitter, serialDataParsing.spare.padLeft(spareLength, serialDataParsing.spare)) +
          (isNewLine ? serialDataParsing.newline : '');
    }

    log(text);
    return text;
  }

  @override
  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();
}

final class TextAlign implements HmcReceiptPrinterCommand {
  final String align;

  TextAlign._({required this.align});

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  @override
  String templatizeToString() {
    return serialDataParsing.esc + serialDataParsing.textAlign + align;
  }

  @override
  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();
}

final class PaperCutting implements HmcReceiptPrinterCommand {
  PaperCutting._();

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  @override
  String templatizeToString() {
    return serialDataParsing.esc + serialDataParsing.fullCutting;
  }

  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();
}

final class LineFeed implements HmcReceiptPrinterCommand {
  final String feedHeight;

  LineFeed._({required this.feedHeight});

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();

  @override
  String templatizeToString() {
    return serialDataParsing.esc + serialDataParsing.lineFeed + feedHeight;
  }
}

final class ZoomFont implements HmcReceiptPrinterCommand {
  final String zoomFormat;

  ZoomFont._({required this.zoomFormat});

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();

  @override
  String templatizeToString() {
    return serialDataParsing.fs + serialDataParsing.zoomText + zoomFormat;
  }
}

final class PrinterReset implements HmcReceiptPrinterCommand {
  PrinterReset._();

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();

  @override
  String templatizeToString() {
    return serialDataParsing.esc + serialDataParsing.resetPrinter;
  }
}

final class PrinterBufferClear implements HmcReceiptPrinterCommand {
  PrinterBufferClear._();

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();

  @override
  String templatizeToString() {
    return serialDataParsing.dle + serialDataParsing.enq + serialDataParsing.rightAlign;
  }
}

final class PrinterStatus implements HmcReceiptPrinterCommand {
  final CommandCallback<String, String> callback;

  PrinterStatus._(this.callback);

  @override
  void execute(HmcReceiptPrinterExternal external) async {
    await external.request(this);
  }

  HmcReceiptPrinterParsing serialDataParsing = HmcReceiptPrinterParsing();

  @override
  String templatizeToString() {
    return serialDataParsing.dle + serialDataParsing.eot + serialDataParsing.rightAlign;
  }
}
