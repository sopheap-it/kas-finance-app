import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/core.dart';

class AccountActionsSection extends StatelessWidget {
  final AuthProvider authProvider;

  const AccountActionsSection({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: authProvider.isGuestMode
            ? _buildGuestModeActions(context)
            : _buildAuthenticatedActions(context),
      ),
    );
  }

  List<Widget> _buildGuestModeActions(BuildContext context) {
    return [
      _buildExitGuestModeTile(context),
      const Divider(),
      _buildClearGuestDataTile(context),
    ];
  }

  List<Widget> _buildAuthenticatedActions(BuildContext context) {
    return [
      _buildSignOutTile(context),
      const Divider(),
      _buildDeleteAccountTile(context),
    ];
  }

  Widget _buildExitGuestModeTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.orange),
      title: const Text(
        'Exit Guest Mode',
        style: TextStyle(color: Colors.orange),
      ),
      subtitle: const Text('Return to login screen'),
      onTap: () => _showExitGuestModeDialog(context),
    );
  }

  Widget _buildClearGuestDataTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.clear_all, color: Colors.red),
      title: const Text(
        'Clear Guest Data',
        style: TextStyle(color: Colors.red),
      ),
      subtitle: const Text('Remove all demo data and reset'),
      onTap: () => _showClearGuestDataDialog(context),
    );
  }

  Widget _buildSignOutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
      onTap: () => _showSignOutDialog(context),
    );
  }

  Widget _buildDeleteAccountTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
      onTap: () => _showDeleteAccountDialog(context),
    );
  }

  void _showExitGuestModeDialog(BuildContext context) async {
    final result = await AppDialog.showConfirmation(
      context,
      title: 'Exit Guest Mode',
      message:
          'Are you sure you want to exit guest mode? You will lose all demo data and return to the login screen.',
      confirmText: 'Exit Guest Mode',
      isDangerous: true,
    );

    if (result == true && context.mounted) {
      authProvider.disableGuestMode();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showClearGuestDataDialog(BuildContext context) async {
    final result = await AppDialog.showConfirmation(
      context,
      title: 'Clear Guest Data',
      message:
          'This will remove all demo data and reset the app to its initial state. '
          'This action cannot be undone.',
      confirmText: 'Clear Data',
      isDangerous: true,
    );

    if (result == true && context.mounted) {
      await authProvider.clearGuestData();
      if (context.mounted) {
        context.showSuccessSnackBar('Guest data cleared successfully');
      }
    }
  }

  void _showSignOutDialog(BuildContext context) async {
    final result = await AppDialog.showConfirmation(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
    );

    if (result == true && context.mounted) {
      await authProvider.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _showDeleteAccountDialog(BuildContext context) async {
    final result = await AppDialog.showConfirmation(
      context,
      title: 'Delete Account',
      message:
          'Are you sure you want to delete your account? This action cannot be undone.',
      confirmText: 'Delete',
      isDangerous: true,
    );

    if (result == true && context.mounted) {
      await authProvider.deleteAccount();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}
