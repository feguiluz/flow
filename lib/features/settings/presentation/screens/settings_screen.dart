import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flow/features/backup/presentation/widgets/backup_section.dart';
import 'package:flow/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:flow/shared/models/gender.dart';
import 'package:flow/shared/models/publisher_type.dart';
import 'package:flow/shared/providers/theme_provider.dart';
import 'package:flow/shared/providers/user_profile_provider.dart';

/// Settings screen - Profile and configuration
///
/// Displays:
/// - User profile (name, publisher type, age/gender)
/// - Edit profile button
/// - Theme selection (future)
/// - About & version info (future)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: userProfileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name ?? 'Usuario',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.publisherType?.displayName ??
                                    'No especificado',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      Icons.badge,
                      'Género',
                      profile.gender?.displayName ?? 'No especificado',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      Icons.calendar_today,
                      'Edad',
                      profile.age != null
                          ? '${profile.age} años'
                          : 'No especificado',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Edit Profile Button
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
            ),

            const SizedBox(height: 32),

            // Theme Section
            Text(
              'APARIENCIA',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            _buildThemeSelector(context, ref, theme, colorScheme),

            const SizedBox(height: 32),

            // Backup Section
            Text(
              'COPIA DE SEGURIDAD',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const BackupSection(),

            const SizedBox(height: 32),

            // About Section
            Text(
              'ACERCA DE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    title: const Text('Versión'),
                    subtitle: const Text('1.2.4'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.code,
                      color: colorScheme.primary,
                    ),
                    title: const Text('Flow'),
                    subtitle: const Text(
                        'App de registro de actividad de predicación'),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error al cargar perfil: $error',
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Card(
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Predeterminado del sistema'),
            subtitle: const Text('Usar el tema del dispositivo'),
            value: ThemeMode.system,
            groupValue: currentTheme,
            secondary: Icon(
              Icons.brightness_auto,
              color: colorScheme.primary,
            ),
            onChanged: (value) {
              if (value != null) {
                ref.read(themeNotifierProvider.notifier).setThemeMode(value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<ThemeMode>(
            title: const Text('Claro'),
            subtitle: const Text('Tema claro'),
            value: ThemeMode.light,
            groupValue: currentTheme,
            secondary: Icon(
              Icons.light_mode,
              color: colorScheme.primary,
            ),
            onChanged: (value) {
              if (value != null) {
                ref.read(themeNotifierProvider.notifier).setThemeMode(value);
              }
            },
          ),
          const Divider(height: 1),
          RadioListTile<ThemeMode>(
            title: const Text('Oscuro'),
            subtitle: const Text('Tema oscuro'),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            secondary: Icon(
              Icons.dark_mode,
              color: colorScheme.primary,
            ),
            onChanged: (value) {
              if (value != null) {
                ref.read(themeNotifierProvider.notifier).setThemeMode(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
