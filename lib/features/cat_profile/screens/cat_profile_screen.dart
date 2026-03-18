import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/core/localization/app_feedback_localizer.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import 'package:cat_diet_planner/core/widgets/app_loading_state.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/services/cat_photo_service.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/widgets/guided_bcs_assistant_sheet.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatProfileScreen extends ConsumerStatefulWidget {
  const CatProfileScreen({super.key, this.initialCat});

  final CatProfile? initialCat;

  @override
  ConsumerState<CatProfileScreen> createState() => _CatProfileScreenState();
}

class _CatProfileScreenState extends ConsumerState<CatProfileScreen> {
  static const List<String> _presetPhotos = [
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=200&q=80',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _manualTargetKcalController = TextEditingController();
  final _notesController = TextEditingController();

  // New controllers / fields for clinical & routine data
  final _idealWeightController = TextEditingController();
  final _breedController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _customActivityController = TextEditingController();
  final _clinicalConditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _dietaryPreferencesController = TextEditingController();
  final _vetNotesController = TextEditingController();
  final _weightGoalMinController = TextEditingController();
  final _weightGoalMaxController = TextEditingController();
  final _weightAlertDeltaKgController = TextEditingController();
  final _weightAlertDeltaPercentController = TextEditingController();

  bool _neutered = true;
  String _activityLevel = 'moderate';
  String _goal = 'maintenance';
  int _preferredMealsPerDay = 4;
  String? _photoPath;
  String? _photoBase64;
  bool _isSaving = false;

  // clinical/routine state
  int? _bcs;
  String _sex = 'unknown';
  DateTime? _birthDate;

  bool get _isEditing => widget.initialCat != null;

  String _activityLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'sedentary':
        return l10n.sedentaryOption;
      case 'active':
        return l10n.activeOption;
      default:
        return l10n.moderateOption;
    }
  }

  String _goalLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'loss':
        return l10n.weightLossGoalOption;
      case 'gain':
        return l10n.weightGainGoalOption;
      case 'kitten_growth':
        return l10n.kittenGrowthGoalOption;
      case 'senior_support':
        return l10n.seniorSupportGoalOption;
      case 'recovery':
        return l10n.recoveryGoalOption;
      case 'post_surgery':
        return l10n.postSurgeryGoalOption;
      default:
        return l10n.maintenanceGoalOption;
    }
  }

  String _sexLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'male':
        return l10n.maleOption;
      case 'female':
        return l10n.femaleOption;
      default:
        return l10n.unknownOption;
    }
  }

  @override
  void initState() {
    super.initState();
    final cat = widget.initialCat;
    if (cat == null) {
      _weightController.text = '4.5';
      _ageController.text = '3';
      _manualTargetKcalController.text = '';
      _notesController.text = '';
      _idealWeightController.text = '';
      _breedController.text = '';
      _birthDateController.text = '';
      _customActivityController.text = '';
      _clinicalConditionsController.text = '';
      _allergiesController.text = '';
      _dietaryPreferencesController.text = '';
      _vetNotesController.text = '';
      _weightGoalMinController.text = '';
      _weightGoalMaxController.text = '';
      _weightAlertDeltaKgController.text = '';
      _weightAlertDeltaPercentController.text = '';
      _photoPath = _presetPhotos.first;
      _photoBase64 = null;
      _bcs = null;
      _sex = 'unknown';
      _birthDate = null;
      return;
    }

    _nameController.text = cat.name;
    _weightController.text = cat.weight.toStringAsFixed(1);
    _ageController.text = (cat.age / 12).round().toString();
    _neutered = cat.neutered;
    _activityLevel = cat.activityLevel;
    _goal = cat.goal;
    _preferredMealsPerDay = cat.preferredMealsPerDay;
    _manualTargetKcalController.text = cat.manualTargetKcal == null
        ? ''
        : cat.manualTargetKcal!.toStringAsFixed(0);
    _notesController.text = cat.notes ?? '';
    _photoBase64 = cat.photoBase64;
    _photoPath =
        cat.photoPath ?? (_photoBase64 == null ? _presetPhotos.first : null);

    // clinical / routine
    _idealWeightController.text = cat.idealWeight != null
        ? cat.idealWeight!.toStringAsFixed(1)
        : '';
    _bcs = cat.bcs;
    _sex = cat.sex;
    _breedController.text = cat.breed ?? '';
    _birthDate = cat.birthDate;
    _birthDateController.text = cat.birthDate != null
        ? cat.birthDate!.toIso8601String().split('T').first
        : '';
    _customActivityController.text = cat.customActivityLevel ?? '';
    _clinicalConditionsController.text = (cat.clinicalConditions).join(', ');
    _allergiesController.text = (cat.allergies).join(', ');
    _dietaryPreferencesController.text = (cat.dietaryPreferences).join(', ');
    _vetNotesController.text = cat.vetNotes ?? '';
    _weightGoalMinController.text =
        cat.weightGoalMinKg?.toStringAsFixed(1) ?? '';
    _weightGoalMaxController.text =
        cat.weightGoalMaxKg?.toStringAsFixed(1) ?? '';
    _weightAlertDeltaKgController.text =
        cat.weightAlertDeltaKg?.toStringAsFixed(1) ?? '';
    _weightAlertDeltaPercentController.text =
        cat.weightAlertDeltaPercent?.toStringAsFixed(1) ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_birthDate != null) {
      final localizedDate = AppFormatters.formatDate(context, _birthDate!);
      if (_birthDateController.text != localizedDate) {
        _birthDateController.text = localizedDate;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _manualTargetKcalController.dispose();
    _notesController.dispose();

    // dispose new controllers
    _idealWeightController.dispose();
    _breedController.dispose();
    _birthDateController.dispose();
    _customActivityController.dispose();
    _clinicalConditionsController.dispose();
    _allergiesController.dispose();
    _dietaryPreferencesController.dispose();
    _vetNotesController.dispose();
    _weightGoalMinController.dispose();
    _weightGoalMaxController.dispose();
    _weightAlertDeltaKgController.dispose();
    _weightAlertDeltaPercentController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final initial = widget.initialCat;
    final manualTarget = double.tryParse(
      _manualTargetKcalController.text.trim(),
    );

    // parse comma-separated lists for structured fields
    List<String> parseTags(String text) {
      return text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    final idealWeightParsed = double.tryParse(
      _idealWeightController.text.trim(),
    );
    final goalMin = double.tryParse(_weightGoalMinController.text.trim());
    final goalMax = double.tryParse(_weightGoalMaxController.text.trim());
    final alertDeltaKg = double.tryParse(
      _weightAlertDeltaKgController.text.trim(),
    );
    final alertDeltaPercent = double.tryParse(
      _weightAlertDeltaPercentController.text.trim(),
    );
    final profile = CatProfile(
      id: initial?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      weight: double.parse(_weightController.text.trim()),
      age: int.parse(_ageController.text.trim()) * 12,
      neutered: _neutered,
      activityLevel: _activityLevel,
      goal: _goal,
      createdAt: initial?.createdAt ?? DateTime.now(),
      weightHistory: initial?.weightHistory ?? const [],
      photoPath: _photoPath,
      photoBase64: _photoBase64,
      preferredMealsPerDay: _preferredMealsPerDay,
      manualTargetKcal: manualTarget == null || manualTarget <= 0
          ? null
          : manualTarget,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      // new clinical & routine fields
      idealWeight: idealWeightParsed == null || idealWeightParsed <= 0
          ? null
          : idealWeightParsed,
      bcs: _bcs,
      sex: _sex,
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      birthDate: _birthDate,
      customActivityLevel: _customActivityController.text.trim().isEmpty
          ? null
          : _customActivityController.text.trim(),
      clinicalConditions: parseTags(_clinicalConditionsController.text),
      allergies: parseTags(_allergiesController.text),
      dietaryPreferences: parseTags(_dietaryPreferencesController.text),
      vetNotes: _vetNotesController.text.trim().isEmpty
          ? null
          : _vetNotesController.text.trim(),
      weightGoalMinKg: goalMin == null || goalMin <= 0 ? null : goalMin,
      weightGoalMaxKg: goalMax == null || goalMax <= 0 ? null : goalMax,
      weightAlertDeltaKg: alertDeltaKg == null || alertDeltaKg <= 0
          ? null
          : alertDeltaKg,
      weightAlertDeltaPercent:
          alertDeltaPercent == null || alertDeltaPercent <= 0
          ? null
          : alertDeltaPercent,
    );

    try {
      await ref.read(catProfilesProvider.notifier).saveProfile(profile);
    } catch (error) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizeErrorMessage(AppLocalizations.of(context), error),
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _deleteProfile() async {
    final cat = widget.initialCat;
    if (cat == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).deleteProfileTitle),
          content: Text(
            AppLocalizations.of(context).removeProfileMessage(cat.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context).cancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context).deleteAction),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await ref.read(catProfilesProvider.notifier).deleteProfile(cat);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes == null) return;

    try {
      final encoded = CatPhotoService.compressAndEncode(bytes);
      setState(() {
        _photoBase64 = encoded;
        _photoPath = null;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizeErrorMessage(AppLocalizations.of(context), error),
          ),
        ),
      );
    }
  }

  Future<void> _openGuidedBcsAssistant() async {
    final selectedBcs = await showGuidedBcsAssistantSheet(
      context,
      initialBcs: _bcs,
    );
    if (!mounted || selectedBcs == null) return;
    setState(() => _bcs = selectedBcs);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.catProfileTitle), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _ProfileCard(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary.withValues(alpha: 0.35),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: catPhotoProvider(
                            photoPath: _photoPath,
                            photoBase64: _photoBase64,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 26,
                          height: 26,
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
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isEditing
                        ? l10n.editProfileTitle
                        : l10n.createNewCatProfileTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.catProfileIntroDescription,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.upload_rounded),
                    label: Text(l10n.uploadPhotoAction),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _presetPhotos.map((photo) {
                      final selected = _photoPath == photo;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _photoPath = photo;
                          _photoBase64 = null;
                        }),
                        child: Container(
                          width: 56,
                          height: 56,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? primary
                                  : primary.withValues(alpha: 0.15),
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(photo),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ProfileCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileSectionHeader(
                    icon: Icons.badge_outlined,
                    title: l10n.coreProfileSectionTitle,
                    subtitle: l10n.coreProfileSectionDescription,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.nameLabel,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.enterCatNameError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.weightKgLabel,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed <= 0) {
                              return l10n.invalidWeightError;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.ageYearsLabel,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final parsed = int.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed <= 0) {
                              return l10n.invalidAgeError;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    value: _neutered,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) => setState(() => _neutered = value),
                    title: Text(l10n.neuteredSpayedTitle),
                    subtitle: Text(l10n.neuteredSpayedDescription),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _activityLevel,
                    decoration: InputDecoration(
                      labelText: l10n.activityLevelLabel,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'sedentary',
                        child: Text(_activityLabel(l10n, 'sedentary')),
                      ),
                      DropdownMenuItem(
                        value: 'moderate',
                        child: Text(_activityLabel(l10n, 'moderate')),
                      ),
                      DropdownMenuItem(
                        value: 'active',
                        child: Text(_activityLabel(l10n, 'active')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _activityLevel = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _goal,
                    decoration: InputDecoration(
                      labelText: l10n.goalLabel,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'maintenance',
                        child: Text(_goalLabel(l10n, 'maintenance')),
                      ),
                      DropdownMenuItem(
                        value: 'loss',
                        child: Text(_goalLabel(l10n, 'loss')),
                      ),
                      DropdownMenuItem(
                        value: 'gain',
                        child: Text(_goalLabel(l10n, 'gain')),
                      ),
                      DropdownMenuItem(
                        value: 'kitten_growth',
                        child: Text(_goalLabel(l10n, 'kitten_growth')),
                      ),
                      DropdownMenuItem(
                        value: 'senior_support',
                        child: Text(_goalLabel(l10n, 'senior_support')),
                      ),
                      DropdownMenuItem(
                        value: 'recovery',
                        child: Text(_goalLabel(l10n, 'recovery')),
                      ),
                      DropdownMenuItem(
                        value: 'post_surgery',
                        child: Text(_goalLabel(l10n, 'post_surgery')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _goal = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    initialValue: _preferredMealsPerDay,
                    decoration: InputDecoration(
                      labelText: l10n.preferredMealsPerDayLabel,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 3,
                        child: Text(l10n.mealsPerDayChip(3)),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Text(l10n.mealsPerDayChip(4)),
                      ),
                      DropdownMenuItem(
                        value: 5,
                        child: Text(l10n.mealsPerDayChip(5)),
                      ),
                      DropdownMenuItem(
                        value: 6,
                        child: Text(l10n.mealsPerDayChip(6)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _preferredMealsPerDay = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _manualTargetKcalController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.manualTargetKcalPerDayOptionalLabel,
                      helperText: l10n.manualTargetKcalHelperText,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return l10n.invalidKcalTargetError;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ProfileCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileSectionHeader(
                    icon: Icons.health_and_safety_outlined,
                    title: l10n.clinicalContextSectionTitle,
                    subtitle: l10n.clinicalContextSectionDescription,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _idealWeightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.idealWeightOptionalLabel,
                      helperText: l10n.idealWeightHelperText,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return l10n.invalidIdealWeightError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.bodyConditionScoreLabel,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _openGuidedBcsAssistant,
                            icon: const Icon(Icons.assistant_outlined),
                            label: const Text('Guided assistant'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.40),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bcs == null
                                  ? 'No BCS selected yet'
                                  : 'Current BCS: $_bcs/9',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'The guided assistant compares ribs, waist, belly line, and lower-back fat cover before you save a final score.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: (_bcs ?? 5).toDouble(),
                        min: 1,
                        max: 9,
                        divisions: 8,
                        label: '${_bcs ?? 5}',
                        onChanged: (v) => setState(() => _bcs = v.round()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _sex,
                    decoration: InputDecoration(
                      labelText: l10n.sexLabel,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'unknown',
                        child: Text(_sexLabel(l10n, 'unknown')),
                      ),
                      DropdownMenuItem(
                        value: 'male',
                        child: Text(_sexLabel(l10n, 'male')),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text(_sexLabel(l10n, 'female')),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _sex = v);
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _breedController,
                    decoration: InputDecoration(
                      labelText: l10n.breedOptionalLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.dateOfBirthOptionalLabel,
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _birthDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _birthDate = picked;
                          _birthDateController.text = AppFormatters.formatDate(
                            context,
                            picked,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _customActivityController,
                    decoration: InputDecoration(
                      labelText: l10n.customActivityLevelOptionalLabel,
                      helperText: l10n.customActivityLevelHelperText,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _clinicalConditionsController,
                    decoration: InputDecoration(
                      labelText: l10n.clinicalConditionsLabel,
                      helperText: l10n.clinicalConditionsHelperText,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _allergiesController,
                    decoration: InputDecoration(
                      labelText: l10n.allergiesRestrictionsLabel,
                      helperText: l10n.allergiesRestrictionsHelperText,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _dietaryPreferencesController,
                    decoration: InputDecoration(
                      labelText: l10n.dietaryPreferencesLabel,
                      helperText: l10n.dietaryPreferencesHelperText,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _vetNotesController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: l10n.veterinaryNotesOptionalLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ProfileCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileSectionHeader(
                    icon: Icons.track_changes_outlined,
                    title: l10n.targetsAlertsSectionTitle,
                    subtitle: l10n.targetsAlertsSectionDescription,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.weightGoalsAlertsTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightGoalMinController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.goalMinWeightKgLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightGoalMaxController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.goalMaxWeightKgLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightAlertDeltaKgController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.alertDeltaKgPerCheckInLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightAlertDeltaPercentController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.alertDeltaPercentPerCheckInLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _notesController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: l10n.clinicalNotesPreferencesLabel,
                      helperText: l10n.clinicalNotesPreferencesHelperText,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.catLimitHint(AppLimits.maxCats),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox.shrink()
                  : const Icon(Icons.save_outlined),
              label: _isSaving
                  ? AppLoadingState(compact: true, label: l10n.savingLabel)
                  : Text(
                      _isEditing
                          ? l10n.saveChangesAction
                          : l10n.saveProfileAction,
                    ),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _deleteProfile,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.deleteProfileAction),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.profileFeedsAppDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
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

class _ProfileSectionHeader extends StatelessWidget {
  const _ProfileSectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
