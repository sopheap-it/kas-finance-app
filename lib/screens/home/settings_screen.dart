import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../app/widgets/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, child) {
          final user = authProvider.user;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: theme.colorScheme.primary,
                        child: authProvider.isGuestMode
                            ? Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 24,
                              )
                            : Text(
                                user?.displayName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.isGuestMode
                                  ? 'Guest User'
                                  : (user?.displayName ?? 'User'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              authProvider.isGuestMode
                                  ? 'Explore the app without an account'
                                  : (user?.email ?? ''),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (authProvider.isGuestMode)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Guest Mode',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Guest Mode Actions
              if (authProvider.isGuestMode)
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person_add,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(
                          'Create Account',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Sign up to save your data and access all features',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showSignUpDialog(context),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        title: const Text('About Guest Mode'),
                        subtitle: const Text(
                          'Learn more about guest mode limitations',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showGuestModeInfo(context),
                      ),
                    ],
                  ),
                ),

              if (authProvider.isGuestMode) const SizedBox(height: 20),

              // Settings Options
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: const Text('Dark Mode'),
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
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
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to notification settings
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      subtitle: const Text('English'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to language settings
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Support Section
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Help & Support'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to help
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Show privacy policy
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('About'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Show about
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Account Actions
              Card(
                child: Column(
                  children: [
                    if (authProvider.isGuestMode) ...[
                      // Guest Mode Actions
                      ListTile(
                        leading: const Icon(
                          Icons.exit_to_app,
                          color: Colors.orange,
                        ),
                        title: const Text(
                          'Exit Guest Mode',
                          style: TextStyle(color: Colors.orange),
                        ),
                        subtitle: const Text('Return to login screen'),
                        onTap: () =>
                            _showExitGuestModeDialog(context, authProvider),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.clear_all, color: Colors.red),
                        title: const Text(
                          'Clear Guest Data',
                          style: TextStyle(color: Colors.red),
                        ),
                        subtitle: const Text('Remove all demo data and reset'),
                        onTap: () =>
                            _showClearGuestDataDialog(context, authProvider),
                      ),
                    ] else ...[
                      // Authenticated User Actions
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () => _showSignOutDialog(context, authProvider),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () =>
                            _showDeleteAccountDialog(context, authProvider),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // App Version
              Center(
                child: Text(
                  'KAS Finance v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          SecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            height: 40,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Sign Out',
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            isFullWidth: false,
            height: 40,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          SecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            height: 40,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Delete',
            onPressed: () async {
              await authProvider.deleteAccount();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            isFullWidth: false,
            height: 40,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showSignUpDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up'),
        content: const Text(
          'You are currently in guest mode. To save your data and access all features, please sign up.',
        ),
        actions: [
          SecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            height: 40,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Sign Up',
            onPressed: () {
              Navigator.pop(context);
              authProvider.disableGuestMode();
              Navigator.pushReplacementNamed(context, '/signup');
            },
            isFullWidth: false,
            height: 40,
          ),
        ],
      ),
    );
  }

  void _showGuestModeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guest Mode Information'),
        content: const Text(
          'Guest mode allows you to explore the app without creating an account. '
          'Your data is not saved and some features might be limited. '
          'To fully utilize the app, please consider signing up.',
        ),
        actions: [
          PrimaryButton(
            text: 'OK',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            height: 40,
          ),
        ],
      ),
    );
  }

  void _showExitGuestModeDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Guest Mode'),
        content: const Text(
          'Are you sure you want to exit guest mode? You will lose all demo data and return to the login screen.',
        ),
        actions: [
          SecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            height: 40,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Exit Guest Mode',
            onPressed: () {
              Navigator.pop(context);
              authProvider.disableGuestMode();
              Navigator.pushReplacementNamed(context, '/login');
            },
            isFullWidth: false,
            height: 40,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _showClearGuestDataDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Guest Data'),
        content: const Text(
          'This will remove all demo data and reset the app to its initial state. '
          'This action cannot be undone.',
        ),
        actions: [
          SecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            height: 40,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Clear Data',
            onPressed: () async {
              Navigator.pop(context);
              // Clear demo data by reloading it
              await authProvider.clearGuestData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Guest data cleared successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            isFullWidth: false,
            height: 40,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
