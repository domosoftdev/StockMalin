import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/shopping_list_service.dart';
import '../models/shopping_list_item.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _textController = TextEditingController();

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      context.read<ShoppingListService>().addItem(_textController.text);
      _textController.clear();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de courses'),
        elevation: 4.0,
      ),
      body: Column(
        children: [
          _buildInputBar(),
          const Divider(height: 1),
          Expanded(
            child: Consumer<ShoppingListService>(
              builder: (context, service, child) {
                if (service.items.isEmpty) {
                  return const Center(
                    child: Text('Votre liste de courses est vide.'),
                  );
                }
                return ListView.builder(
                  itemCount: service.items.length,
                  itemBuilder: (context, index) {
                    final item = service.items[index];
                    return _buildListItem(item);
                  },
                );
              },
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Ajouter un produit...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (_) => _addItem(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
            tooltip: 'Ajouter',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité de scan à venir !')),
              );
            },
            tooltip: 'Scanner un code-barres',
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(ShoppingListItem item) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Checkbox(
        value: item.isChecked,
        onChanged: (_) {
          context.read<ShoppingListService>().toggleItemChecked(item);
        },
        activeColor: theme.colorScheme.primary,
      ),
      title: Text(
        item.name,
        style: theme.textTheme.bodyText1?.copyWith(
          decoration: item.isChecked ? TextDecoration.lineThrough : null,
          color: item.isChecked ? Colors.grey : theme.textTheme.bodyText1?.color,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
        onPressed: () {
          context.read<ShoppingListService>().removeItem(item);
        },
        tooltip: 'Supprimer',
      ),
    );
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
            ),
            onPressed: () {
              context.read<ShoppingListService>().transferSelectedItems();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produits sélectionnés transférés (simulation).')),
              );
            },
            child: const Text('Transférer la sélection'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              context.read<ShoppingListService>().transferAllItems();
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tous les produits ont été transférés (simulation).')),
              );
            },
            child: const Text('Tout transférer'),
          ),
        ],
      ),
    );
  }
}
