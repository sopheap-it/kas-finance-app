import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../providers/transaction_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/transaction_model.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              final provider = Provider.of<TransactionProvider>(
                context,
                listen: false,
              );
              if (value == 'csv') {
                await _exportCsv(context, provider);
              } else if (value == 'pdf') {
                await _exportPdf(context, provider);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'csv', child: Text('Export CSV')),
              PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
            ],
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No data to analyze',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some transactions to see your reports',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Income',
                        '\$${provider.totalIncome.toStringAsFixed(2)}',
                        Colors.green,
                        Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'Total Expense',
                        '\$${provider.totalExpense.toStringAsFixed(2)}',
                        Colors.red,
                        Icons.trending_down,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Net Balance',
                        '\$${provider.balance.toStringAsFixed(2)}',
                        provider.balance >= 0 ? Colors.green : Colors.red,
                        provider.balance >= 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        'Transactions',
                        '${provider.transactions.length}',
                        Colors.blue,
                        Icons.receipt_long,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Expense Categories Chart
                if (provider.expensesByCategory.isNotEmpty) ...[
                  Text(
                    'Expense by Category',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(
                            provider.expensesByCategory,
                          ),
                          centerSpaceRadius: 50,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category Breakdown
                  Text(
                    'Category Breakdown',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...provider.expensesByCategory.entries.map((entry) {
                    final percentage =
                        (entry.value / provider.totalExpense) * 100;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}% of total',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${entry.value.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> data) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    int index = 0;
    return data.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;

      return PieChartSectionData(
        value: entry.value,
        title:
            '${((entry.value / data.values.fold(0.0, (a, b) => a + b)) * 100).toStringAsFixed(1)}%',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Future<void> _exportCsv(
    BuildContext context,
    TransactionProvider provider,
  ) async {
    try {
      final rows = <List<dynamic>>[];
      rows.add(['Date', 'Title', 'Category', 'Type', 'Amount', 'Description']);

      for (final t in provider.transactions) {
        final category = provider.getCategoryById(t.categoryId)?.name ?? '';
        rows.add([
          t.date.toIso8601String(),
          t.title,
          category,
          t.type.name,
          t.amount,
          t.description ?? '',
        ]);
      }

      final csv = const ListToCsvConverter().convert(rows);
      final Directory directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/kas_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(filePath);
      await file.writeAsString(csv);

      if (context.mounted) {
        await Share.shareXFiles([
          XFile(filePath),
        ], text: 'KAS Finance CSV Report');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to $filePath'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportPdf(
    BuildContext context,
    TransactionProvider provider,
  ) async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();

      // Load optimized logo image
      Uint8List? logoBytes;
      try {
        logoBytes = await rootBundle
            .load('assets/images/logo/kas-logo-60px.png')
            .then((data) => data.buffer.asUint8List());
      } catch (e) {
        // If logo fails to load, continue without it
        logoBytes = null;
      }
      final totalIncome = provider.transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = provider.transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);
      final netBalance = totalIncome - totalExpense;

      // Calculate expense by category
      final expenseByCategory = <String, double>{};
      for (final transaction in provider.transactions) {
        if (transaction.type == TransactionType.expense) {
          final category =
              provider.getCategoryById(transaction.categoryId)?.name ??
              'Unknown';
          expenseByCategory[category] =
              (expenseByCategory[category] ?? 0) + transaction.amount;
        }
      }

      // Calculate income by category
      final incomeByCategory = <String, double>{};
      for (final transaction in provider.transactions) {
        if (transaction.type == TransactionType.income) {
          final category =
              provider.getCategoryById(transaction.categoryId)?.name ??
              'Unknown';
          incomeByCategory[category] =
              (incomeByCategory[category] ?? 0) + transaction.amount;
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageTheme: const pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(32),
            textDirection: pw.TextDirection.ltr,
          ),
          build: (context) => [
            // Header with logo and branding
            _buildPdfHeader(logoBytes),
            pw.SizedBox(height: 20),

            // Report title and date
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Financial Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Generated on ${DateFormat('MMMM dd, yyyy').format(now)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Summary section
            _buildSummarySection(totalIncome, totalExpense, netBalance),
            pw.SizedBox(height: 30),

            // Expense breakdown by category
            if (expenseByCategory.isNotEmpty) ...[
              pw.Text(
                'Expense Breakdown by Category',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.SizedBox(height: 15),
              _buildCategoryBreakdown(expenseByCategory, PdfColors.red),
              pw.SizedBox(height: 30),
            ],

            // Income breakdown by category
            if (incomeByCategory.isNotEmpty) ...[
              pw.Text(
                'Income Breakdown by Category',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.SizedBox(height: 15),
              _buildCategoryBreakdown(incomeByCategory, PdfColors.green),
              pw.SizedBox(height: 30),
            ],

            // Transaction details
            pw.Text(
              'Transaction Details',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 15),
            _buildTransactionTable(provider),

            // Footer
            pw.SizedBox(height: 40),
            _buildPdfFooter(),
          ],
        ),
      );

      final Directory directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/kas_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        await Share.shareXFiles([XFile(path)], text: 'KAS Finance PDF Report');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Saved to $path')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // PDF Helper Methods
  pw.Widget _buildPdfHeader(Uint8List? logoBytes) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.blue600, PdfColors.blue800],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'KAS Finance',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Personal Finance Management',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.blue100,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  'Financial Report',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (logoBytes != null)
            pw.Container(
              width: 80,
              height: 80,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(40),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Image(
                  pw.MemoryImage(logoBytes),
                  fit: pw.BoxFit.contain,
                ),
              ),
            )
          else
            pw.Container(
              width: 80,
              height: 80,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(40),
              ),
              child: pw.Center(
                child: pw.Text(
                  'KAS',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildSummarySection(
    double totalIncome,
    double totalExpense,
    double netBalance,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Financial Summary',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildPdfSummaryCard(
                'Total Income',
                totalIncome,
                PdfColors.green,
              ),
              _buildPdfSummaryCard(
                'Total Expense',
                totalExpense,
                PdfColors.red,
              ),
              _buildPdfSummaryCard(
                'Net Balance',
                netBalance,
                netBalance >= 0 ? PdfColors.green : PdfColors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfSummaryCard(String title, double amount, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          '\$${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCategoryBreakdown(
    Map<String, double> categoryData,
    PdfColor amountColor,
  ) {
    final sortedCategories = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        children: [
          for (int i = 0; i < sortedCategories.length; i++)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      sortedCategories[i].key,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      '\$${sortedCategories[i].value.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: amountColor,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildTransactionTable(TransactionProvider provider) {
    final transactions = provider.transactions
        .take(50)
        .toList(); // Limit to 50 transactions

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FixedColumnWidth(80),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FixedColumnWidth(60),
        4: const pw.FixedColumnWidth(80),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Date',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Description',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Category',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Type',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Amount',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
        // Data rows
        for (final transaction in transactions)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  DateFormat('MM/dd/yy').format(transaction.date),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  transaction.title,
                  style: const pw.TextStyle(fontSize: 9),
                  maxLines: 2,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  provider.getCategoryById(transaction.categoryId)?.name ??
                      'Unknown',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  transaction.type.name.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 9,
                    color: transaction.type == TransactionType.income
                        ? PdfColors.green
                        : PdfColors.red,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 9,
                    color: transaction.type == TransactionType.income
                        ? PdfColors.green
                        : PdfColors.red,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildPdfFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by KAS Finance App',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page 1',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }
}
