import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "providers/product_provider.dart";
import "pages/dashboard_page.dart";
import "pages/inventory_page.dart";
import "pages/item_detail_page.dart";
import "pages/shopping_list_page.dart";
import "l10n/app_localizations.dart";

void main() {
  runApp(const StockMalinApp());
}

class StockMalinApp extends StatelessWidget {
  const StockMalinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider()..loadSample(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "StockMalin",
        theme: ThemeData(
          primaryColor: const Color(0xFF0F3B54),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFF28A2E)),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: "/",
        routes: {
          "/": (_) => const DashboardPage(),
          "/inventory": (_) => const InventoryPage(),
          "/shopping": (_) => const ShoppingListPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name != null && settings.name!.startsWith("/item/")) {
            final id = settings.name!.split("/").last;
            return MaterialPageRoute(builder: (_) => ItemDetailPage(productId: id));
          }
          return null;
        },
      ),
    );
  }
}
