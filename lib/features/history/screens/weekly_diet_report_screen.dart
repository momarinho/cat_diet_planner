import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WeeklyDietReportScreen extends StatelessWidget {
  const WeeklyDietReportScreen({super.key});

  List<WeightRecord> _lastSeven(List<WeightRecord> records) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));
    if (sorted.length <= 7) return sorted;
    return sorted.sublist(sorted.length - 7);
  }

  String _formatRange(DateTime start, DateTime end) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${end.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Diet Report'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.weightsBox.listenable(),
        builder: (context, Box<WeightRecord> box, _) {
          final allRecords = box.values.toList()
            ..sort((a, b) => a.date.compareTo(b.date));
          final records = _lastSeven(allRecords);
          final latest = records.isNotEmpty ? records.last : null;
          final first = records.isNotEmpty ? records.first : null;
          final rangeLabel = records.isEmpty
              ? 'No period selected'
              : _formatRange(first!.date, latest!.date);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=200&q=80',
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Luna',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rangeLabel,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: const Color(0xFF7B8DA8),
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.pets_rounded, color: primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Divider(color: primary.withValues(alpha: 0.10)),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Icon(
                                Icons.show_chart_rounded,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Weight Trend (kg)',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180,
                            child: _WeightTrendChart(records: records),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LegendDot(color: primary, label: 'Actual'),
                              const SizedBox(width: 18),
                              _LegendDot(
                                color: const Color(0xFF31C178),
                                label: 'Target (4.2kg)',
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant_rounded,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Calorie Intake',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _CalorieTable(primary: primary, secondary: secondary),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: 20,
                                color: primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Veterinary Notes',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.dark
                                  ? const Color(0xFF2B2426)
                                  : const Color(0xFFFFF5F7),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: primary.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  latest == null
                                      ? 'No weight data was recorded this week.'
                                      : 'Luna is making great progress. Weight is ${latest.weight.toStringAsFixed(1)}kg and the weekly trend remains stable. Continue current feeding plan and maintain daily 20-minute play sessions.',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    height: 1.5,
                                    color: secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Text(
                                      '- Dr. Sarah Jenkins',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: const Color(0xFF7B8DA8),
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primary.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        'VERIFIED',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              color: primary,
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 26),
                          Center(
                            child: Text(
                              'CATDIET PLANNER REPORT',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: primary.withValues(alpha: 0.22),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Download PDF'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            foregroundColor: theme.colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_rounded),
                        label: const Text('Share via WhatsApp'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF31C178),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeightTrendChart extends StatelessWidget {
  const _WeightTrendChart({required this.records});

  final List<WeightRecord> records;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: const Size(double.infinity, 140),
            painter: _TrendPainter(
              records: records,
              lineColor: theme.colorScheme.primary,
              targetColor: const Color(0xFF31C178),
              gridColor: theme.dividerColor.withValues(alpha: 0.30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _AxisDayLabel('Mon'),
            _AxisDayLabel('Tue'),
            _AxisDayLabel('Wed'),
            _AxisDayLabel('Thu'),
            _AxisDayLabel('Fri'),
            _AxisDayLabel('Sat'),
            _AxisDayLabel('Sun'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('4.0', style: TextStyle(color: secondary, fontSize: 11)),
            const Spacer(),
            Text('4.2', style: TextStyle(color: secondary, fontSize: 11)),
            const Spacer(),
            Text('4.4', style: TextStyle(color: secondary, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.records,
    required this.lineColor,
    required this.targetColor,
    required this.gridColor,
  });

  final List<WeightRecord> records;
  final Color lineColor;
  final Color targetColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var i = 0; i < 3; i++) {
      final y = size.height * (i / 2);
      canvas.drawLine(
        Offset.zero.translate(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final targetPaint = Paint()
      ..color = targetColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const targetWeight = 4.2;
    final targetY = _weightToY(targetWeight, size.height);
    canvas.drawLine(
      Offset(0, targetY),
      Offset(size.width, targetY),
      targetPaint..strokeCap = StrokeCap.round,
    );

    if (records.isEmpty) return;

    final values = records.map((r) => r.weight).toList();
    while (values.length < 7) {
      values.insert(0, values.isNotEmpty ? values.first : 4.2);
    }

    final stepX = size.width / 6;
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      points.add(Offset(i * stepX, _weightToY(values[i], size.height)));
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = Colors.white;
    final ringPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final point in points) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(point, 5, ringPaint);
    }
  }

  double _weightToY(double weight, double height) {
    const minWeight = 4.0;
    const maxWeight = 4.4;
    final normalized = ((weight - minWeight) / (maxWeight - minWeight)).clamp(
      0.0,
      1.0,
    );
    return height - (normalized * height);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.records != records;
  }
}

class _CalorieTable extends StatelessWidget {
  const _CalorieTable({required this.primary, required this.secondary});

  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Mon', 245, 250, true, false),
      ('Tue', 255, 250, true, false),
      ('Wed', 280, 250, false, true),
      ('Thu', 240, 250, true, false),
      ('Fri', 250, 250, true, false),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1.1),
            2: FlexColumnWidth(1.0),
            3: FlexColumnWidth(0.8),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: primary.withValues(alpha: 0.06)),
              children: const [
                _TableHeader('DAY'),
                _TableHeader('INTAKE'),
                _TableHeader('GOAL'),
                _TableHeader('STATUS'),
              ],
            ),
            ...rows.map((row) {
              return TableRow(
                children: [
                  _TableCell(text: row.$1),
                  _TableCell(
                    text: '${row.$2}',
                    color: row.$5 ? const Color(0xFFE48A18) : null,
                    fontWeight: row.$5 ? FontWeight.w900 : FontWeight.w700,
                  ),
                  _TableCell(text: '${row.$3}', color: secondary),
                  _StatusCell(success: row.$4, warning: row.$5),
                ],
              );
            }),
            const TableRow(
              children: [
                _TableCell(text: 'Avg', fontWeight: FontWeight.w700),
                _TableCell(text: '254', fontWeight: FontWeight.w900),
                _TableCell(text: '250', fontWeight: FontWeight.w700),
                SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final secondary =
        Theme.of(
          context,
        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: secondary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _AxisDayLabel extends StatelessWidget {
  const _AxisDayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final secondary =
        Theme.of(
          context,
        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);
    return Text(
      label,
      style: TextStyle(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final secondary =
        Theme.of(
          context,
        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Text(
        text,
        style: TextStyle(
          color: secondary,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    this.color,
    this.fontWeight = FontWeight.w700,
  });

  final String text;
  final Color? color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.onSurface,
          fontWeight: fontWeight,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.success, required this.warning});

  final bool success;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final icon = success
        ? Icons.check_circle_outline_rounded
        : Icons.warning_amber_rounded;
    final color = success ? const Color(0xFF31C178) : const Color(0xFFE48A18);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Icon(icon, color: color),
    );
  }
}
