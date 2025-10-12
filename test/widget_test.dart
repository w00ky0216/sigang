// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:sigang_app/main.dart';

void main() {
  testWidgets('Market app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MarketApp());

    // Verify that our app loads properly
    expect(find.text('원주중앙시장'), findsOneWidget);
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('상점'), findsOneWidget);
    expect(find.text('찜'), findsOneWidget);
    expect(find.text('마이'), findsOneWidget);
  });
}
