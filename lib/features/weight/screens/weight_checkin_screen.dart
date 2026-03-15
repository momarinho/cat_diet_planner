import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/widgets/app_loading_state.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/history/providers/weight_repository_provider.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightCheckInScreen extends ConsumerStatefulWidget {
  const WeightCheckInScreen({super.key});

  @override
  ConsumerState<WeightCheckInScreen> createState() =>
      _WeightCheckInScreenState();
}

class _WeightCheckInScreenState extends ConsumerState<WeightCheckInScreen> {
  double _weight = 5.0;
  WeightRecord? _latestRecord;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _clinicalAssessmentController =
      TextEditingController();
  final TextEditingController _clinicalPlanController = TextEditingController();
  bool _isSaving = false;
  DateTime _checkInDateTime = DateTime.now();
  String _weightContext = 'fasting';
  String _appetite = 'normal';
  String _stool = 'normal';
  String _vomit = 'none';
  String _energy = 'normal';

  @override
  void initState() {
    super.initState();
    _loadLatestWeight();
  }

  void _loadLatestWeight() {
    final selectedCat = ref.read(selectedCatProvider);
    if (selectedCat == null) return;
    final records = ref
        .read(weightRepositoryProvider)
        .recordsForCat(
          selectedCat.id,
          fallbackHistory: selectedCat.weightHistory,
          newestFirst: true,
        );

    if (records.isEmpty) return;

    final latest = records.first;

    setState(() {
      _latestRecord = latest;
      _weight = latest.weight;
    });
  }

  void _appendSuggestion(String suggestion) {
    final current = _notesController.text.trim();
    final next = current.isEmpty ? suggestion : '$current, $suggestion';
    setState(() => _notesController.text = next);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _clinicalAssessmentController.dispose();
    _clinicalPlanController.dispose();
    super.dispose();
  }

  Future<void> _recordWeight() async {
    setState(() => _isSaving = true);
    try {
      final notes = _notesController.text.trim();
      final selectedCat = ref.read(selectedCatProvider);
      if (selectedCat == null) return;
      final previousWeight = selectedCat.weightHistory.isNotEmpty
          ? (selectedCat.weightHistory
                  ..sort((a, b) => a.date.compareTo(b.date)))
                .last
                .weight
          : _latestRecord?.weight;
      final deltaAbs = previousWeight == null
          ? 0.0
          : (_weight - previousWeight).abs();
      final deltaPercent = previousWeight == null || previousWeight == 0
          ? 0.0
          : (deltaAbs / previousWeight) * 100;
      final thresholdByKg = selectedCat.weightAlertDeltaKg;
      final thresholdByPercent = selectedCat.weightAlertDeltaPercent;
      final goalMin = selectedCat.weightGoalMinKg;
      final goalMax = selectedCat.weightGoalMaxKg;
      final outOfGoalRange =
          (goalMin != null && _weight < goalMin) ||
          (goalMax != null && _weight > goalMax);
      final alertTriggered =
          (thresholdByKg != null && deltaAbs >= thresholdByKg) ||
          (thresholdByPercent != null && deltaPercent >= thresholdByPercent) ||
          outOfGoalRange;
      final clinicalAlertLevel = alertTriggered
          ? 'high'
          : outOfGoalRange
          ? 'watch'
          : 'none';

      final record = WeightRecord(
        catId: selectedCat.id,
        date: _checkInDateTime,
        weight: _weight,
        notes: notes.isEmpty ? null : notes,
        weightContext: _weightContext,
        appetite: _appetite,
        stool: _stool,
        vomit: _vomit,
        energy: _energy,
        clinicalAssessment: _clinicalAssessmentController.text.trim().isEmpty
            ? null
            : _clinicalAssessmentController.text.trim(),
        clinicalPlan: _clinicalPlanController.text.trim().isEmpty
            ? null
            : _clinicalPlanController.text.trim(),
        clinicalAlertLevel: clinicalAlertLevel,
        alertTriggered: alertTriggered,
      );

      await ref.read(weightRepositoryProvider).addRecord(record);
      selectedCat.weight = _weight;
      selectedCat.weightHistory = [...selectedCat.weightHistory, record]
        ..sort((a, b) => a.date.compareTo(b.date));
      await selectedCat.save();
      ref.read(selectedCatProvider.notifier).state = selectedCat;

      if (!mounted) return;

      setState(() {
        _latestRecord = record;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            alertTriggered
                ? AppLocalizations.of(context).weightRecordedWithAlertMessage
                : AppLocalizations.of(context).weightRecordedMessage,
          ),
        ),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  List<String> _noteSuggestions(AppLocalizations l10n) => [
    l10n.weightNoteSuggestionHighAppetite,
    l10n.weightNoteSuggestionEnergetic,
    l10n.weightNoteSuggestionLazyDay,
  ];

  String _weightContextLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'fasting':
        return l10n.weightContextFastingOption;
      case 'after_meal':
        return l10n.weightContextAfterMealOption;
      case 'different_scale':
        return l10n.weightContextDifferentScaleOption;
      default:
        return l10n.otherOption;
    }
  }

  String _appetiteLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'poor':
        return l10n.poorOption;
      case 'reduced':
        return l10n.reducedOption;
      case 'high':
        return l10n.highOption;
      default:
        return l10n.normalOption;
    }
  }

  String _stoolLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'none':
        return l10n.noneOption;
      case 'soft':
        return l10n.softOption;
      case 'hard':
        return l10n.hardOption;
      case 'diarrhea':
        return l10n.diarrheaOption;
      default:
        return l10n.normalOption;
    }
  }

  String _vomitLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'occasional':
        return l10n.occasionalOption;
      case 'frequent':
        return l10n.frequentOption;
      default:
        return l10n.noneOption;
    }
  }

  String _energyLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'low':
        return l10n.lowOption;
      case 'high':
        return l10n.highOption;
      default:
        return l10n.normalOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCat = ref.watch(selectedCatProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    if (selectedCat == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.weightCheckInTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.monitor_weight_outlined,
              title: l10n.noActiveCatTitle,
              description: l10n.noActiveCatDescription,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weightCheckInTitle),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
        children: [
          _SectionCard(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 430;
                final avatar = Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primary.withValues(alpha: 0.32),
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
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.monitor_heart_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );

                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCat.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _latestRecord == null
                          ? l10n.noPreviousCheckInLabel
                          : l10n.lastCheckInLabel(
                              AppFormatters.formatDate(
                                context,
                                _latestRecord!.date,
                              ),
                            ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF7B8DA8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.recordingNowLabel(
                        AppFormatters.formatDate(context, _checkInDateTime),
                        AppFormatters.formatTime(context, _checkInDateTime),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );

                final latestWeight = Column(
                  crossAxisAlignment: narrow
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.lastWeightLabel,
                      textAlign: narrow ? TextAlign.left : TextAlign.right,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: primary,
                        ),
                        children: [
                          TextSpan(
                            text: (_latestRecord?.weight ?? _weight)
                                .toStringAsFixed(1),
                          ),
                          TextSpan(
                            text: ' ${l10n.kgUnit}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avatar,
                          const SizedBox(width: 16),
                          Expanded(child: details),
                        ],
                      ),
                      const SizedBox(height: 16),
                      latestWeight,
                    ],
                  );
                }

                return Row(
                  children: [
                    avatar,
                    const SizedBox(width: 16),
                    Expanded(child: details),
                    latestWeight,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.event_note_rounded, color: primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.checkInDateTimeTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _checkInDateTime,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 3650),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked == null) return;
                        setState(() {
                          _checkInDateTime = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            _checkInDateTime.hour,
                            _checkInDateTime.minute,
                          );
                        });
                      },
                      icon: const Icon(Icons.event_rounded),
                      label: Text(
                        AppFormatters.formatDate(context, _checkInDateTime),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: _checkInDateTime.hour,
                            minute: _checkInDateTime.minute,
                          ),
                        );
                        if (picked == null) return;
                        setState(() {
                          _checkInDateTime = DateTime(
                            _checkInDateTime.year,
                            _checkInDateTime.month,
                            _checkInDateTime.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      },
                      icon: const Icon(Icons.schedule_rounded),
                      label: Text(
                        AppFormatters.formatTime(context, _checkInDateTime),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionCard(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              children: [
                Text(
                  l10n.currentWeightLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF7B8DA8),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(text: _weight.toStringAsFixed(1)),
                      TextSpan(
                        text: ' ${l10n.kgUnit}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _WeightRuler(
                  value: _weight,
                  min: 2.0,
                  max: 15.0,
                  onChanged: (value) => setState(() => _weight = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_information_outlined, color: primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.checkInContextTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.checkInContextDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _weightContext,
                  decoration: InputDecoration(
                    labelText: l10n.weightContextLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'fasting',
                      child: Text(_weightContextLabel(l10n, 'fasting')),
                    ),
                    DropdownMenuItem(
                      value: 'after_meal',
                      child: Text(_weightContextLabel(l10n, 'after_meal')),
                    ),
                    DropdownMenuItem(
                      value: 'different_scale',
                      child: Text(_weightContextLabel(l10n, 'different_scale')),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Text(_weightContextLabel(l10n, 'other')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _weightContext = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _appetite,
                  decoration: InputDecoration(
                    labelText: l10n.appetiteLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'poor',
                      child: Text(_appetiteLabel(l10n, 'poor')),
                    ),
                    DropdownMenuItem(
                      value: 'reduced',
                      child: Text(_appetiteLabel(l10n, 'reduced')),
                    ),
                    DropdownMenuItem(
                      value: 'normal',
                      child: Text(_appetiteLabel(l10n, 'normal')),
                    ),
                    DropdownMenuItem(
                      value: 'high',
                      child: Text(_appetiteLabel(l10n, 'high')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _appetite = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _stool,
                  decoration: InputDecoration(
                    labelText: l10n.stoolLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'none',
                      child: Text(_stoolLabel(l10n, 'none')),
                    ),
                    DropdownMenuItem(
                      value: 'normal',
                      child: Text(_stoolLabel(l10n, 'normal')),
                    ),
                    DropdownMenuItem(
                      value: 'soft',
                      child: Text(_stoolLabel(l10n, 'soft')),
                    ),
                    DropdownMenuItem(
                      value: 'hard',
                      child: Text(_stoolLabel(l10n, 'hard')),
                    ),
                    DropdownMenuItem(
                      value: 'diarrhea',
                      child: Text(_stoolLabel(l10n, 'diarrhea')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _stool = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _vomit,
                  decoration: InputDecoration(
                    labelText: l10n.vomitLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'none',
                      child: Text(_vomitLabel(l10n, 'none')),
                    ),
                    DropdownMenuItem(
                      value: 'occasional',
                      child: Text(_vomitLabel(l10n, 'occasional')),
                    ),
                    DropdownMenuItem(
                      value: 'frequent',
                      child: Text(_vomitLabel(l10n, 'frequent')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _vomit = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _energy,
                  decoration: InputDecoration(
                    labelText: l10n.energyLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'low',
                      child: Text(_energyLabel(l10n, 'low')),
                    ),
                    DropdownMenuItem(
                      value: 'normal',
                      child: Text(_energyLabel(l10n, 'normal')),
                    ),
                    DropdownMenuItem(
                      value: 'high',
                      child: Text(_energyLabel(l10n, 'high')),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _energy = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit_note_rounded, color: primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      l10n.checkInNotesTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.checkInNotesDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.weightNotesHint,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _clinicalAssessmentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.clinicalAssessmentStructuredLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _clinicalPlanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.clinicalPlanFollowUpLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _noteSuggestions(l10n).map((suggestion) {
                    return FilledButton.tonal(
                      onPressed: () => _appendSuggestion(suggestion),
                      child: Text(
                        suggestion,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton.icon(
          onPressed: _isSaving ? null : _recordWeight,
          icon: _isSaving
              ? const SizedBox.shrink()
              : const Icon(Icons.monitor_weight_outlined),
          label: _isSaving
              ? AppLoadingState(compact: true, label: l10n.savingLabel)
              : Text(l10n.recordWeightAction),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(68),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: child,
    );
  }
}

class _WeightRuler extends StatelessWidget {
  const _WeightRuler({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary =
        Theme.of(
          context,
        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: primary.withValues(alpha: 0.55),
            inactiveTrackColor: primary.withValues(alpha: 0.12),
            thumbColor: primary,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
            overlayColor: primary.withValues(alpha: 0.16),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28),
            tickMarkShape: SliderTickMarkShape.noTickMark,
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: ((max - min) * 10).round(),
            onChanged: onChanged,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10,
          runSpacing: 6,
          children: [
            _ScaleLabel(
              label: '2.0 ${AppLocalizations.of(context).kgUnit}',
              color: secondary,
            ),
            _ScaleLabel(
              label: '5.0 ${AppLocalizations.of(context).kgUnit}',
              color: secondary,
            ),
            _ScaleLabel(
              label: '8.5 ${AppLocalizations.of(context).kgUnit}',
              color: secondary,
            ),
            _ScaleLabel(
              label: '12.0 ${AppLocalizations.of(context).kgUnit}',
              color: secondary,
            ),
            _ScaleLabel(
              label: '15.0 ${AppLocalizations.of(context).kgUnit}',
              color: secondary,
            ),
          ],
        ),
      ],
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  const _ScaleLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
