import "dart:convert";
import "package:flutter/services.dart";
import "package:flutter/foundation.dart";
import "../models/product.dart";

class ProductProvider extends ChangeNotifier {
  final List<Product> _items = [];
  bool _loaded = false;

  List<Product> get items => List.unmodifiable(_items);

  Future<void> loadSample() async {
    if (_loaded) return;
    final s = await rootBundle.loadString("lib/data/sample_products.json");
    final data = json.decode(s) as List<dynamic>;
    _items.addAll(data.map((e) => Product.fromJson(e as Map<String, dynamic>)));
    _loaded = true;
    notifyListeners();
  }

  Product? findById(String id) => _items.firstWhere((p) => p.id == id, orElse: () => null);

  void markConsumed(String id) {
    final p = findById(id);
    if (p != null) {
      final idx = _items.indexOf(p);
      final newQ = (p.quantity - 1).clamp(0, p.total);
      _items[idx] = Product(
        id: p.id,
        name: p.name,
        location: p.location,
        quantity: newQ,
        total: p.total,
        image: p.image,
        note: p.note,
      );
      notifyListeners();
    }
  }

  void addToShoppingList(String id) {
    notifyListeners();
  }
}
