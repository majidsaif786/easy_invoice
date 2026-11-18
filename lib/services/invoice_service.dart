import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> saveInvoice({
    required String customer,
    required String currency,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double tax,
    required double discount,
    required double total,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in before saving an invoice.');
    }

    final invoiceNumber =
        'INV-${DateTime.now().millisecondsSinceEpoch}';

    final docRef = await _firestore.collection('invoices').add({
      'userId': user.uid,
      'invoiceNumber': invoiceNumber,
      'customer': customer,
      'currency': currency,
      'items': items,
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'amountPaid': 0.0,
      'balanceDue': total,
      'status': 'Unpaid',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }
}
