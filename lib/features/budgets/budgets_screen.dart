import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/budget_model.dart';
import 'widgets/budget_card.dart';
import 'widgets/empty_budgets_view.dart';
import 'add_budget_screen.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Events'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _addNewBudget(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return _buildErrorView(provider.errorMessage!);
        }

        final budgets = provider.budgets;

        if (budgets.isEmpty) {
          return const EmptyBudgetsView();
        }

        return _buildBudgetsList(budgets);
      },
    );
  }

  Widget _buildErrorView(String error) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading budgets',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _refreshBudgets(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetsList(List<BudgetModel> budgets) {
    return Builder(
      builder: (context) => RefreshIndicator(
        onRefresh: () => _refreshBudgets(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];

            return BudgetCard(
              budget: budget,
              onTap: () => _showBudgetDetails(context, budget),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshBudgets(BuildContext context) async {
    final provider = Provider.of<BudgetProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isGuestMode) {
      await provider.loadDemoData();
    } else {
      await provider.loadBudgets(userId: authProvider.user?.id);
    }
  }

  void _addNewBudget(BuildContext context) {
    Navigator.of(context)
        .push<bool>(
          MaterialPageRoute<bool>(
            builder: (context) => const AddBudgetScreen(),
          ),
        )
        .then((result) {
          // Refresh data if budget was added
          if (result == true) {
            _refreshBudgets(context);
          }
        });
  }

  void _showBudgetDetails(BuildContext context, BudgetModel budget) {
    // TODO: Implement budget details
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Budget details coming soon')));
  }
}
