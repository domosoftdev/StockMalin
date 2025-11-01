# update_pr.ps1
# Exécuter depuis la racine du repo StockMalin
$ErrorActionPreference = "Stop"

# Backup
$backup = "$env:USERPROFILE\Desktop\StockMalin-update-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').zip"
Write-Host "Création d'une sauvegarde ZIP sur le Bureau :" $backup
Compress-Archive -Path . -DestinationPath $backup -Force

# 1) Corriger lib/providers/product_provider.dart (écrase avec implémentation sûre)
$provPath = "lib/providers/product_provider.dart"
if (Test-Path $provPath) {
  Write-Host "Mise à jour de $provPath"
  $provContent = @'
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

  Product? findById(String id) {
    for (final p in _items) {
      if (p.id == id) return p;
    }
    return null;
  }

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
  $provContent | Set-Content -Path $provPath -Encoding UTF8
} else {
  Write-Host "Fichier introuvable : $provPath" -ForegroundColor Yellow
}

# 2) Corriger test/widget_test.dart : utiliser imports relatifs
$testPath = "test/widget_test.dart"
if (Test-Path $testPath) {
  Write-Host "Mise à jour de $testPath"
  $testContent = @'
import "package:flutter_test/flutter_test.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../lib/providers/product_provider.dart";
import "../lib/pages/dashboard_page.dart";

void main() {
  testWidgets("Dashboard loads and shows title", (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => ProductProvider()..loadSample(), child: MaterialApp(home: DashboardPage())),
    );
    await tester.pumpAndSettle();
    expect(find.text("Martin Family"), findsOneWidget);
    expect(find.text("Use soon"), findsOneWidget);
  });
}
'@
  $testContent | Set-Content -Path $testPath -Encoding UTF8
} else {
  Write-Host "test/widget_test.dart introuvable" -ForegroundColor Yellow
}

# 3) Ajouter ignore pour deprecated Radio dans lib/pages/shopping_list_page.dart
$shoppingPath = "lib/pages/shopping_list_page.dart"
if (Test-Path $shoppingPath) {
  Write-Host "Ajout d'un ignore de dépréciation dans $shoppingPath (si nécessaire)..."
  $lines = Get-Content $shoppingPath
  $out = @()
  for ($i=0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match '^\s*leading:\s*Radio\(') {
      # si la ligne précédente n'est pas déjà un ignore, insérer l'ignore
      $prev = if ($out.Count -gt 0) { $out[$out.Count-1] } else { "" }
      if ($prev -notmatch 'deprecated_member_use') {
        $out += '            // ignore: deprecated_member_use'
      }
    }
    $out += $line
  }
  $out | Set-Content -Path $shoppingPath -Encoding UTF8
} else {
  Write-Host "$shoppingPath introuvable" -ForegroundColor Yellow
}

# 4) Run dart fix --apply to add const where reasonable
Write-Host "Exécution de dart fix --apply (peut modifier des fichiers)..."
try {
  dart fix --apply
} catch {
  Write-Host "dart fix a échoué ou n'est pas disponible. Essayez 'dart --version' ou exécutez dart fix manuellement." -ForegroundColor Yellow
}

# 5) git add/commit/push
Write-Host "Staging changes..."
git add -A

$diff = git status --porcelain
if ([string]::IsNullOrWhiteSpace($diff)) {
  Write-Host "Aucun changement à committer."
  exit 0
}

$commitMsg = "fix: provider findById, test imports, ignore Radio deprecations, apply dart fix"
git commit -m $commitMsg
Write-Host "Push vers la branche actuelle..."
git push

Write-Host "Terminé. Les modifications ont été poussées. La PR existante sera mise à jour automatiquement."