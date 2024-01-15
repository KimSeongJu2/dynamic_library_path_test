import 'dart:developer';

import '../../../external/receipt_printer/hmc_receipt_printer_external.dart';
import '../../command.dart';

part 'hmc_receipt_printer_command.dart';

class HmcReceiptPrinterParsing {
  final String newline = String.fromCharCode(0x0A);

  /// 0x1A = SUB
  final String sub = String.fromCharCode(0x1a);

  /// 0x1B = ESC
  final String esc = String.fromCharCode(0x1b);

  /// 0x1C = FS
  final String fs = String.fromCharCode(0x1c);

  /// 0x1D = GS
  final String gs = String.fromCharCode(0x1d);

  /// 0x10 = DLE
  final String dle = String.fromCharCode(0x10);

  /// 0x04 EOT
  final String eot = String.fromCharCode(0x04);

  /// 0x05 ENQ
  final String enq = String.fromCharCode(0x05);

  // Printer Packet
  final String applyFormat = String.fromCharCode(0x01);
  final String clearFormat = String.fromCharCode(0x00);
  final String leftAlign = String.fromCharCode(0x00);
  final String centerAlign = String.fromCharCode(0x01);
  final String rightAlign = String.fromCharCode(0x02);
  final String feedHeight1 = String.fromCharCode(0x32);
  final String feedHeight2 = String.fromCharCode(0x34);
  final String feedHeight3 = String.fromCharCode(0x40);
  final String feedHeight4 = String.fromCharCode(0x50);
  final String feedHeight5 = String.fromCharCode(0x64);

  // Printer Command
  final String changeMode = 'x';
  final String textAlign = 'a';
  final String leftPadding = 'L';
  final String enlargeText = '!';
  final String zoomText = 'W';
  final String fullCutting = 'i';
  final String partialCutting = 'm';
  final String resetPrinter = '@';
  final String bold = 'E';
  final String underline = '-';
  final String lineFeed = 'J';
  final String backLineFeed = 'j';

  // Print Form
  final String splitter = "{#}";
  final String divide = '-';
  final String spare = ' ';

  HmcReceiptPrinterParsing._();

  static final HmcReceiptPrinterParsing _instance = HmcReceiptPrinterParsing._();

  static HmcReceiptPrinterParsing get instance => _instance;

  factory HmcReceiptPrinterParsing() {
    return _instance;
  }
}

extension on HmcReceiptPrinterCommand {
  // 제일 끝이 36 길이지만 너무 오른쪽에 붙어서 1자리 여백을 준다.
  static const int lengthForPaperMaxText = 36 - 1;

  // int calculateByteLength(String inputString) {
  //   int byteLength = 0;
  //
  //   for (int i = 0; i < inputString.length; i++) {
  //     int charCode = inputString.codeUnitAt(i);
  //
  //     // 한글인지 확인 (한글 유니코드 범위: 0xAC00 ~ 0xD7A3)
  //     if ((charCode >= 0xAC00 && charCode <= 0xD7A3) ||
  //         // 추가적인 한글 범위: 0x3130 ~ 0x318F
  //         (charCode >= 0x3130 && charCode <= 0x318F) ||
  //         // 한글 자모음 범위
  //         (charCode >= 0x1100 && charCode <= 0x11FF) ||
  //         // 한글 자모 확장 A
  //         (charCode >= 0xA960 && charCode <= 0xA97F) ||
  //         // 한글 자모 확장 B
  //         (charCode >= 0xD7B0 && charCode <= 0xD7FF)) {
  //       byteLength += 2;
  //     } else {
  //       byteLength += 1;
  //     }
  //   }
  //   return byteLength;
  // }

  int calculateTextLength(String input) {
    return lengthForPaperMaxText -
        input.runes.map((int charCode) {
          if ((charCode >= 0xAC00 && charCode <= 0xD7A3) ||
              (charCode >= 0x3130 && charCode <= 0x318F) ||
              (charCode >= 0x1100 && charCode <= 0x11FF) ||
              (charCode >= 0xA960 && charCode <= 0xA97F) ||
              (charCode >= 0xD7B0 && charCode <= 0xD7FF)) {
            return 2;
          } else {
            return 1;
          }
        }).fold(0, (int total, int byteCount) => total + byteCount);
  }
}
