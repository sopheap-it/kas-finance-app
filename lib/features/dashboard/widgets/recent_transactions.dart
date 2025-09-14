import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/transaction_provider.dart';
import '../../../models/transaction_model.dart';

class RecentTransactions extends StatelessWidget {
  final VoidCallback? onSeeAllPressed;

  const RecentTransactions({super.key, this.onSeeAllPressed});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final theme = Theme.of(context);
        final recentTransactions = transactionProvider.getRecentTransactions(
          limit: 5,
        );

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: onSeeAllPressed,
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (recentTransactions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No transactions yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    final category = transactionProvider.getCategoryById(
                      transaction.categoryId,
                    );

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              category?.color.withOpacity(0.2) ??
                              Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          transaction.type == TransactionType.income
                              ? Icons.add
                              : Icons.remove,
                          color: category?.color ?? Colors.grey,
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMM dd, yyyy').format(transaction.date),
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Text(
                        '${transaction.type == TransactionType.income ? '+' : '-'}${currencyFormatter.format(transaction.amount)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: transaction.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
