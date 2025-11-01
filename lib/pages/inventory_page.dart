import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/product_provider.dart";

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    final items = prov.items;
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final p = items[i];
          return ListTile(
            onTap: () => Navigator.pushNamed(context, "/item/${p.id}"),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${p.location} • ${p.total}'),
            trailing: p.note.isNotEmpty ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
              child: Text(p.note, style: const TextStyle(fontSize: 12)),
            ) : null,
          );
        },
      ),
    );
  }
}
