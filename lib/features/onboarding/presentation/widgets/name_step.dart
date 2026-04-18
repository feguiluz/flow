import 'package:flutter/material.dart';

/// Step 1: User name input
class NameStep extends StatefulWidget {
  const NameStep({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(
            Icons.person_outline,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            '¿Cuál es tu nombre?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Ingresa tu nombre completo',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Input field
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Nombre y apellidos',
              hintText: 'Ej: Juan Pérez García',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.badge_outlined),
              helperText:
                  'Usa tu nombre completo tal como aparece en tu tarjeta de publicador',
            ),
            onSubmitted: (_) {
              // Trigger validation on submit
              widget.onChanged(_controller.text);
            },
          ),
        ],
      ),
    );
  }
}
