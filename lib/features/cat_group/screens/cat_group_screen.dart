import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_groups_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatGroupScreen extends ConsumerStatefulWidget {
  const CatGroupScreen({super.key, this.initialGroup});

  final CatGroup? initialGroup;

  @override
  ConsumerState<CatGroupScreen> createState() => _CatGroupScreenState();
}

class _CatGroupScreenState extends ConsumerState<CatGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _catCountController = TextEditingController();
  final _subgroupController = TextEditingController();
  final _categoryController = TextEditingController();
  final _enclosureController = TextEditingController();
  final _environmentController = TextEditingController();
  final _shiftMorningController = TextEditingController();
  final _shiftAfternoonController = TextEditingController();
  final _shiftNightController = TextEditingController();
  final _badgeEmojiController = TextEditingController();
  final Map<String, TextEditingController> _shareControllers =
      <String, TextEditingController>{};

  static const List<Color> _colors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFD166),
    Color(0xFFA78BFA),
    Color(0xFF95E1A3),
  ];
  static const List<IconData> _iconChoices = [
    Icons.groups_rounded,
    Icons.pets_rounded,
    Icons.home_work_outlined,
    Icons.grass_rounded,
    Icons.shield_moon_outlined,
  ];

  late Color _selectedColor;
  late Color _selectedSecondaryColor;
  late IconData _selectedIcon;
  final Set<String> _selectedCatIds = <String>{};

  bool get _isEditing => widget.initialGroup != null;

  @override
  void initState() {
    super.initState();
    final group = widget.initialGroup;
    _nameController.text = group?.name ?? '';
    _descriptionController.text = group?.description ?? '';
    _catCountController.text = group?.catCount.toString() ?? '2';
    _subgroupController.text = group?.subgroup ?? '';
    _categoryController.text = group?.category ?? '';
    _enclosureController.text = group?.enclosure ?? '';
    _environmentController.text = group?.environment ?? '';
    _shiftMorningController.text = group?.shiftMorningNotes ?? '';
    _shiftAfternoonController.text = group?.shiftAfternoonNotes ?? '';
    _shiftNightController.text = group?.shiftNightNotes ?? '';
    _badgeEmojiController.text = group?.badgeEmoji ?? '';
    _selectedColor = group == null ? _colors.first : Color(group.colorValue);
    _selectedSecondaryColor = group?.secondaryColorValue == null
        ? _colors[1]
        : Color(group!.secondaryColorValue!);
    _selectedIcon = _iconFromName(group?.iconName);
    _selectedCatIds.addAll(group?.catIds ?? const <String>[]);
    final initialShares = group?.feedingShareByCat ?? const <String, double>{};
    for (final entry in initialShares.entries) {
      _shareControllers[entry.key] = TextEditingController(
        text: entry.value.toStringAsFixed(2),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _catCountController.dispose();
    _subgroupController.dispose();
    _categoryController.dispose();
    _enclosureController.dispose();
    _environmentController.dispose();
    _shiftMorningController.dispose();
    _shiftAfternoonController.dispose();
    _shiftNightController.dispose();
    _badgeEmojiController.dispose();
    for (final controller in _shareControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _iconName(IconData icon) {
    if (icon == Icons.pets_rounded) return 'pets';
    if (icon == Icons.home_work_outlined) return 'home_work';
    if (icon == Icons.grass_rounded) return 'grass';
    if (icon == Icons.shield_moon_outlined) return 'shield_moon';
    return 'groups';
  }

  IconData _iconFromName(String? iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets_rounded;
      case 'home_work':
        return Icons.home_work_outlined;
      case 'grass':
        return Icons.grass_rounded;
      case 'shield_moon':
        return Icons.shield_moon_outlined;
      case 'groups':
      default:
        return Icons.groups_rounded;
    }
  }

  Map<String, double> _feedingSharesForSelectedCats() {
    final shares = <String, double>{};
    for (final catId in _selectedCatIds) {
      final controller = _shareControllers[catId] ??= TextEditingController(
        text: '1.0',
      );
      final value = double.tryParse(
        controller.text.trim().replaceAll(',', '.'),
      );
      shares[catId] = value != null && value > 0 ? value : 1.0;
    }
    return shares;
  }

  Future<void> _saveGroup() async {
    if (!_formKey.currentState!.validate()) return;

    final initial = widget.initialGroup;
    final linkedCount = _selectedCatIds.length;
    final effectiveCatCount = linkedCount > 0
        ? linkedCount
        : int.parse(_catCountController.text.trim());
    final group = CatGroup(
      id: initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      catCount: effectiveCatCount,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      colorValue: _selectedColor.toARGB32(),
      createdAt: initial?.createdAt ?? DateTime.now(),
      catIds: _selectedCatIds.toList(growable: false),
      subgroup: _subgroupController.text.trim().isEmpty
          ? null
          : _subgroupController.text.trim(),
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      feedingShareByCat: _feedingSharesForSelectedCats(),
      enclosure: _enclosureController.text.trim().isEmpty
          ? null
          : _enclosureController.text.trim(),
      environment: _environmentController.text.trim().isEmpty
          ? null
          : _environmentController.text.trim(),
      shiftMorningNotes: _shiftMorningController.text.trim().isEmpty
          ? null
          : _shiftMorningController.text.trim(),
      shiftAfternoonNotes: _shiftAfternoonController.text.trim().isEmpty
          ? null
          : _shiftAfternoonController.text.trim(),
      shiftNightNotes: _shiftNightController.text.trim().isEmpty
          ? null
          : _shiftNightController.text.trim(),
      secondaryColorValue: _selectedSecondaryColor.toARGB32(),
      iconName: _iconName(_selectedIcon),
      badgeEmoji: _badgeEmojiController.text.trim().isEmpty
          ? null
          : _badgeEmojiController.text.trim(),
    );

    try {
      await ref.read(catGroupsProvider.notifier).saveGroup(group);
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _deleteGroup() async {
    final group = widget.initialGroup;
    if (group == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete group'),
          content: Text('Remove ${group.name} from the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await ref.read(catGroupsProvider.notifier).deleteGroup(group);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(catProfilesProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(title: const Text('Cat Group'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _GroupCard(
              primary: primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing ? 'Edit group' : 'Create a new group',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Groups are lightweight operational units for shared feeding plans. Weight history stays in individual cat profiles.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Group name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter the group name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _catCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'How many cats are in this group?',
                      border: OutlineInputBorder(),
                    ),
                    enabled: _selectedCatIds.isEmpty,
                    validator: (value) {
                      if (_selectedCatIds.isNotEmpty) return null;
                      final parsed = int.tryParse(value?.trim() ?? '');
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid cat count';
                      }
                      if (parsed > AppLimits.maxCats) {
                        return 'A group can have up to ${AppLimits.maxCats} cats';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Linked Cats',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (cats.isEmpty)
                    Text(
                      'No cat profiles available. You can still use manual cat count.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondary,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cats.map((cat) {
                        final selected = _selectedCatIds.contains(cat.id);
                        return FilterChip(
                          label: Text(cat.name),
                          selected: selected,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                _selectedCatIds.add(cat.id);
                                _shareControllers[cat.id] ??=
                                    TextEditingController(text: '1.0');
                              } else {
                                _selectedCatIds.remove(cat.id);
                              }
                              if (_selectedCatIds.isNotEmpty) {
                                _catCountController.text = _selectedCatIds
                                    .length
                                    .toString();
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  if (_selectedCatIds.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Unequal distribution per cat (weight)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...cats
                        .where((cat) => _selectedCatIds.contains(cat.id))
                        .map((cat) {
                          final controller = _shareControllers[cat.id] ??=
                              TextEditingController(text: '1.0');
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              controller: controller,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: '${cat.name} share weight',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          );
                        }),
                  ],
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _subgroupController,
                    decoration: const InputDecoration(
                      labelText: 'Subgroup (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Operational category (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _enclosureController,
                    decoration: const InputDecoration(
                      labelText: 'Enclosure / room (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _environmentController,
                    decoration: const InputDecoration(
                      labelText: 'Environment (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Operational notes by shift',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _shiftMorningController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Morning shift',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _shiftAfternoonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Afternoon shift',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _shiftNightController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Night shift',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Visual identification',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _colors.map((color) {
                      final selected =
                          _selectedColor.toARGB32() == color.toARGB32();
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? Colors.black : Colors.white,
                              width: selected ? 2 : 1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _colors.map((color) {
                      final selected =
                          _selectedSecondaryColor.toARGB32() ==
                          color.toARGB32();
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedSecondaryColor = color),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected ? Colors.black : Colors.white,
                              width: selected ? 2 : 1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _iconChoices.map((icon) {
                      final selected = _selectedIcon == icon;
                      return ChoiceChip(
                        label: Icon(icon, size: 18),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedIcon = icon),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _badgeEmojiController,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Badge/emoji (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Limit: up to ${AppLimits.maxGroups} groups in the app.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saveGroup,
              icon: const Icon(Icons.save_outlined),
              label: Text(_isEditing ? 'Save Changes' : 'Save Group'),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _deleteGroup,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Group'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.child, required this.primary});

  final Widget child;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}
