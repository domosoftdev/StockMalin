import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/product_provider.dart";

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    final items = prov.items.where((p) => p.quantity < 2 || p.note.toLowerCase().contains("low")).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping List"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          if (i == items.length) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF28A2E), padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () {},
              child: const Text("+ Add Item", style: TextStyle(color: Colors.white)),
            );
          }
          final p = items[i];
          return ListTile(
            // ignore: deprecated_member_use
            leading: Radio(value: p.id, groupValue: null, onChanged: (_) {}),
            title: Text(p.name),
            subtitle: Text(p.note.isNotEmpty ? p.note : "${p.quantity} left"),
            trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          );
        },
      ),
    );
  }
}
