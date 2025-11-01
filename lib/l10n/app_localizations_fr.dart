import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get inventory => 'Inventaire';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get scan => 'Scanner';

  @override
  String get settings => 'Paramètres';

  @override
  String get martinFamily => 'Famille Martin';

  @override
  String get perishableItems => 'Articles périssables';

  @override
  String get lowStock => 'Stock faible';

  @override
  String get useSoon => 'À utiliser bientôt';
}
