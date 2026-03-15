import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalPointerScroll extends StatefulWidget {
  const HorizontalPointerScroll({
    super.key,
    required this.child,
    this.clipBehavior = Clip.hardEdge,
    this.thumbVisibility = false,
  });

  final Widget child;
  final Clip clipBehavior;
  final bool thumbVisibility;

  @override
  State<HorizontalPointerScroll> createState() =>
      _HorizontalPointerScrollState();
}

class _HorizontalPointerScrollState extends State<HorizontalPointerScroll> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent || !_controller.hasClients) return;

    final delta = signal.scrollDelta.dx != 0
        ? signal.scrollDelta.dx
        : signal.scrollDelta.dy;
    if (delta == 0) return;

    final position = _controller.position;
    final target = (_controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target == _controller.offset) return;
    _controller.jumpTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
            PointerDeviceKind.invertedStylus,
            PointerDeviceKind.unknown,
          },
        ),
        child: Scrollbar(
          controller: _controller,
          thumbVisibility: widget.thumbVisibility,
          notificationPredicate: (notification) =>
              notification.metrics.axis == Axis.horizontal,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            clipBehavior: widget.clipBehavior,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
