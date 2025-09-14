import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'widgets/profile_section.dart';
import 'widgets/guest_actions_section.dart';
import 'widgets/settings_section.dart';
import 'widgets/account_actions_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProfileSection(authProvider: authProvider),
              const SizedBox(height: 20),
              GuestActionsSection(authProvider: authProvider),
              if (authProvider.isGuestMode) const SizedBox(height: 20),
              SettingsSection(
                authProvider: authProvider,
                themeProvider: themeProvider,
              ),
              const SizedBox(height: 20),
              _buildSupportSection(context),
              // const SizedBox(height: 20),
              // AccountActionsSection(authProvider: authProvider),
              const SizedBox(height: 32),
              _buildAppVersion(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _navigateToHelp(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAbout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        'KAS Finance v1.0.0',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
      ),
    );
  }

  void _navigateToHelp(BuildContext context) {
    // TODO: Navigate to help screen
  }

  void _showPrivacyPolicy(BuildContext context) {
    // TODO: Show privacy policy
  }

  void _showAbout(BuildContext context) {
    // TODO: Show about dialog
  }
}
