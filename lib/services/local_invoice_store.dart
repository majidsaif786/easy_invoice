class LocalInvoiceStore {
  static final List<Map<String, dynamic>> invoices = [];

  static void addInvoice(Map<String, dynamic> invoice) {
    invoices.insert(0, invoice);
  }
}