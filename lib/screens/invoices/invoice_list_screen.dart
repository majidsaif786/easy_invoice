
import 'package:flutter/material.dart';
import 'invoice_details_screen.dart';
import '../../core/app_theme.dart';
import '../../services/local_invoice_store.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() =>
      _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = 'All';

 List<Map<String, dynamic>> get invoices =>
    LocalInvoiceStore.invoices;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredInvoices {
    final query = searchController.text.toLowerCase().trim();

    return invoices.where((invoice) {
      final matchesSearch =
          invoice['number'].toString().toLowerCase().contains(query) ||
          invoice['customer'].toString().toLowerCase().contains(query);

      final matchesStatus = selectedFilter == 'All' ||
          invoice['status'] == selectedFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF16A34A);
      case 'Unpaid':
        return const Color(0xFFDC2626);
      case 'Partial':
        return const Color(0xFFD97706);
      default:
        return Colors.grey;
    }
  }

  void showInvoiceActions(Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice['number'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _actionTile(
  Icons.visibility_outlined,
  'View Invoice',
  () {
    Navigator.pop(context);

    Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (_) => InvoiceDetailsScreen(
          invoice: invoice,
        ),
      ),
    );
  },
),
                _actionTile(
                  Icons.picture_as_pdf_outlined,
                  'Download PDF',
                  () {
                    Navigator.pop(context);
                    showMessage('PDF functionality will be connected later.');
                  },
                ),
                _actionTile(
                  Icons.print_outlined,
                  'Print Invoice',
                  () {
                    Navigator.pop(context);
                    showMessage('Print functionality will be connected later.');
                  },
                ),
                _actionTile(
                  Icons.share_outlined,
                  'Share Invoice',
                  () {
                    Navigator.pop(context);
                    showMessage('Share functionality will be connected later.');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      onTap: onTap,
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }



  @override
  Widget build(BuildContext context) {
    
    void showInvoiceActions(Map<String, dynamic> invoice) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(22),
      ),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('View Invoice'),
              onTap: () {
                Navigator.pop(sheetContext);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InvoiceDetailsScreen(
                      invoice: {
                        ...invoice,
                        'items': [
                          {
                            'name': 'Sample Service',
                            'price': invoice['total'],
                          },
                        ],
                        'subtotal': invoice['total'],
                        'tax': 0.0,
                        'discount': 0.0,
                        'amountPaid':
                            invoice['status'] == 'Paid'
                                ? invoice['total']
                                : invoice['status'] == 'Partial'
                                    ? invoice['total'] / 2
                                    : 0.0,
                        'payments': [],
                      },
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('Download PDF'),
              onTap: () {
                Navigator.pop(sheetContext);
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('PDF functionality will be connected later.')),
);              },
            ),
            ListTile(
              leading: const Icon(Icons.print_outlined),
              title: const Text('Print Invoice'),
              onTap: () {
                Navigator.pop(sheetContext);
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('PDF functionality will be connected later.')),
);              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Invoice'),
              onTap: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('PDF functionality will be connected later.')),
);
              },
            ),
          ],
        ),
      );
    },
  );
}


    final visibleInvoices = filteredInvoices;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoices',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search invoice or customer',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                ),
              ),
            ),

            SizedBox(
              height: 43,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['All', 'Paid', 'Unpaid', 'Partial']
                    .map((filter) {
                  final selected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppTheme.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppTheme.darkText,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.border,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Invoices',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${visibleInvoices.length} invoices',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: visibleInvoices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 55,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No invoices found',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try another search or filter.',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: visibleInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = visibleInvoices[index];
                        final color = statusColor(invoice['status']);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 43,
                                    width: 43,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.09,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long_outlined,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          invoice['customer'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          invoice['number'],
                                          style: const TextStyle(
                                            color: AppTheme.secondaryText,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        showInvoiceActions(invoice),
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                ],
                              ),

                              const Divider(height: 25),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Invoice Date',
                                        style: TextStyle(
                                          color: AppTheme.secondaryText,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        invoice['date'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Total Amount',
                                        style: TextStyle(
                                          color: AppTheme.secondaryText,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${invoice['currency']} ${invoice['total'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 13),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      invoice['status'],
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () =>
                                        showInvoiceActions(invoice),
                                    child: const Text('View Details'),
                                  ),
                                ],
                              ),
                            ],
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
