
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class InvoicePreviewScreen extends StatefulWidget {
  final String customer;
  final String currency;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  const InvoicePreviewScreen({
    super.key,
    required this.customer,
    required this.currency,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  });


  @override
  State<InvoicePreviewScreen> createState() =>
      _InvoicePreviewScreenState();

}

class _InvoicePreviewScreenState
    extends State<InvoicePreviewScreen> {
  Color selectedColor = AppTheme.primary;
  int selectedTemplate = 0;


  final List<Color> colors = [
    const Color(0xFF16A34A),
    const Color(0xFF2563EB),
    const Color(0xFF7C3AED),
    const Color(0xFF0F172A),
    const Color(0xFFEA580C),
  ];

  String money(double amount) =>
      '${widget.currency} ${amount.toStringAsFixed(2)}';
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Template',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _templateButton(0, 'Classic'),
                const SizedBox(width: 10),
                _templateButton(1, 'Modern'),
                const SizedBox(width: 10),
                _templateButton(2, 'Simple'),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Choose Color',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedColor = color);
                  },
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor: color,
                    child: selectedColor == color
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // Invoice paper
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: selectedColor,
                    child: const Text(
                      'INVOICE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Easy Invoice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Invoice Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'BILL TO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.customer.trim().isEmpty
                        ? 'Walking Customer'
                        : widget.customer,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: selectedColor.withValues(alpha: 0.10),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Item',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Amount',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ...widget.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(item['name'].toString()),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              money(item['price'] as double),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(height: 25),

                  _totalRow('Subtotal', money(widget.subtotal)),
                  if (widget.tax > 0)
                    _totalRow('Tax', money(widget.tax)),
                  if (widget.discount > 0)
                    _totalRow('Discount', '- ${money(widget.discount)}'),

                  const Divider(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'GRAND TOTAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        money(widget.total),
                        style: TextStyle(
                          color: selectedColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  Center(
                    child: Text(
                      'Thank you for your business!',
                      style: TextStyle(
                        color: selectedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'PDF generation will be added next.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Download PDF'),
              ),
            ),
            // Existing Download PDF button


// NEW Save Invoice button
const SizedBox(height: 12),


          ],
        ),
      ),
    );
  }
  

  Widget _templateButton(int index, String title) {
    final selected = selectedTemplate == index;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() => selectedTemplate = index);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selected ? selectedColor.withValues(alpha: 0.10) : Colors.white,
          foregroundColor: selected ? selectedColor : Colors.black87,
          side: BorderSide(
            color: selected ? selectedColor : Colors.grey.shade300,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _totalRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
