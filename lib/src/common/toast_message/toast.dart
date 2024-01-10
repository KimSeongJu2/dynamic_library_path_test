import 'package:flutter/material.dart';

import 'simple_text_message.dart';
import 'toast_message.dart';

class Toast {
  static void showTopMessage(BuildContext context, String message,
      [int holdDuration = 2500, int animationDuration = 500, Alignment alignment = Alignment.topCenter]) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => ToastMessage(
        alignment: alignment,
        top: MediaQuery.of(context).size.height * 0.05,
        forwardDuration: Duration(milliseconds: animationDuration),
        holdDuration: Duration(milliseconds: holdDuration),
        reverseDuration: Duration(milliseconds: animationDuration),
        overlayEntry: overlayEntry,
        child: SimpleTextMessage(text: message),
      ),
    );

    overlay.insert(overlayEntry);
  }

  static void showBottomMessage(BuildContext context, String message,
      [int holdDuration = 500, int animationDuration = 500, Alignment alignment = Alignment.bottomCenter]) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => ToastMessage(
        alignment: alignment,
        bottom: MediaQuery.of(context).size.height * 0.15,
        forwardDuration: Duration(milliseconds: animationDuration),
        holdDuration: Duration(milliseconds: holdDuration),
        reverseDuration: Duration(milliseconds: animationDuration),
        overlayEntry: overlayEntry,
        child: SimpleTextMessage(text: message),
      ),
    );

    overlay.insert(overlayEntry);
  }
}
