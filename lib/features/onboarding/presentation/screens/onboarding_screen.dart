import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/features/home/data/providers/month_summary_provider.dart';
import 'package:flow/shared/models/gender.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';
import 'package:flow/shared/widgets/app_banner.dart';
import 'package:flow/features/onboarding/presentation/widgets/birthdate_step.dart';
import 'package:flow/features/onboarding/presentation/widgets/gender_step.dart';
import 'package:flow/features/onboarding/presentation/widgets/name_step.dart';
import 'package:flow/features/onboarding/presentation/widgets/pioneer_start_date_step.dart';
import 'package:flow/features/onboarding/presentation/widgets/privilege_step.dart';

/// Onboarding screen with 4-step wizard for initial user setup
/// This screen is mandatory on first launch and blocks access until completed
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  // Form data
  String? _name;
  PublisherType? _publisherType;
  Gender? _gender;
  DateTime? _birthDate;
  DateTime? _pioneerStartDate;

  // Total steps depends on if user is pioneer
  int get _totalSteps {
    // Name, Privilege, Gender, BirthDate = 4 steps
    // + Pioneer start date (if regular/special pioneer) = 5 steps
    if (_publisherType == PublisherType.regularPioneer ||
        _publisherType == PublisherType.specialPioneer) {
      return 5;
    }
    return 4;
  }

  // Validation states
  bool get _isStep0Valid => _name != null && _name!.trim().isNotEmpty;
  bool get _isStep1Valid => _publisherType != null;
  bool get _isStep2Valid => _gender != null;
  bool get _isStep3Valid => _birthDate != null;
  bool get _isStep4Valid => _pioneerStartDate != null; // Only for pioneers

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _isStep0Valid;
      case 1:
        return _isStep1Valid;
      case 2:
        return _isStep2Valid;
      case 3:
        return _isStep3Valid;
      case 4:
        return _isStep4Valid;
      default:
        return false;
    }
  }

  bool get _isLastStep => _currentStep == _totalSteps - 1;

  void _onNext() {
    if (_isLastStep) {
      _finishOnboarding();
    } else {
      setState(() {
        // Skip pioneer start date step if publisher
        if (_currentStep == 3 && _publisherType == PublisherType.publisher) {
          // Already on last step for publisher
          _finishOnboarding();
        } else {
          _currentStep++;
        }
      });
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _finishOnboarding() async {
    final userProfile = UserProfileService.instance;

    try {
      // Save all data
      await userProfile.setUserName(_name!);
      await userProfile.setPublisherType(_publisherType!);
      await userProfile.setGender(_gender!);
      await userProfile.setBirthDate(_birthDate!);

      // Save pioneer start date if applicable
      if (_publisherType == PublisherType.regularPioneer &&
          _pioneerStartDate != null) {
        await userProfile.setRegularPioneerStartDate(_pioneerStartDate!);
      } else if (_publisherType == PublisherType.specialPioneer &&
          _pioneerStartDate != null) {
        await userProfile.setSpecialPioneerStartDate(_pioneerStartDate!);
      }

      // Invalidate providers to refresh the UI
      ref.invalidate(userProfileProvider);
      // Also invalidate month summary to update goal display
      ref.invalidate(monthSummaryProvider);

      if (!mounted) return;

      // Navigate to home
      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      AppBanner.showError(context, 'Error al guardar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Cannot go back
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            // Step indicator text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Paso ${_currentStep + 1} de $_totalSteps',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Step content
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  NameStep(
                    initialValue: _name,
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  PrivilegeStep(
                    selectedType: _publisherType,
                    onChanged: (value) {
                      setState(() {
                        _publisherType = value;
                      });
                    },
                  ),
                  GenderStep(
                    selectedGender: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  BirthdateStep(
                    selectedDate: _birthDate,
                    onChanged: (value) {
                      setState(() {
                        _birthDate = value;
                      });
                    },
                  ),
                  // Pioneer start date (only shown for regular/special pioneers)
                  if (_publisherType == PublisherType.regularPioneer ||
                      _publisherType == PublisherType.specialPioneer)
                    PioneerStartDateStep(
                      publisherType: _publisherType!,
                      selectedDate: _pioneerStartDate,
                      onChanged: (value) {
                        setState(() {
                          _pioneerStartDate = value;
                        });
                      },
                    ),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back button
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: _onBack,
                      child: const Text('Atrás'),
                    ),

                  const Spacer(),

                  // Next/Finish button
                  FilledButton(
                    onPressed: _canProceed ? _onNext : null,
                    child: Text(_isLastStep ? 'Finalizar' : 'Siguiente'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
