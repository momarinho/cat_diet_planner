import 'dart:math' as math;

import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/data/repositories/daily_schedule_repository.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/daily/providers/daily_schedule_repository_provider.dart';
import 'package:cat_diet_planner/features/history/providers/weight_repository_provider.dart';
import 'package:cat_diet_planner/features/history/services/weekly_report_export_service.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WeeklyDietReportScreen extends ConsumerWidget {
  const WeeklyDietReportScreen({super.key});

  static const _months = [
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

  List<WeightRecord> _resolveRecords({
    required List<WeightRecord> source,
    required int rangeDays,
  }) {
    final sorted = [...source]..sort((a, b) => a.date.compareTo(b.date));
    if (sorted.isEmpty) return sorted;
    final cutoff = DateTime.now().subtract(Duration(days: rangeDays - 1));
    final filtered = sorted
        .where((record) => !record.date.isBefore(cutoff))
        .toList();
    return filtered;
  }

  String _formatRange(DateTime start, DateTime end) {
    return '${_months[start.month - 1]} ${start.day} - ${_months[end.month - 1]} ${end.day}, ${end.year}';
  }

  List<_DailyIntakeRow> _buildIntakeRows({
    required String catId,
    required DietPlan? plan,
    required int rangeDays,
    required DailyScheduleRepository scheduleRepository,
  }) {
    final now = DateTime.now();
    final rows = <_DailyIntakeRow>[];

    for (var offset = rangeDays - 1; offset >= 0; offset--) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: offset));
      final key = scheduleRepository.catDayKey(catId, date);
      final schedule = scheduleRepository.readSchedule(key);
      final items = ((schedule?['items'] as List?) ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .where((item) => item['type'] == 'meal')
          .toList();

      final intake = items
          .where((item) => item['completed'] == true)
          .fold<double>(0, (sum, item) => sum + _extractKcal(item['subtitle']));
      final goal = plan?.targetKcalPerDay ?? 0.0;
      final status = goal <= 0
          ? _DailyIntakeStatus.none
          : intake > goal * 1.05
          ? _DailyIntakeStatus.above
          : intake < goal * 0.8
          ? _DailyIntakeStatus.below
          : _DailyIntakeStatus.onTrack;

      rows.add(
        _DailyIntakeRow(
          label: '${_months[date.month - 1]} ${date.day}',
          intake: intake,
          goal: goal,
          status: status,
        ),
      );
    }

    return rows;
  }

  double _extractKcal(dynamic subtitle) {
    final text = subtitle?.toString() ?? '';
    final match = RegExp(r'(\d+(?:\.\d+)?)\s*kcal').firstMatch(text);
    return double.tryParse(match?.group(1) ?? '') ?? 0.0;
  }

  String _buildNote({
    required String catName,
    required List<WeightRecord> records,
    required List<_DailyIntakeRow> rows,
  }) {
    if (records.isEmpty && rows.every((row) => row.intake == 0)) {
      return 'No weekly data was recorded yet. Start logging meals and weight to unlock more reliable guidance.';
    }

    final latest = records.isNotEmpty ? records.last.weight : null;
    final first = records.length > 1 ? records.first.weight : latest;
    final delta = latest != null && first != null ? latest - first : null;
    final onTrackDays = rows
        .where((row) => row.status == _DailyIntakeStatus.onTrack)
        .length;
    final completedDays = rows.where((row) => row.intake > 0).length;

    final trendSentence = delta == null
        ? '$catName still needs more weight records for a reliable trend.'
        : delta.abs() < 0.1
        ? '$catName stayed stable this week.'
        : delta > 0
        ? '$catName gained ${delta.toStringAsFixed(1)} kg this week.'
        : '$catName lost ${delta.abs().toStringAsFixed(1)} kg this week.';

    final intakeSentence = completedDays == 0
        ? 'No meals were marked as completed during the last 7 days.'
        : '$onTrackDays of the last 7 days stayed close to the calorie target.';

    return '$trendSentence $intakeSentence Continue monitoring appetite, hydration, and daily activity.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(selectedCatProvider);
    final settings = ref.watch(appSettingsProvider);
    final planRepository = ref.read(planRepositoryProvider);
    final scheduleRepository = ref.read(dailyScheduleRepositoryProvider);
    final rangeDays = settings.reportRangeDays == -1
        ? settings.customReportRangeDays
        : settings.reportRangeDays;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    if (selectedCat == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Weekly Diet Report'),
          centerTitle: true,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.pets_rounded,
              title: 'No active cat',
              description:
                  'Select a cat from Home before opening weekly report.',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Diet Report'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: ref.read(weightRepositoryProvider).weightsListenable(),
        builder: (context, Box<WeightRecord> box, _) {
          final sourceRecords = ref
              .read(weightRepositoryProvider)
              .recordsForCatFromBox(
                box,
                selectedCat.id,
                fallbackHistory: selectedCat.weightHistory,
                newestFirst: false,
              );
          final records = _resolveRecords(
            source: sourceRecords,
            rangeDays: rangeDays,
          );
          final latest = records.isNotEmpty ? records.last : null;
          final first = records.isNotEmpty ? records.first : null;
          final rangeLabel = records.isEmpty
              ? 'No period selected'
              : _formatRange(first!.date, latest!.date);
          final plan = planRepository.getPlanForCat(selectedCat.id);
          final intakeRows = _buildIntakeRows(
            catId: selectedCat.id,
            plan: plan,
            rangeDays: rangeDays,
            scheduleRepository: scheduleRepository,
          );
          final note = _buildNote(
            catName: selectedCat.name,
            records: records,
            rows: intakeRows,
          );

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
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primary.withValues(alpha: 0.20),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: catPhotoProvider(
                                    photoPath: selectedCat.photoPath,
                                    photoBase64: selectedCat.photoBase64,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedCat.name,
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
                                    const SizedBox(height: 4),
                                    Text(
                                      'Range: last $rangeDays day(s)',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: secondary,
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
                            height: 200,
                            child: _WeightTrendChart(
                              records: records,
                              targetWeight: latest?.weight,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 18,
                            runSpacing: 8,
                            children: [
                              _LegendDot(color: primary, label: 'Actual'),
                              _LegendDot(
                                color: const Color(0xFF31C178),
                                label: 'Current target',
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
                          _CalorieTable(
                            rows: intakeRows,
                            primary: primary,
                            secondary: secondary,
                          ),
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
                                  note,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    height: 1.5,
                                    color: secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final narrow = constraints.maxWidth < 360;
                                    return narrow
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'CatDiet Planner Summary',
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: const Color(
                                                        0xFF7B8DA8,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: primary.withValues(
                                                    alpha: 0.12,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Text(
                                                  'AUTO',
                                                  style: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: primary,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                'CatDiet Planner Summary',
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: const Color(
                                                        0xFF7B8DA8,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: primary.withValues(
                                                    alpha: 0.12,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Text(
                                                  'AUTO',
                                                  style: theme
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                        color: primary,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                  },
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 420;
                    if (narrow) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await WeeklyReportExportService.downloadPdf(
                                    cat: selectedCat,
                                    records: records,
                                    settings: settings,
                                  );
                                },
                                icon: const Icon(Icons.download_rounded),
                                label: const Text('Download PDF'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  foregroundColor: theme.colorScheme.onSurface,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () async {
                                await WeeklyReportExportService.shareReport(
                                  cat: selectedCat,
                                  records: records,
                                  settings: settings,
                                );
                              },
                              icon: const Icon(Icons.share_rounded),
                              label: const Text('Share via WhatsApp'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF31C178),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await WeeklyReportExportService.downloadPdf(
                                  cat: selectedCat,
                                  records: records,
                                  settings: settings,
                                );
                              },
                              icon: const Icon(Icons.download_rounded),
                              label: const Text('Download PDF'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                foregroundColor: theme.colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              await WeeklyReportExportService.shareReport(
                                cat: selectedCat,
                                records: records,
                                settings: settings,
                              );
                            },
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
                    );
                  },
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
  const _WeightTrendChart({required this.records, required this.targetWeight});

  final List<WeightRecord> records;
  final double? targetWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final values = records.map((record) => record.weight).toList();
    final allValues = [...values];
    final target = targetWeight;
    if (target != null) {
      allValues.add(target);
    }
    final minWeight = allValues.isEmpty
        ? 3.5
        : allValues.reduce(math.min) - 0.2;
    final maxWeight = allValues.isEmpty
        ? 5.0
        : allValues.reduce(math.max) + 0.2;
    final labels = records.isEmpty
        ? const ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7']
        : records
              .map(
                (record) =>
                    '${WeeklyDietReportScreen._months[record.date.month - 1]} ${record.date.day}',
              )
              .toList();

    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: const Size(double.infinity, 150),
            painter: _TrendPainter(
              records: records,
              targetWeight: targetWeight,
              minWeight: minWeight,
              maxWeight: maxWeight,
              lineColor: theme.colorScheme.primary,
              targetColor: const Color(0xFF31C178),
              gridColor: theme.dividerColor.withValues(alpha: 0.30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map((label) => Flexible(child: _AxisDayLabel(label)))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              minWeight.toStringAsFixed(1),
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
            const Spacer(),
            Text(
              ((minWeight + maxWeight) / 2).toStringAsFixed(1),
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
            const Spacer(),
            Text(
              maxWeight.toStringAsFixed(1),
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.records,
    required this.targetWeight,
    required this.minWeight,
    required this.maxWeight,
    required this.lineColor,
    required this.targetColor,
    required this.gridColor,
  });

  final List<WeightRecord> records;
  final double? targetWeight;
  final double minWeight;
  final double maxWeight;
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
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (targetWeight != null) {
      final targetPaint = Paint()
        ..color = targetColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final targetY = _weightToY(targetWeight!, size.height);
      canvas.drawLine(
        Offset(0, targetY),
        Offset(size.width, targetY),
        targetPaint,
      );
    }

    if (records.isEmpty) return;

    final stepX = records.length == 1
        ? size.width / 2
        : size.width / (records.length - 1);
    final points = <Offset>[];
    for (var i = 0; i < records.length; i++) {
      points.add(Offset(i * stepX, _weightToY(records[i].weight, size.height)));
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
    final normalized = ((weight - minWeight) / (maxWeight - minWeight)).clamp(
      0.0,
      1.0,
    );
    return height - (normalized * height);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.records != records ||
        oldDelegate.targetWeight != targetWeight ||
        oldDelegate.minWeight != minWeight ||
        oldDelegate.maxWeight != maxWeight;
  }
}

class _CalorieTable extends StatelessWidget {
  const _CalorieTable({
    required this.rows,
    required this.primary,
    required this.secondary,
  });

  final List<_DailyIntakeRow> rows;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final average = rows.isEmpty
        ? 0.0
        : rows.fold<double>(0, (sum, row) => sum + row.intake) / rows.length;
    final averageGoal = rows.isEmpty
        ? 0.0
        : rows.fold<double>(0, (sum, row) => sum + row.goal) / rows.length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.4),
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
            if (rows.isEmpty)
              const TableRow(
                children: [
                  _TableCell(text: '--'),
                  _TableCell(text: '--'),
                  _TableCell(text: '--'),
                  SizedBox.shrink(),
                ],
              )
            else
              ...rows.map((row) {
                return TableRow(
                  children: [
                    _TableCell(text: row.label),
                    _TableCell(
                      text: row.intake.toStringAsFixed(0),
                      color: row.status == _DailyIntakeStatus.above
                          ? const Color(0xFFE48A18)
                          : null,
                      fontWeight: row.status == _DailyIntakeStatus.above
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                    _TableCell(
                      text: row.goal.toStringAsFixed(0),
                      color: secondary,
                    ),
                    _StatusCell(status: row.status),
                  ],
                );
              }),
            TableRow(
              children: [
                const _TableCell(text: 'Avg', fontWeight: FontWeight.w700),
                _TableCell(
                  text: average.toStringAsFixed(0),
                  fontWeight: FontWeight.w900,
                ),
                _TableCell(
                  text: averageGoal.toStringAsFixed(0),
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox.shrink(),
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
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: secondary,
        fontSize: 11,
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
  const _StatusCell({required this.status});

  final _DailyIntakeStatus status;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (status) {
      _DailyIntakeStatus.onTrack => (
        Icons.check_circle_outline_rounded,
        const Color(0xFF31C178),
      ),
      _DailyIntakeStatus.above => (
        Icons.warning_amber_rounded,
        const Color(0xFFE48A18),
      ),
      _DailyIntakeStatus.below => (
        Icons.remove_circle_outline_rounded,
        const Color(0xFF7B8DA8),
      ),
      _DailyIntakeStatus.none => (
        Icons.horizontal_rule_rounded,
        const Color(0xFFB0B7C3),
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Icon(icon, color: color),
    );
  }
}

class _DailyIntakeRow {
  const _DailyIntakeRow({
    required this.label,
    required this.intake,
    required this.goal,
    required this.status,
  });

  final String label;
  final double intake;
  final double goal;
  final _DailyIntakeStatus status;
}

enum _DailyIntakeStatus { onTrack, above, below, none }
