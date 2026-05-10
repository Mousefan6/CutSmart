import 'package:cutsmart/App/Scenes/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Profile page shows camera scanner button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LandingApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.photo_camera), findsOneWidget);
  });
}
