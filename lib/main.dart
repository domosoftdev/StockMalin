import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/shopping_list_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ShoppingListService(),
      child: const StockHomeApp(),
    ),
  );
}

import 'app_theme.dart';

class StockHomeApp extends StatelessWidget {
  const StockHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockHome',
      theme: buildAppTheme(),
      home: const HomePage(),
    );
  }
}

import 'screens/shopping_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockHome'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShoppingListPage()),
            );
          },
          child: const Text('Voir la liste de courses'),
        ),
      ),
    );
  }
}
