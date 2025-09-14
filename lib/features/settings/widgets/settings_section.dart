import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';

class SettingsSection extends StatelessWidget {
  final AuthProvider authProvider;
  final ThemeProvider themeProvider;

  const SettingsSection({
    super.key,
    required this.authProvider,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildThemeToggle(),
          const Divider(),
          _buildBiometricToggle(),
          const Divider(),
          _buildNotificationsTile(),
          const Divider(),
          _buildLanguageTile(),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return ListTile(
      leading: Icon(
        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
      ),
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: themeProvider.isDarkMode,
        onChanged: (value) => themeProvider.toggleTheme(),
      ),
    );
  }

  Widget _buildBiometricToggle() {
    return ListTile(
      leading: const Icon(Icons.fingerprint),
      title: const Text('Biometric Authentication'),
      trailing: Switch(
        value: authProvider.isBiometricEnabled,
        onChanged: (value) async {
          if (value) {
            await authProvider.enableBiometric();
          }
        },
      ),
    );
  }

  Widget _buildNotificationsTile() {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to notification settings
      },
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: const Text('English'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to language settings
      },
    );
  }
}
