import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/core.dart';

class GuestActionsSection extends StatelessWidget {
  final AuthProvider authProvider;

  const GuestActionsSection({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    if (!authProvider.isGuestMode) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Column(
        children: [
          _buildCreateAccountTile(context),
          const Divider(),
          _buildGuestModeInfoTile(context),
        ],
      ),
    );
  }

  Widget _buildCreateAccountTile(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.person_add, color: theme.colorScheme.primary),
      title: Text(
        'Create Account',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: const Text('Sign up to save your data and access all features'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showSignUpDialog(context),
    );
  }

  Widget _buildGuestModeInfoTile(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        Icons.info_outline,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      title: const Text('About Guest Mode'),
      subtitle: const Text('Learn more about guest mode limitations'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showGuestModeInfo(context),
    );
  }

  void _showSignUpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up'),
        content: const Text(
          'You are currently in guest mode. To save your data and access all features, please sign up.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.disableGuestMode();
              Navigator.pushReplacementNamed(context, '/signup');
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  void _showGuestModeInfo(BuildContext context) {
    AppDialog.showInfo(
      context,
      title: 'Guest Mode Information',
      message:
          'Guest mode allows you to explore the app without creating an account. '
          'Your data is not saved and some features might be limited. '
          'To fully utilize the app, please consider signing up.',
    );
  }
}
