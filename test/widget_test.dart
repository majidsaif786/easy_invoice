
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_invoice/main.dart';

void main() {
  testWidgets('Easy Invoice app loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EasyInvoiceApp());

    expect(find.text('Easy Invoice'), findsOneWidget);
    expect(
      find.text('Firebase Connected Successfully!'),
      findsOneWidget,
    );
  });
}
