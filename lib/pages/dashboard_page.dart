import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/product_provider.dart";

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static const Color navy = Color(0xFF0F3B54);
  static const Color orange = Color(0xFFF28A2E);
  static const Color paleYellow = Color(0xFFFFF4E1);
  static const Color cardBg = Color(0xFFF6F8FA);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    final items = prov.items;
    final useSoon = items.where((p) => p.note.isNotEmpty).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/inventory"),
        backgroundColor: navy,
        child: const Icon(Icons.qr_code_scanner),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text("Martin Family", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
              const CircleAvatar(child: Icon(Icons.person))
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text("Perishable items", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 6),
                    Text("3", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text("Low Stock", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 6),
                    Text("5", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ]),
                ),
              )
            ]),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: orange, padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () => Navigator.pushNamed(context, "/shopping"),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.shopping_cart_outlined, color: Colors.white),
                SizedBox(width: 8),
                Text("Shopping List", style: TextStyle(color: Colors.white))
              ]),
            ),
            const SizedBox(height: 18),
            const Text("Use soon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: useSoon.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final p = useSoon[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(p.name[0])),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(p.location),
                    trailing: p.note.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(color: paleYellow, borderRadius: BorderRadius.circular(8)),
                            child: Text(p.note, style: const TextStyle(fontSize: 12)),
                          )
                        : null,
                    onTap: () => Navigator.pushNamed(context, "/item/${p.id}"),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 66,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _NavItem(icon: Icons.home, label: "Dashboard", active: true),
          _NavItem(icon: Icons.inventory_2_outlined, label: "Inventory", onTap: () => Navigator.pushNamed(context, "/inventory")),
          const SizedBox(width: 48),
          _NavItem(icon: Icons.qr_code_scanner, label: "Scan"),
          _NavItem(icon: Icons.settings, label: "Settings"),
        ]),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _NavItem({Key? key, required this.icon, required this.label, this.active = false, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final color = active ? DashboardPage.navy : Colors.grey.shade500;
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color), const SizedBox(height: 4), Text(label, style: TextStyle(color: color, fontSize: 12))]),
    );
  }
}
