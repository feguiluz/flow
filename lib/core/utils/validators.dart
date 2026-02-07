import 'package:flow/shared/models/goal.dart';

import 'constants.dart';
import 'time_formatter.dart';

/// Utility class for input validation
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validate time in HH:MM format
  static String? validateTimeHHMM(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el tiempo';
    }

    final minutes = TimeFormatter.parseHHMMToMinutes(value);

    if (minutes == null) {
      return 'Formato inválido. Usa HH:MM (ej: 02:30)';
    }

    if (minutes == 0) {
      return 'El tiempo debe ser mayor a 0';
    }

    if (minutes > AppConstants.maxHoursPerDay * 60) {
      return 'El tiempo no puede exceder 24h';
    }

    return null;
  }

  /// Validate hours input (deprecated - use validateTimeHHMM)
  @Deprecated('Use validateTimeHHMM instead')
  static String? validateHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa las horas';
    }

    final hours = double.tryParse(value.replaceAll(',', '.'));

    if (hours == null) {
      return 'Ingresa un número válido';
    }

    if (hours <= 0) {
      return 'Las horas deben ser mayores a 0';
    }

    if (hours > AppConstants.maxHoursPerDay) {
      return 'Las horas no pueden exceder 24 por día';
    }

    return null;
  }

  /// Validate person name input
  static String? validatePersonName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un nombre';
    }

    if (value.trim().isEmpty) {
      return 'El nombre no puede estar vacío';
    }

    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    return null;
  }

  /// Validate note length
  static String? validateNote(String? value) {
    if (value != null && value.length > AppConstants.maxNoteLength) {
      return 'La nota es muy larga (máx ${AppConstants.maxNoteLength} caracteres)';
    }

    return null;
  }

  /// Check if a date is in the future
  static bool isDateInFuture(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    return dateOnly.isAfter(today);
  }

  /// Check if a user can register hours based on their current goal
  /// Returns true if they can register hours (has a pioneer goal)
  /// Returns false if they're a publisher without goal
  static bool canRegisterHours(GoalType? currentGoal) {
    // If no goal set, cannot register hours
    if (currentGoal == null) {
      return false;
    }

    // Publisher goal means no hour tracking
    if (currentGoal == GoalType.publisher) {
      return false;
    }

    // All pioneer types can register hours
    return true;
  }

  /// Validate email (optional field)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }

    return null;
  }

  /// Validate phone number (optional field)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }

    // Remove common separators
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleanPhone.length < 9) {
      return 'El teléfono debe tener al menos 9 dígitos';
    }

    if (!RegExp(r'^[0-9+]+$').hasMatch(cleanPhone)) {
      return 'El teléfono solo puede contener números y +';
    }

    return null;
  }
}
