import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:cat_diet_planner/core/widgets/app_error_state.dart';
import 'package:cat_diet_planner/features/food_database/screens/add_food_screen.dart';
import 'package:cat_diet_planner/features/scanner/services/scanner_product_service.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  static const _scanFrameWidth = 272.0;
  static const _scanFrameHeight = 188.0;

  final _barcodeController = TextEditingController(text: '123456789');
  final _scannerController = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 350,
    facing: kIsWeb ? CameraFacing.front : CameraFacing.back,
  );

  ScannerLookupResult? _lookupResult;
  StreamSubscription<BarcodeCapture>? _barcodeSubscription;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _barcodeSubscription = _scannerController.barcodes.listen(
      _onBarcodeCapture,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lookupBarcode();
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    unawaited(_barcodeSubscription?.cancel());
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeCapture(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (barcode == null || barcode.isEmpty) return;
    _barcodeController.text = barcode;
    await _lookupBarcode();
  }

  Future<void> _lookupBarcode() async {
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) return;

    setState(() => _isSearching = true);
    final result = await ScannerProductService.lookupByBarcode(barcode);
    if (!mounted) return;
    setState(() {
      _lookupResult = result;
      _isSearching = false;
    });
  }

  Future<void> _toggleFlash() async {
    await _scannerController.toggleTorch();
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera() async {
    await _scannerController.switchCamera();
    if (mounted) setState(() {});
  }

  Future<void> _confirmProduct(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result =
        _lookupResult ??
        await ScannerProductService.lookupByBarcode(_barcodeController.text);

    if (!context.mounted) return;

    if (result.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.productConfirmedFromDatabaseMessage(
              result.food?.name ?? l10n.foodGenericLabel,
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddFoodScreen(
          initialBarcode: result.barcode,
          initialFood: result.food,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = theme.colorScheme.primary;
    final result = _lookupResult;
    final foundFood = result?.food;
    return ValueListenableBuilder(
      valueListenable: _scannerController,
      builder: (context, scannerState, _) {
        final torchAvailable =
            scannerState.torchState != TorchState.unavailable;
        final torchEnabled = scannerState.torchState == TorchState.on;
        final showWebHint = kIsWeb && !scannerState.isRunning;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black.withValues(alpha: 0.75),
            elevation: 0,
            title: Text(l10n.scannerTitle),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: MobileScanner(
                  controller: _scannerController,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error) {
                    return Container(
                      color: const Color(0xFF101010),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: AppErrorState(
                          icon: Icons.videocam_off_rounded,
                          title: l10n.cameraUnavailableTitle,
                          description:
                              error.errorDetails?.message ??
                              l10n.cameraUnavailableDescription,
                          actionLabel: l10n.tryAgainAction,
                          onAction: () {
                            _scannerController.start();
                          },
                        ),
                      ),
                    );
                  },
                  overlayBuilder: (context, constraints) {
                    return _ScannerOverlay(
                      primary: primary,
                      frameSize: const Size(_scanFrameWidth, _scanFrameHeight),
                    );
                  },
                ),
              ),
              Positioned(
                left: 24,
                top: 24,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.32),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: _switchCamera,
                    icon: const Icon(
                      Icons.cameraswitch_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                top: 24,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.32),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: torchAvailable ? _toggleFlash : null,
                    icon: Icon(
                      torchEnabled
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (showWebHint)
                Positioned(
                  left: 24,
                  right: 24,
                  top: 88,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Text(
                      l10n.webCameraNotRunningHint,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 180,
                child: Column(
                  children: [
                    Text(
                      l10n.alignBarcodeWithinFrameTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _barcodeController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: l10n.typeBarcodeToSimulateScanHint,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _isSearching ? null : _lookupBarcode,
                          icon: _isSearching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.search_rounded),
                        ),
                      ),
                      onSubmitted: (_) => _lookupBarcode(),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 390;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                result?.exists == true
                                    ? Icons.inventory_2_rounded
                                    : Icons.qr_code_rounded,
                                color: primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  foundFood?.name ??
                                      (result == null
                                          ? l10n.noBarcodeScannedYetTitle
                                          : l10n.noProductFoundForBarcodeTitle(
                                              result.barcode,
                                            )),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                result?.exists == true
                                    ? Icons.check_circle
                                    : Icons.info_outline_rounded,
                                color: result?.exists == true
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              foundFood != null
                                  ? '${foundFood.brand ?? l10n.unknownBrandLabel} • ${foundFood.kcalPer100g.toStringAsFixed(0)} ${l10n.kcalPer100gLabel}'
                                  : result == null
                                  ? l10n.useLiveCameraOrBarcodeDescription
                                  : l10n.createFoodEntryFromBarcodeDescription,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (narrow)
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AddFoodScreen(
                                            initialBarcode:
                                                _barcodeController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _barcodeController.text
                                                      .trim(),
                                            initialFood: result?.food,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit_note_rounded),
                                    label: Text(
                                      result?.exists == true
                                          ? l10n.editManuallyAction
                                          : l10n.manualEntryAction,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed:
                                        _barcodeController.text.trim().isEmpty
                                        ? null
                                        : () => _confirmProduct(context),
                                    icon: const Icon(Icons.check_rounded),
                                    label: Text(
                                      result?.exists == true
                                          ? l10n.useProductAction
                                          : l10n.confirmProductAction,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AddFoodScreen(
                                            initialBarcode:
                                                _barcodeController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _barcodeController.text
                                                      .trim(),
                                            initialFood: result?.food,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit_note_rounded),
                                    label: Text(
                                      result?.exists == true
                                          ? l10n.editManuallyAction
                                          : l10n.manualEntryAction,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed:
                                        _barcodeController.text.trim().isEmpty
                                        ? null
                                        : () => _confirmProduct(context),
                                    icon: const Icon(Icons.check_rounded),
                                    label: Text(
                                      result?.exists == true
                                          ? l10n.useProductAction
                                          : l10n.confirmProductAction,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({required this.primary, required this.frameSize});

  final Color primary;
  final Size frameSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final left = (constraints.maxWidth - frameSize.width) / 2;
        final top = (constraints.maxHeight - frameSize.height) / 2;
        final frameRect = Rect.fromLTWH(
          left,
          top,
          frameSize.width,
          frameSize.height,
        );

        return IgnorePointer(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _ScannerMaskPainter(
                    frameRect: frameRect,
                    primary: primary,
                  ),
                ),
              ),
              Positioned(
                left: frameRect.left,
                top: frameRect.top,
                child: Container(
                  width: frameRect.width,
                  height: frameRect.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.18),
                        blurRadius: 26,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: frameRect.left + 14,
                right: constraints.maxWidth - frameRect.right + 14,
                top: frameRect.top + frameRect.height * 0.52,
                child: _ScannerSweepLine(primary: primary),
              ),
              Positioned(
                left: frameRect.left - 4,
                top: frameRect.top - 4,
                child: _CornerAccent(
                  primary: primary,
                  corner: Alignment.topLeft,
                ),
              ),
              Positioned(
                right: constraints.maxWidth - frameRect.right - 4,
                top: frameRect.top - 4,
                child: _CornerAccent(
                  primary: primary,
                  corner: Alignment.topRight,
                ),
              ),
              Positioned(
                left: frameRect.left - 4,
                bottom: constraints.maxHeight - frameRect.bottom - 4,
                child: _CornerAccent(
                  primary: primary,
                  corner: Alignment.bottomLeft,
                ),
              ),
              Positioned(
                right: constraints.maxWidth - frameRect.right - 4,
                bottom: constraints.maxHeight - frameRect.bottom - 4,
                child: _CornerAccent(
                  primary: primary,
                  corner: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScannerMaskPainter extends CustomPainter {
  const _ScannerMaskPainter({required this.frameRect, required this.primary});

  final Rect frameRect;
  final Color primary;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPath = Path()..addRect(Offset.zero & size);
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(26)));
    final mask = Path.combine(
      PathOperation.difference,
      overlayPath,
      cutoutPath,
    );

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.56),
          Colors.black.withValues(alpha: 0.36),
          Colors.black.withValues(alpha: 0.66),
        ],
        stops: const [0, 0.42, 1],
      ).createShader(Offset.zero & size);
    canvas.drawPath(mask, shadowPaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = primary.withValues(alpha: 0.24)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(26)),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerMaskPainter oldDelegate) {
    return oldDelegate.frameRect != frameRect || oldDelegate.primary != primary;
  }
}

class _CornerAccent extends StatelessWidget {
  const _CornerAccent({required this.primary, required this.corner});

  final Color primary;
  final Alignment corner;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(42, 42),
      painter: _CornerPainter(primary: primary, corner: corner),
    );
  }
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({required this.primary, required this.corner});

  final Color primary;
  final Alignment corner;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    const radius = 14.0;
    const arm = 28.0;

    if (corner == Alignment.topLeft) {
      path
        ..moveTo(arm, 0)
        ..lineTo(radius, 0)
        ..arcToPoint(
          const Offset(0, radius),
          radius: const Radius.circular(radius),
        )
        ..lineTo(0, arm);
    } else if (corner == Alignment.topRight) {
      path
        ..moveTo(size.width - arm, 0)
        ..lineTo(size.width - radius, 0)
        ..arcToPoint(
          Offset(size.width, radius),
          radius: const Radius.circular(radius),
        )
        ..lineTo(size.width, arm);
    } else if (corner == Alignment.bottomLeft) {
      path
        ..moveTo(0, size.height - arm)
        ..lineTo(0, size.height - radius)
        ..arcToPoint(
          Offset(radius, size.height),
          radius: const Radius.circular(radius),
        )
        ..lineTo(arm, size.height);
    } else {
      path
        ..moveTo(size.width - arm, size.height)
        ..lineTo(size.width - radius, size.height)
        ..arcToPoint(
          Offset(size.width, size.height - radius),
          radius: const Radius.circular(radius),
        )
        ..lineTo(size.width, size.height - arm);
    }

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = primary.withValues(alpha: 0.36)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.92);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) {
    return oldDelegate.primary != primary || oldDelegate.corner != corner;
  }
}

class _ScannerSweepLine extends StatefulWidget {
  const _ScannerSweepLine({required this.primary});

  final Color primary;

  @override
  State<_ScannerSweepLine> createState() => _ScannerSweepLineState();
}

class _ScannerSweepLineState extends State<_ScannerSweepLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_controller.value);
          final start = lerpDouble(-0.12, 0.38, t)!;
          final end = lerpDouble(0.28, 0.78, t)!;
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  widget.primary.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.98),
                  widget.primary.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                stops: [
                  math.max(0, start - 0.18),
                  math.max(0, start),
                  ((start + end) / 2).clamp(0, 1),
                  math.min(1, end),
                  math.min(1, end + 0.18),
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: Container(
              height: 2.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: widget.primary.withValues(alpha: 0.45),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
