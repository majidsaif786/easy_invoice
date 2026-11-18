
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'collect_payment_screen.dart';
import 'payment_history_screen.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
  });

  @override
  State<InvoiceDetailsScreen> createState() =>
      _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late double amountPaid;
  late List<Map<String, dynamic>> payments;

  double get total => (widget.invoice['total'] as num).toDouble();
  double get balance => (total - amountPaid).clamp(0, double.infinity).toDouble();

  String get status {
    if (balance <= 0) return 'Paid';
    if (amountPaid > 0) return 'Partial';
    return 'Unpaid';
  }

  @override
  void initState() {
    super.initState();
    amountPaid = (widget.invoice['amountPaid'] as num?)?.toDouble() ?? 0;
    payments = List<Map<String, dynamic>>.from(
      widget.invoice['payments'] ?? [],
    );
  }

  String money(double value) =>
      '${widget.invoice['currency']} ${value.toStringAsFixed(2)}';

  Color get statusColor {
    if (status == 'Paid') return Colors.green;
    if (status == 'Partial') return Colors.orange;
    return Colors.red;
  }

  Future<void> collectPayment() async {
    if (balance <= 0) return;

    final result = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => CollectPaymentScreen(
          invoiceNumber: widget.invoice['number'],
          currency: widget.invoice['currency'],
          balance: balance,
        ),
      ),
    );

    if (result == null || result <= 0) return;

    setState(() {
      amountPaid += result;
      payments.add({
        'amount': result,
        'date': DateTime.now(),
        'method': 'Cash',
      });
    });
  }

  void openPaymentHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentHistoryScreen(
          payments: payments,
          currency: widget.invoice['currency'],
          invoiceNumber: widget.invoice['number'],
        ),
      ),
    );
  }

  void showAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action will be connected by your developer.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = List<Map<String, dynamic>>.from(
      widget.invoice['items'] ?? [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        actions: [
          IconButton(
            onPressed: () => showAction('More invoice options'),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'INVOICE',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  widget.invoice['number'],
                  style: const TextStyle(color: AppTheme.secondaryText),
                ),
                const SizedBox(height: 20),
                const Text('BILL TO'),
                const SizedBox(height: 5),
                Text(
                  widget.invoice['customer'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                const Divider(),
                const SizedBox(height: 8),
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item['name'].toString())),
                      Text(money((item['price'] as num).toDouble())),
                    ],
                  ),
                )),
                const Divider(height: 25),
                _detailRow('Subtotal', money(
                  (widget.invoice['subtotal'] as num).toDouble(),
                )),
                if ((widget.invoice['tax'] as num? ?? 0) > 0)
                  _detailRow('Tax', money(
                    (widget.invoice['tax'] as num).toDouble(),
                  )),
                if ((widget.invoice['discount'] as num? ?? 0) > 0)
                  _detailRow('Discount', '- ${money(
                    (widget.invoice['discount'] as num).toDouble(),
                  )}'),
                const Divider(height: 25),
                _detailRow('Total', money(total), bold: true),
                _detailRow('Amount Paid', money(amountPaid)),
                _detailRow(
                  'Balance Due',
                  money(balance),
                  bold: true,
                  color: balance > 0 ? Colors.red : Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: balance > 0 ? collectPayment : null,
              icon: const Icon(Icons.payments_outlined),
              label: Text(balance > 0 ? 'Collect Payment' : 'Fully Paid'),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: openPaymentHistory,
            icon: const Icon(Icons.history),
            label: const Text('Payment History'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => showAction('Download PDF'),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Download PDF'),
          ),
          OutlinedButton.icon(
            onPressed: () => showAction('Print Invoice'),
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print Invoice'),
          ),
          OutlinedButton.icon(
            onPressed: () => showAction('Share Invoice'),
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share Invoice'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String title,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          )),
          Text(value, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          )),
        ],
      ),
    );
  }
}
