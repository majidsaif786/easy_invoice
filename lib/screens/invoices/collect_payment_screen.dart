
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class CollectPaymentScreen extends StatefulWidget {
  final String invoiceNumber;
  final String currency;
  final double balance;

  const CollectPaymentScreen({
    super.key,
    required this.invoiceNumber,
    required this.currency,
    required this.balance,
  });

  @override
  State<CollectPaymentScreen> createState() =>
      _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  final amountController = TextEditingController();
  String paymentMethod = 'Cash';

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  String money(double value) =>
      '${widget.currency} ${value.toStringAsFixed(2)}';

  void submitPayment() {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      showMessage('Enter a valid payment amount.');
      return;
    }

    if (amount > widget.balance) {
      showMessage('Payment cannot exceed the outstanding balance.');
      return;
    }

    Navigator.pop(context, amount);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collect Payment')),
      body: SingleChildScrollView(
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
                  const Text('Outstanding Balance'),
                  const SizedBox(height: 9),
                  Text(
                    money(widget.balance),
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invoice ${widget.invoiceNumber}',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Payment Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                prefixText: '${widget.currency} ',
                hintText: 'Enter amount',
                suffixIcon: IconButton(
                  tooltip: 'Pay full balance',
                  onPressed: () {
                    amountController.text =
                        widget.balance.toStringAsFixed(2);
                  },
                  icon: const Icon(Icons.done_all),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  amountController.text =
                      widget.balance.toStringAsFixed(2);
                },
                child: const Text('Pay Full Balance'),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: paymentMethod,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              items: ['Cash', 'Bank Transfer', 'Card', 'Other']
                  .map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => paymentMethod = value);
                }
              },
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: submitPayment,
                child: const Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
