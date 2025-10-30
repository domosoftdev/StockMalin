import 'package:flutter/foundation.dart';
import '../models/shopping_list_item.dart';

class ShoppingListService extends ChangeNotifier {
  final List<ShoppingListItem> _items = [];

  List<ShoppingListItem> get items => _items;

  void addItem(String name) {
    // Évite les doublons, insensible à la casse et aux espaces
    final itemName = name.trim();
    if (itemName.isNotEmpty && !_items.any((item) => item.name.toLowerCase() == itemName.toLowerCase())) {
      _items.add(ShoppingListItem(name: itemName));
      notifyListeners();
    }
  }

  void removeItem(ShoppingListItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void toggleItemChecked(ShoppingListItem item) {
    item.isChecked = !item.isChecked;
    notifyListeners();
  }

  void transferSelectedItems() {
    // Logique de transfert des articles cochés (à implémenter)
    _items.removeWhere((item) => item.isChecked);
    notifyListeners();
  }

  void transferAllItems() {
    // Logique de transfert de tous les articles (à implémenter)
    _items.clear();
    notifyListeners();
  }
}
