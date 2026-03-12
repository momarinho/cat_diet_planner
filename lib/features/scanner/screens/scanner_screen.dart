import 'dart:async';

import 'package:cat_diet_planner/features/food_database/screens/add_food_screen.dart';
import 'package:cat_diet_planner/features/scanner/services/scanner_product_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
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
    final result =
        _lookupResult ??
        await ScannerProductService.lookupByBarcode(_barcodeController.text);

    if (!context.mounted) return;

    if (result.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${result.food?.name ?? 'Food'} confirmed from database',
          ),
        ),
      );
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddFoodScreen(initialBarcode: result.barcode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            title: const Text('Scanner'),
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
                      child: Text(
                        error.errorDetails?.message ??
                            'Unable to start camera. On web, use localhost or https and allow camera access.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    );
                  },
                  overlayBuilder: (context, constraints) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: IgnorePointer(
                  child: Container(
                    width: 260,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primary, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  ),
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
                      'Web camera not running yet. Test one browser tab at a time, allow camera access, and try the switch-camera button.',
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
                      'Align barcode within frame',
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
                        hintText: 'Type barcode to simulate scan',
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
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: primary.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
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
                                      ? 'No barcode scanned yet'
                                      : 'No product found for ${result.barcode}'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
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
                              ? '${foundFood.brand ?? 'Unknown brand'} • ${foundFood.kcalPer100g.toStringAsFixed(0)} kcal/100g'
                              : result == null
                              ? 'Use the live camera or the barcode field above.'
                              : 'You can create a new food entry with this barcode.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddFoodScreen(
                                      initialBarcode:
                                          _barcodeController.text.trim().isEmpty
                                          ? null
                                          : _barcodeController.text.trim(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_note_rounded),
                              label: Text(
                                result?.exists == true
                                    ? 'Edit Manually'
                                    : 'Manual Entry',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _barcodeController.text.trim().isEmpty
                                  ? null
                                  : () => _confirmProduct(context),
                              icon: const Icon(Icons.check_rounded),
                              label: Text(
                                result?.exists == true
                                    ? 'Use Product'
                                    : 'Confirm Product',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
