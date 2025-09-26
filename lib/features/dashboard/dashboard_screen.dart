import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/expense_chart.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/budget_overview.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onNavigateToTransactions;

  const DashboardScreen({super.key, this.onNavigateToTransactions});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHeader(),
                const SizedBox(height: 24),
                // const GuestModeBanner(),
                // const SizedBox(height: 24),
                const BalanceCard(),
                const SizedBox(height: 24),
                const QuickActions(),
                const SizedBox(height: 24),
                const ExpenseChart(),
                const SizedBox(height: 24),
                RecentTransactions(
                  onSeeAllPressed: widget.onNavigateToTransactions,
                ),
                const SizedBox(height: 24),
                const BudgetOverview(),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    if (authProvider.isGuestMode) {
      await Future.wait([
        transactionProvider.loadDemoData(),
        budgetProvider.loadDemoData(),
      ]);
    } else {
      await Future.wait([
        transactionProvider.loadTransactions(userId: authProvider.user?.id),
        budgetProvider.loadBudgets(userId: authProvider.user?.id),
      ]);
    }
  }
}
