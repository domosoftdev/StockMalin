import "package:flutter_test/flutter_test.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:stockmalin/providers/product_provider.dart";
import "package:stockmalin/pages/dashboard_page.dart";

void main() {
  testWidgets("Dashboard loads and shows title", (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => ProductProvider()..loadSample(), child: const MaterialApp(home: DashboardPage())),
    );
    await tester.pumpAndSettle();
    expect(find.text("Martin Family"), findsOneWidget);
    expect(find.text("Use soon"), findsOneWidget);
  });
}
