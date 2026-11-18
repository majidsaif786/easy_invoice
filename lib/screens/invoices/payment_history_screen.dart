
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> payments;
  final String currency;
  final String invoiceNumber;

  const PaymentHistoryScreen({
    super.key,
    required this.payments,
    required this.currency,
    required this.invoiceNumber,
  });

  String money(double amount) =>
      '$currency ${amount.toStringAsFixed(2)}';

  String formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    final total = payments.fold<double>(
      0,
      (sum, payment) =>
          sum + (payment['amount'] as num).toDouble(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Payments Received'),
                  const SizedBox(height: 8),
                  Text(
                    money(total),
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Invoice $invoiceNumber',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${payments.length} payments',
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: payments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 55,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No payments recorded yet',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: payments.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        final amount =
                            (payment['amount'] as num).toDouble();

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                          leading: Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(
                                alpha: 0.09,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.payments_outlined,
                              color: AppTheme.primary,
                            ),
                          ),
                          title: Text(
                            money(amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${payment['method'] ?? 'Payment'} • '
                            '${formatDate(payment['date'] ?? 'Date unavailable')}',
                          ),
                          trailing: const Icon(
                            Icons.check_circle,
                            color: AppTheme.primary,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
