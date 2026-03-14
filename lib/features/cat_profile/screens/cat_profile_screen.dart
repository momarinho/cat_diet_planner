import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import 'package:cat_diet_planner/core/widgets/app_loading_state.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/services/cat_photo_service.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
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

  bool _neutered = true;
  String _activityLevel = 'moderate';
  String _goal = 'maintenance';
  String? _photoPath;
  String? _photoBase64;
  bool _isSaving = false;

  bool get _isEditing => widget.initialCat != null;

  @override
  void initState() {
    super.initState();
    final cat = widget.initialCat;
    if (cat == null) {
      _weightController.text = '4.5';
      _ageController.text = '3';
      _photoPath = _presetPhotos.first;
      _photoBase64 = null;
      return;
    }

    _nameController.text = cat.name;
    _weightController.text = cat.weight.toStringAsFixed(1);
    _ageController.text = (cat.age / 12).round().toString();
    _neutered = cat.neutered;
    _activityLevel = cat.activityLevel;
    _goal = cat.goal;
    _photoBase64 = cat.photoBase64;
    _photoPath =
        cat.photoPath ?? (_photoBase64 == null ? _presetPhotos.first : null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final initial = widget.initialCat;
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
    );

    try {
      await ref.read(catProfilesProvider.notifier).saveProfile(profile);
    } on StateError catch (error) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
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
          title: const Text('Delete profile'),
          content: Text('Remove ${cat.name} from the app?'),
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
    } on ArgumentError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(title: const Text('Cat Profile'), centerTitle: true),
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
                    _isEditing ? 'Edit profile' : 'Create a new cat profile',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Upload Photo'),
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
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter the cat name';
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
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed <= 0) {
                              return 'Invalid weight';
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
                          decoration: const InputDecoration(
                            labelText: 'Age (years)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final parsed = int.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed <= 0) {
                              return 'Invalid age';
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
                    title: const Text('Neutered / Spayed'),
                    subtitle: const Text('Affects calorie requirements'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _activityLevel,
                    decoration: const InputDecoration(
                      labelText: 'Activity level',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'sedentary',
                        child: Text('Sedentary'),
                      ),
                      DropdownMenuItem(
                        value: 'moderate',
                        child: Text('Moderate'),
                      ),
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _activityLevel = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _goal,
                    decoration: const InputDecoration(
                      labelText: 'Goal',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'maintenance',
                        child: Text('Maintenance'),
                      ),
                      DropdownMenuItem(
                        value: 'loss',
                        child: Text('Weight loss'),
                      ),
                      DropdownMenuItem(
                        value: 'gain',
                        child: Text('Weight gain'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _goal = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Limit: ${AppLimits.maxCats} individual cats. Groups are created separately as lightweight operational units.',
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
                  ? const AppLoadingState(compact: true, label: 'Saving...')
                  : Text(_isEditing ? 'Save Changes' : 'Save Profile'),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _deleteProfile,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Profiles saved here will feed Home, Plans, Weight Check-in, and Dashboard.',
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: child,
    );
  }
}
