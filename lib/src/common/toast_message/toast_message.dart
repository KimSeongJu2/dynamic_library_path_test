import 'package:flutter/material.dart';

class ToastMessage extends StatefulWidget {
  final Alignment alignment;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final Duration forwardDuration;
  final Duration holdDuration;
  final Duration reverseDuration;
  final Function? callback;
  final OverlayEntry overlayEntry;
  final Widget child;

  const ToastMessage({
    Key? key,
    required this.alignment,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.forwardDuration,
    required this.holdDuration,
    required this.reverseDuration,
    this.callback,
    required this.overlayEntry,
    required this.child,
  }) : super(key: key);

  @override
  State<ToastMessage> createState() => _ToastMessageState();
}

class _ToastMessageState extends State<ToastMessage> with SingleTickerProviderStateMixin {
  late final AnimationController _fadingAnimationController;
  late final Animation<double> _fadingAnimation;

  @override
  void initState() {
    super.initState();
    _fadingAnimationController =
        AnimationController(vsync: this, duration: widget.forwardDuration, reverseDuration: widget.reverseDuration);
    _fadingAnimation = CurveTween(curve: Curves.fastOutSlowIn).animate(_fadingAnimationController);

    _fadingAnimationController
        .forward()
        .whenComplete(() => Future.delayed(widget.holdDuration))
        .whenComplete(() => _fadingAnimationController.reverse())
        .whenComplete(() => widget.callback?.call())
        .whenComplete(() => widget.overlayEntry.remove());
  }

  @override
  void dispose() {
    _fadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      children: [
        Positioned(
          left: widget.left,
          top: widget.top,
          right: widget.right,
          bottom: widget.bottom,
          width: widget.width,
          height: widget.height,
          child: FadeTransition(
            opacity: _fadingAnimation,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: widget.child,
            ),
          ),
        )
      ],
    );
  }
}
