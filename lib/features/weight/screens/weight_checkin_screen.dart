import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/widgets/app_loading_state.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightCheckInScreen extends ConsumerStatefulWidget {
  const WeightCheckInScreen({super.key});

  @override
  ConsumerState<WeightCheckInScreen> createState() =>
      _WeightCheckInScreenState();
}

class _WeightCheckInScreenState extends ConsumerState<WeightCheckInScreen> {
  static const List<String> _noteSuggestions = [
    'High Appetite',
    'Energetic',
    'Lazy Day',
  ];

  double _weight = 5.0;
  WeightRecord? _latestRecord;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadLatestWeight();
  }

  void _loadLatestWeight() {
    final records = HiveService.weightsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (records.isEmpty) return;

    final latest = records.first;

    setState(() {
      _latestRecord = latest;
      _weight = latest.weight;
    });
  }

  String _formatDate(DateTime date) {
    final months = [
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _appendSuggestion(String suggestion) {
    final current = _notesController.text.trim();
    final next = current.isEmpty ? suggestion : '$current, $suggestion';
    setState(() => _notesController.text = next);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _recordWeight() async {
    setState(() => _isSaving = true);
    try {
      final notes = _notesController.text.trim();

      final record = WeightRecord(
        date: DateTime.now(),
        weight: _weight,
        notes: notes.isEmpty ? null : notes,
      );

      await HiveService.weightsBox.add(record);
      final selectedCat = ref.read(selectedCatProvider);
      if (selectedCat != null) {
        selectedCat.weight = _weight;
        selectedCat.weightHistory = [...selectedCat.weightHistory, record]
          ..sort((a, b) => a.date.compareTo(b.date));
        await selectedCat.save();
        ref.read(selectedCatProvider.notifier).state = selectedCat;
      }

      if (!mounted) return;

      setState(() {
        _latestRecord = record;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Weight recorded')));
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCat = ref.watch(selectedCatProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    if (selectedCat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weight Check-in')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: const AppEmptyState(
              icon: Icons.monitor_weight_outlined,
              title: 'No active cat',
              description: 'Select a cat from Home before recording weight.',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Check-in'),
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
                          Icons.photo_camera_outlined,
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
                          ? 'No previous check-in'
                          : 'Last check-in: ${_formatDate(_latestRecord!.date)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF7B8DA8),
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
                      'LAST\nWEIGHT',
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
                            text: ' kg',
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
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              children: [
                Text(
                  'CURRENT WEIGHT',
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
                        text: ' kg',
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
                    Icon(Icons.edit_note_rounded, color: primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Check-in Notes',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'How is your cat\'s appetite today? Any changes in mood or energy levels?',
                    hintStyle: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF9AA8BE),
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: theme.brightness == Brightness.dark
                        ? const Color(0xFF2B2426)
                        : const Color(0xFFFFF0F4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _noteSuggestions.map((suggestion) {
                    return OutlinedButton(
                      onPressed: () => _appendSuggestion(suggestion),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(
                          color: primary.withValues(alpha: 0.28),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
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
              ? const AppLoadingState(compact: true, label: 'Saving...')
              : const Text('Record Weight'),
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
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
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
            _ScaleLabel(label: '2.0 kg', color: secondary),
            _ScaleLabel(label: '5.0 kg', color: secondary),
            _ScaleLabel(label: '8.5 kg', color: secondary),
            _ScaleLabel(label: '12.0 kg', color: secondary),
            _ScaleLabel(label: '15.0 kg', color: secondary),
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
