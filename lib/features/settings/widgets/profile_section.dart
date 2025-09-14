import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';

class ProfileSection extends StatelessWidget {
  final AuthProvider authProvider;

  const ProfileSection({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = authProvider.user;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(theme),
            const SizedBox(width: 16),
            Expanded(child: _buildUserInfo(theme, user)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: theme.colorScheme.primary,
      child: authProvider.isGuestMode
          ? const Icon(Icons.person_outline, color: Colors.white, size: 24)
          : Text(
              authProvider.user?.displayName?.substring(0, 1).toUpperCase() ??
                  'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildUserInfo(ThemeData theme, UserModel? user) {
    return Column(
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
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        if (authProvider.isGuestMode) _buildGuestBadge(theme),
      ],
    );
  }

  Widget _buildGuestBadge(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
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
    );
  }
}
