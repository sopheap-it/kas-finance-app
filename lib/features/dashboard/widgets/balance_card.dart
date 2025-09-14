import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/core.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/transaction_provider.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final theme = Theme.of(context);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        // final isGuest = authProvider.isGuestMode;

        // Use real data from transactions
        final balance = transactionProvider.balance;
        final income = transactionProvider.totalIncome;
        final expense = transactionProvider.totalExpense;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Balance',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  // if (isGuest)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 8,
                  //       vertical: 4,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.2),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Text(
                  //       'Demo',
                  //       style: theme.textTheme.bodySmall?.copyWith(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormatter.format(balance),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceItem(
                    context,
                    'Income',
                    income,
                    Icons.trending_up,
                    Colors.green,
                    currencyFormatter,
                  ),
                  _buildBalanceItem(
                    context,
                    'Expense',
                    expense,
                    Icons.trending_down,
                    Colors.red,
                    currencyFormatter,
                  ),
                ],
              ),

              // if (isGuest) ...[
              //   const SizedBox(height: 20),
              //   Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: Colors.white.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Row(
              //       children: [
              //         const Icon(
              //           Icons.star_outline,
              //           color: Colors.white,
              //           size: 20,
              //         ),
              //         const SizedBox(width: 12),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'Unlock Full Features',
              //                 style: theme.textTheme.bodyMedium,
              //               ),
              //               Text(
              //                 'Sign up to save your data and access all features',
              //                 style: theme.textTheme.bodySmall,
              //               ),
              //             ],
              //           ),
              //         ),
              //         AppButton(
              //           type: AppButtonType.primary,
              //           text: 'Sign Up',
              //           isExpanded: false,
              //           onPressed: () {
              //             authProvider.disableGuestMode();
              //             Navigator.pushReplacementNamed(context, '/signup');
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
    NumberFormat currencyFormatter,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Text(
              currencyFormatter.format(amount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
