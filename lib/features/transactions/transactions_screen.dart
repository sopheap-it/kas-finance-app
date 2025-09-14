import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/transaction_model.dart';
import 'widgets/transaction_list_item.dart';
import 'widgets/transaction_details_modal.dart';
import 'widgets/empty_transactions_view.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Transactions'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterOptions,
        ),
        IconButton(icon: const Icon(Icons.search), onPressed: _showSearch),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return _buildErrorView(provider.errorMessage!);
        }

        final transactions = provider.transactions;

        if (transactions.isEmpty) {
          return const EmptyTransactionsView();
        }

        return _buildTransactionsList(provider);
      },
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading transactions',
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
            onPressed: () => _refreshTransactions(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(TransactionProvider provider) {
    final transactions = provider.transactions;

    return RefreshIndicator(
      onRefresh: _refreshTransactions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final category = provider.getCategoryById(transaction.categoryId);

          return TransactionListItem(
            transaction: transaction,
            category: category,
            onTap: () => _showTransactionDetails(transaction),
          );
        },
      ),
    );
  }

  void _showTransactionDetails(TransactionModel transaction) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailsModal(transaction: transaction),
    );
  }

  Future<void> _refreshTransactions() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isGuestMode) {
      await provider.loadDemoData();
    } else {
      await provider.loadTransactions(userId: authProvider.user?.id);
    }
  }

  void _showFilterOptions() {
    // TODO: Implement filter options
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filter options coming soon')));
  }

  void _showSearch() {
    // TODO: Implement search
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Search coming soon')));
  }
}
