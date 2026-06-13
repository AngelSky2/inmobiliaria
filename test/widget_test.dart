import 'package:flutter_test/flutter_test.dart';
import 'package:inmobiliaria/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const InmobiliariaApp());
    await tester.pump();

    expect(find.text('Inmobiliaria'), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);
    expect(find.text('Ver Catálogo'), findsOneWidget);
  });
}
