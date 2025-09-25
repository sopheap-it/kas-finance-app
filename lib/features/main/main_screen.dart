import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../transactions/transactions_screen.dart';
import '../budgets/budgets_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/add_transaction_modal.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      DashboardScreen(onNavigateToTransactions: () => _onTabTapped(1)),
      const TransactionsScreen(),
      const BudgetsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    // Load data when the main screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    if (authProvider.isAuthenticated && authProvider.user != null) {
      final userId = authProvider.user!.id;

      // Load transactions and budgets for the authenticated user
      await Future.wait([
        transactionProvider.loadTransactions(userId: userId),
        budgetProvider.loadBudgets(userId: userId),
      ]);

      // Update budget spending based on transactions
      await budgetProvider.updateBudgetSpending(
        transactionProvider.allTransactions,
      );
    } else if (authProvider.isGuestMode) {
      // Do not load demo data for guest users; start empty
      await Future.wait([
        transactionProvider.loadTransactions(userId: 'guest'),
        budgetProvider.loadBudgets(userId: 'guest'),
      ]);
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildCustomBottomNavigationBar(context, theme),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isGuestMode) {
                  return FloatingActionButton.extended(
                    onPressed: () => _showGuestSignUpPrompt(context),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Sign Up'),
                  );
                }
                return FloatingActionButton(
                  onPressed: () => _showAddTransactionModal(context),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                );
              },
            )
          : null,
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionModal(),
    );
  }

  void _showGuestSignUpPrompt(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guest Mode'),
        content: const Text(
          'You are currently in guest mode. Sign up to save your data and access all features.',
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

  Widget _buildCustomBottomNavigationBar(
    BuildContext context,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withOpacity(0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                theme,
                index: 0,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: 'Dashboard',
              ),
              _buildNavItem(
                context,
                theme,
                index: 1,
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Transactions',
              ),
              _buildNavItem(
                context,
                theme,
                index: 2,
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: 'Budgets',
              ),
              _buildNavItem(
                context,
                theme,
                index: 3,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: 'Reports',
              ),
              _buildNavItem(
                context,
                theme,
                index: 4,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    ThemeData theme, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? Colors.white
                    : colorScheme.onSurface.withOpacity(0.6),
                size: 18,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style:
                  theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 10,
                  ) ??
                  const TextStyle(),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
