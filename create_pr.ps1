# create_pr.ps1
# Script : crée fichiers, branche, commit, push et PR pour StockMalin
# Exécutez depuis la racine du dépôt StockMalin.
# Prérequis : git et gh (GitHub CLI) installés et authentifiés.

$ErrorActionPreference = "Stop"

# Config
$branch = "feat/add-complete-ui-and-sample-data"
$prTitle = "feat(UI): add complete app UI & sample data"
$prBody = @"
Ajout des pages Dashboard, Inventory, Item Detail, Shopping List, ProductProvider et d'un jeu de données sample_products.json pour tests.
- UI prototype (lib/pages/*.dart)
- Provider + modèle (lib/providers, lib/models)
- Fichier de données : lib/data/sample_products.json
- Test widget simple : test/widget_test.dart

Merci de réviser et valider.
"@

Write-Host "Vérification: git et gh disponibles..."
git --version > $null
gh --version > $null

# Backup (optionnel mais recommandé)
$backupPath = "$env:USERPROFILE\Desktop\StockMalin-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').zip"
Write-Host "Création d'une sauvegarde ZIP sur le Bureau :" $backupPath
Compress-Archive -Path . -DestinationPath $backupPath -Force

# Fichiers à créer (chemin -> contenu)
$files = @{}

$files["lib/models/product.dart"] = @'
class Product {
  final String id;
  final String name;
  final String location;
  final int quantity;
  final int total;
  final String image;
  final String note;

  Product({
    required this.id,
    required this.name,
    required this.location,
    required this.quantity,
    required this.total,
    required this.image,
    required this.note,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as String,
        name: j['name'] as String,
        location: j['location'] as String? ?? '',
        quantity: (j['quantity'] as num).toInt(),
        total: (j['total'] as num).toInt(),
        image: j['image'] as String? ?? '',
        note: j['note'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'quantity': quantity,
        'total': total,
        'image': image,
        'note': note,
      };
}
'@

$files["lib/providers/product_provider.dart"] = @'
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
'@

$files["lib/data/sample_products.json"] = @'
[
  {
    "id": "p1",
    "name": "Bread",
    "location": "Kitchen",
    "quantity": 1,
    "total": 10,
    "image": "",
    "note": ""
  },
  {
    "id": "p2",
    "name": "Apple",
    "location": "Kitchen",
    "quantity": 5,
    "total": 10,
    "image": "",
    "note": "Expires in 3 days"
  },
  {
    "id": "p3",
    "name": "Canned Tuna",
    "location": "Basement",
    "quantity": 1,
    "total": 5,
    "image": "",
    "note": "Low stock"
  },
  {
    "id": "p4",
    "name": "Baked Beans",
    "location": "Kitchen",
    "quantity": 9,
    "total": 500,
    "image": "",
    "note": "Expires in 5 days"
  }
]
'@

$files["lib/pages/dashboard_page.dart"] = @'
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
'@

$files["lib/pages/inventory_page.dart"] = @'
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
'@

$files["lib/pages/item_detail_page.dart"] = @'
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
'@

$files["lib/pages/shopping_list_page.dart"] = @'
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
'@

$files["lib/main.dart"] = @'
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "providers/product_provider.dart";
import "pages/dashboard_page.dart";
import "pages/inventory_page.dart";
import "pages/item_detail_page.dart";
import "pages/shopping_list_page.dart";

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
'@

$files["test/widget_test.dart"] = @'
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
'@

# Ecrire les fichiers
foreach ($p in $files.Keys) {
  $dir = Split-Path $p -Parent
  if (!(Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  $content = $files[$p]
  Write-Host "Ecriture :" $p
  $content | Set-Content -Path $p -Encoding UTF8
}

# Mettre à jour pubspec.yaml : ajouter provider si manquant, et assets
$pub = "pubspec.yaml"
if (Test-Path $pub) {
  $pubContent = Get-Content $pub -Raw
  if ($pubContent -notmatch "provider:") {
    Write-Host "Ajout de provider dans les dépendances..."
    # simple insertion après 'dependencies:' (si trouvée)
    if ($pubContent -match "(?ms)dependencies:\s*") {
      $pubContent = $pubContent -replace "(?ms)(dependencies:\s*)(\r?\n)", "`$1`$2  provider: ^6.0.5`n"
      Set-Content -Path $pub -Value $pubContent -Encoding UTF8
    } else {
      Add-Content -Path $pub -Value "`ndependencies:`n  provider: ^6.0.5"
    }
  } else {
    Write-Host "provider déjà présent dans pubspec.yaml"
  }

  if ($pubContent -notmatch "assets:\s*-\s*lib/data/sample_products.json") {
    Write-Host "Ajout d'assets (sample_products.json) dans pubspec.yaml..."
    if ($pubContent -match "(?ms)flutter:\s*") {
      # essayer d'ajouter assets sous flutter: si possible
      $pubContent = Get-Content $pub -Raw
      if ($pubContent -match "(?ms)flutter:\s*(\r?\n)(\s*uses-material-design:.*\r?\n)") {
        $pubContent = $pubContent -replace "(?ms)(flutter:\s*(\r?\n)(\s*uses-material-design:.*\r?\n))", "`$1`n  assets:`n    - lib/data/sample_products.json`n"
        Set-Content -Path $pub -Value $pubContent -Encoding UTF8
      } else {
        Add-Content -Path $pub -Value "`nflutter:`n  assets:`n    - lib/data/sample_products.json"
      }
    } else {
      Add-Content -Path $pub -Value "`nflutter:`n  uses-material-design: true`n  assets:`n    - lib/data/sample_products.json"
    }
  } else {
    Write-Host "assets déjà présent"
  }
} else {
  Write-Host "Avertissement : pubspec.yaml introuvable à la racine. Assure-toi d'avoir cloné le repo à la racine correcte."
}

# Git : créer branche, add, commit, push
Write-Host "Création de la branche locale :" $branch
git fetch origin
git checkout -b $branch

Write-Host "git add..."
git add .

# commit si il y a des changements
$diff = git status --porcelain
if ([string]::IsNullOrWhiteSpace($diff)) {
  Write-Host "Aucun changement à committer. Le script s'arrête."
  exit 0
}

git commit -m "feat(ui): add dashboard, inventory, item detail, shopping list + sample data and provider"
Write-Host "Push sur origin/$branch..."
git push -u origin $branch

# Créer PR via gh
Write-Host "Création de la Pull Request via gh..."
$createArgs = @(
  "pr", "create",
  "--title", $prTitle,
  "--body", $prBody,
  "--base", "main",
  "--head", $branch
)
gh @createArgs

Write-Host "Terminé. La PR a été créée (si gh était connecté)."