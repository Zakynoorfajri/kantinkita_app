import 'package:flutter_test/flutter_test.dart';
import 'package:kantinkita_app/main.dart';

void main() {
  testWidgets('Profil tampil dan tombol Pesan Sekarang membuka Menu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FoodApp());

    expect(find.text('Zaky noorfajri'), findsOneWidget);

    await tester.tap(find.text('kantin kita'));
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Nasi Goreng Kampung'), findsOneWidget);
  });
}