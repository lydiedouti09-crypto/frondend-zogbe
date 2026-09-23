import 'package:flutter_test/flutter_test.dart';
import 'package:zogbe/main.dart';

void main() {
  testWidgets('Vérification du chargement de l\'écran de connexion Zògbé', (WidgetTester tester) async {
    await tester.pumpWidget(const ZogbeApp());
    await tester.pumpAndSettle();

    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
