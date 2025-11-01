import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/product_provider.dart";

class ItemDetailPage extends StatelessWidget {
  final String productId;
  const ItemDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    final p = prov.findById(productId);
    if (p == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text("Product not found")));
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 160, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)), child: Text(p.name, style: const TextStyle(fontSize: 20))),
          const SizedBox(height: 18),
          Text(p.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(p.location),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () { prov.addToShoppingList(productId); }, child: const Text("Add to shopping list"))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () { prov.markConsumed(productId); }, child: const Text("Mark consumed"))),
          ]),
          const SizedBox(height: 18),
          const Text("History", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("A10 in Inventory"),
        ]),
      ),
    );
  }
}
