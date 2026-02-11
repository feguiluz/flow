import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/core/utils/date_formatter.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';
import 'package:flow/shared/models/gender.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';
import 'package:flow/shared/widgets/app_banner.dart';
import 'package:flow/shared/widgets/month_year_picker.dart';

/// Screen for editing user profile information
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  PublisherType? _publisherType;
  PublisherType? _originalPublisherType; // To detect changes
  Gender? _gender;
  DateTime? _birthDate;
  DateTime? _pioneerStartDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProfile = UserProfileService.instance;

    _nameController = TextEditingController(text: userProfile.getUserName());
    _publisherType = userProfile.getPublisherType();
    _originalPublisherType = _publisherType;
    _gender = userProfile.getGender();
    _birthDate = userProfile.getBirthDate();

    // Load pioneer start date based on current type
    if (_publisherType == PublisherType.regularPioneer) {
      _pioneerStartDate = userProfile.getRegularPioneerStartDate();
    } else if (_publisherType == PublisherType.specialPioneer) {
      _pioneerStartDate = userProfile.getSpecialPioneerStartDate();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate =
        _birthDate ?? DateTime(now.year - 30, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (pickedDate != null) {
      setState(() {
        _birthDate = pickedDate;
      });
    }
  }

  Future<void> _selectPioneerStartDate(BuildContext context) async {
    final now = DateTime.now();
    // Service year starts in September
    final minDate = now.month >= 9
        ? DateTime(now.year, 9, 1)
        : DateTime(now.year - 1, 9, 1);

    final initialDate = _pioneerStartDate ?? DateTime(now.year, now.month, 1);

    final pickedDate = await showMonthYearPicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: now,
      helpText: 'Selecciona mes de inicio del precursorado',
    );

    if (pickedDate != null) {
      setState(() {
        _pioneerStartDate = pickedDate;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_publisherType == null) {
      AppBanner.showError(context, 'Selecciona un privilegio');
      return;
    }

    if (_gender == null) {
      AppBanner.showError(context, 'Selecciona un género');
      return;
    }

    if (_birthDate == null) {
      AppBanner.showError(context, 'Selecciona tu fecha de nacimiento');
      return;
    }

    // Validate pioneer start date
    if (_publisherType == PublisherType.regularPioneer ||
        _publisherType == PublisherType.specialPioneer) {
      if (_pioneerStartDate == null) {
        AppBanner.showError(
          context,
          'Selecciona la fecha de inicio como precursor',
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProfile = UserProfileService.instance;
      await userProfile.setUserName(_nameController.text);
      await userProfile.setPublisherType(_publisherType!);
      await userProfile.setGender(_gender!);
      await userProfile.setBirthDate(_birthDate!);

      // Handle pioneer start date
      if (_publisherType == PublisherType.regularPioneer) {
        if (_pioneerStartDate != null) {
          await userProfile.setRegularPioneerStartDate(_pioneerStartDate!);
        }
      } else if (_publisherType == PublisherType.specialPioneer) {
        if (_pioneerStartDate != null) {
          await userProfile.setSpecialPioneerStartDate(_pioneerStartDate!);
        }
      } else if (_publisherType == PublisherType.publisher) {
        // Changed to publisher: clear pioneer dates
        await userProfile.clearAll();
        // Re-save as publisher
        await userProfile.setUserName(_nameController.text);
        await userProfile.setPublisherType(_publisherType!);
        await userProfile.setGender(_gender!);
        await userProfile.setBirthDate(_birthDate!);
      }

      // Invalidate providers to refresh the UI
      ref.invalidate(userProfileProvider);
      // Also invalidate month summary to update goal display
      ref.invalidate(monthSummaryProvider);

      if (!mounted) return;

      AppBanner.showSuccess(context, 'Perfil actualizado correctamente');

      context.pop();
    } catch (e) {
      if (!mounted) return;

      AppBanner.showError(context, 'Error al guardar: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Guardar'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Publisher Type
            Text(
              'Privilegio',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...PublisherType.values.map((type) {
              return RadioListTile<PublisherType>(
                title: Text(type.displayName),
                subtitle: Text(type.description),
                value: type,
                groupValue: _publisherType,
                onChanged: (value) {
                  setState(() {
                    _publisherType = value;
                  });
                },
              );
            }),
            const SizedBox(height: 24),

            // Pioneer start date (only for regular/special pioneers)
            if (_publisherType == PublisherType.regularPioneer ||
                _publisherType == PublisherType.specialPioneer) ...[
              Text(
                'Fecha de inicio del precursorado',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: InkWell(
                  onTap: () => _selectPioneerStartDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mes de inicio',
                                style: theme.textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _pioneerStartDate != null
                                    ? DateFormatter.getMonthYear(
                                        _pioneerStartDate!.year,
                                        _pioneerStartDate!.month,
                                      )
                                    : 'Selecciona una fecha',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Desde el 1 de septiembre del año de servicio actual',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Gender
            Text(
              'Género',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...Gender.values.map((gender) {
              return RadioListTile<Gender>(
                title: Text(gender.displayName),
                value: gender,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              );
            }),
            const SizedBox(height: 24),

            // Birth Date
            Text(
              'Fecha de nacimiento',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _birthDate != null
                              ? DateFormatter.formatForDisplay(_birthDate!)
                              : 'Selecciona una fecha',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
