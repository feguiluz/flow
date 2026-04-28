import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../shared/models/person.dart';
import '../../../../shared/widgets/app_banner.dart';
import '../../data/providers/person_notifier.dart';

/// Bottom sheet for adding or editing a person
class AddPersonSheet extends ConsumerStatefulWidget {
  const AddPersonSheet({
    super.key,
    this.person,
  });

  /// If provided, the sheet will be in edit mode
  final Person? person;

  @override
  ConsumerState<AddPersonSheet> createState() => _AddPersonSheetState();
}

class _AddPersonSheetState extends ConsumerState<AddPersonSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;
  late bool _isBibleStudy;
  bool _isLoading = false;
  bool _isLoadingLocation = false;
  double? _latitude;
  double? _longitude;
  // True only while `_useCurrentLocation` writes the address text. Lets the
  // address listener tell apart programmatic updates (auto-fill) from user
  // typing — in the latter case we drop the saved coords because they no
  // longer match the text the user is settling on.
  bool _settingAddressProgrammatically = false;
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers from existing person or empty
    _nameController = TextEditingController(text: widget.person?.name ?? '');
    _phoneController = TextEditingController(text: widget.person?.phone ?? '');
    _addressController =
        TextEditingController(text: widget.person?.address ?? '');
    _notesController = TextEditingController(text: widget.person?.notes ?? '');
    _isBibleStudy = widget.person?.isBibleStudy ?? false;
    // Carry over coords from the edited person so the listener below can
    // observe them and the save path persists them unchanged when the user
    // leaves the address alone.
    _latitude = widget.person?.latitude;
    _longitude = widget.person?.longitude;
    _addressController.addListener(_onAddressTextChanged);
  }

  @override
  void dispose() {
    _addressController.removeListener(_onAddressTextChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Clears stored coordinates when the user manually edits the address
  /// text. Keeps lat/lng in sync with the address shown in the field, which
  /// is the value navigation will use.
  void _onAddressTextChanged() {
    if (_settingAddressProgrammatically) return;
    if (_latitude == null && _longitude == null) return;
    setState(() {
      _latitude = null;
      _longitude = null;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Primero intentar obtener la posición
      final position = await _locationService.getCurrentPosition();

      if (position == null) {
        if (mounted) {
          AppBanner.showError(
            context,
            'No se pudo obtener la ubicación. Verifica los permisos en tu navegador.',
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Si tenemos posición, intentar obtener dirección
      final address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        // Si no pudimos obtener dirección, usar coordenadas
        final finalAddress = address ??
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';

        // Suppress the address listener while we sync text + coords from
        // the geolocator; otherwise it would immediately wipe the coords
        // we just set.
        _settingAddressProgrammatically = true;
        _addressController.text = finalAddress;
        _settingAddressProgrammatically = false;
        _latitude = position.latitude;
        _longitude = position.longitude;

        // Move cursor to end so user can easily add house number
        _addressController.selection = TextSelection.fromPosition(
          TextPosition(offset: _addressController.text.length),
        );
      });

      if (mounted) {
        // Check if address contains house number
        final hasNumber = address?.contains(RegExp(r',\s*\d+')) ?? false;

        if (hasNumber) {
          AppBanner.showSuccess(context, 'Ubicación obtenida');
        } else {
          // Warn that editing the address resets the captured coordinates.
          AppBanner.showSuccess(
            context,
            'Ubicación obtenida. Si editas la dirección, '
                'la ubicación exacta se descarta.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppBanner.showError(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _savePerson() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final person = Person(
        id: widget.person?.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isBibleStudy: _isBibleStudy,
        // Use the in-form coords directly. They mirror the user's intent:
        // preserved when the address text is untouched, cleared when it
        // was edited, refreshed when "Usar mi ubicación" was tapped again.
        latitude: _latitude,
        longitude: _longitude,
        createdAt: widget.person?.createdAt ?? DateTime.now(),
      );

      if (widget.person == null) {
        // Add new person
        await ref.read(personNotifierProvider.notifier).addPerson(person);
        if (mounted) {
          AppBanner.showSuccess(context, 'Persona agregada');
          Navigator.of(context).pop();
        }
      } else {
        // Update existing person
        await ref.read(personNotifierProvider.notifier).updatePerson(person);
        if (mounted) {
          AppBanner.showSuccess(context, 'Persona actualizada');
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        AppBanner.showError(context, 'Error: ${e.toString()}');
      }
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
    final isEditing = widget.person != null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Editar persona' : 'Agregar persona',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Name field (required)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Ej: Juan Pérez',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Phone field (optional)
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ej: (812) 345-6789',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'Formato: (XXX) XXX-XXXX',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MexicanPhoneFormatter(),
                ],
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Address field (optional) with location button
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ej: Calle Principal 123',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: const OutlineInputBorder(),
                  suffixIcon: _isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.my_location),
                          tooltip: 'Usar mi ubicación',
                          onPressed: _isLoading ? null : _useCurrentLocation,
                        ),
                ),
                textCapitalization: TextCapitalization.words,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Notes field (optional)
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  hintText: 'Información adicional...',
                  prefixIcon: Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

              // Bible study toggle
              Card(
                margin: EdgeInsets.zero,
                child: SwitchListTile(
                  title: const Text('Es curso bíblico'),
                  subtitle: const Text(
                    'Marcar si esta persona ya es un curso bíblico activo',
                  ),
                  value: _isBibleStudy,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _isBibleStudy = value;
                          });
                        },
                  secondary: Icon(
                    _isBibleStudy ? Icons.book : Icons.book_outlined,
                    color: _isBibleStudy
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _savePerson,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
