import 'package:flutter/material.dart';
import 'invoice_preview_screen.dart';
import '../../core/app_theme.dart';
import '../../services/local_invoice_store.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final String currency;

  const CreateInvoiceScreen({
    super.key,
    required this.currency,
  });

  @override
  State<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _InvoiceItem {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class _CreateInvoiceScreenState
    extends State<CreateInvoiceScreen> {
  final TextEditingController customerController =
      TextEditingController();

  final TextEditingController taxController =
      TextEditingController();

  final TextEditingController discountController =
      TextEditingController();

  final List<_InvoiceItem> items = [_InvoiceItem()];

  bool useTax = false;
  bool useDiscount = false;

  double get subtotal {
    return items.fold(0, (total, item) {
      return total +
          (double.tryParse(item.priceController.text) ?? 0);
    });
  }

  double get taxAmount {
    if (!useTax) return 0;
    return double.tryParse(taxController.text) ?? 0;
  }

  double get discountAmount {
    if (!useDiscount) return 0;
    return double.tryParse(discountController.text) ?? 0;
  }

  double get grandTotal {
    return (subtotal + taxAmount - discountAmount)
        .clamp(0, double.infinity)
        .toDouble();
  }

  @override
  void dispose() {
    customerController.dispose();
    taxController.dispose();
    discountController.dispose();

    for (final item in items) {
      item.dispose();
    }

    super.dispose();
  }

  void addItem() {
    setState(() {
      items.add(_InvoiceItem());
    });
  }

  void removeItem(int index) {
    if (items.length == 1) return;

    setState(() {
      items[index].dispose();
      items.removeAt(index);
    });
  }

  String money(double amount) {
    return '${widget.currency} ${amount.toStringAsFixed(2)}';
  }



void generateInvoice() {
  if (items.any((item) {
    final name = item.nameController.text.trim();
    final price = double.tryParse(item.priceController.text);

    return name.isEmpty || price == null || price <= 0;
  })) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please complete all item names and prices.'),
      ),
    );
    return;
  }

  if (taxAmount < 0 || discountAmount < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tax and discount cannot be negative.'),
      ),
    );
    return;
  }

  final invoiceItems = items.map((item) {
    return {
      'name': item.nameController.text.trim(),
      'price': double.parse(item.priceController.text),
    };
  }).toList();

  final customer = customerController.text.trim().isEmpty
      ? 'Walking Customer'
      : customerController.text.trim();

  final invoice = {
    'number': 'INV-${DateTime.now().millisecondsSinceEpoch}',
    'customer': customer,
    'currency': widget.currency,
    'items': invoiceItems,
    'subtotal': subtotal,
    'tax': taxAmount,
    'discount': discountAmount,
    'total': grandTotal,
    'amountPaid': 0.0,
    'payments': [],
    'date': DateTime.now().toString(),
    'status': 'Unpaid',
  };

  LocalInvoiceStore.addInvoice(invoice);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => InvoicePreviewScreen(
        customer: customer,
        currency: widget.currency,
        items: invoiceItems,
        subtotal: subtotal,
        tax: taxAmount,
        discount: discountAmount,
        total: grandTotal,
      ),
    ),
  );
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Invoice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: customerController,
                decoration: const InputDecoration(
                  labelText: 'Customer name',
                  hintText: 'Walking Customer',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Invoice Items',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add item'),
                    
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ...List.generate(items.length, (index) {
                final item = items[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Item ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (items.length > 1)
                            IconButton(
                              onPressed: () => removeItem(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: item.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item name',
                          hintText: 'e.g. Web Development',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: item.priceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: '0.00',
                          prefixText: '${widget.currency} ',
                          prefixIcon: const Icon(Icons.payments_outlined),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 18),

              // Tax option
              _OptionCard(
                title: 'Add Tax',
                subtitle: 'Add a tax amount to this invoice',
                value: useTax,
                onChanged: (value) {
                  setState(() => useTax = value);
                },
                child: useTax
                    ? TextField(
                        controller: taxController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Tax amount',
                          prefixText: '${widget.currency} ',
                        ),
                      )
                    : null,
              ),

              const SizedBox(height: 12),

              // Discount option
              _OptionCard(
                title: 'Add Discount',
                subtitle: 'Deduct a discount from this invoice',
                value: useDiscount,
                onChanged: (value) {
                  setState(() => useDiscount = value);
                },
                child: useDiscount
                    ? TextField(
                        controller: discountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Discount amount',
                          prefixText: '${widget.currency} ',
                        ),
                      )
                    : null,
              ),

              const SizedBox(height: 25),

              // Invoice summary
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      title: 'Subtotal',
                      value: money(subtotal),
                    ),
                    if (useTax)
                      _SummaryRow(
                        title: 'Tax',
                        value: money(taxAmount),
                      ),
                    if (useDiscount)
                      _SummaryRow(
                        title: 'Discount',
                        value: '- ${money(discountAmount)}',
                      ),
                    const Divider(height: 25),
                    _SummaryRow(
                      title: 'Grand Total',
                      value: money(grandTotal),
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: generateInvoice,
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Generate Invoice'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? child;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                activeThumbColor: AppTheme.primary,
                onChanged: onChanged,
              ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            child!,
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight:
                  isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppTheme.darkText,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? AppTheme.primary : AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
