# scolarite – TP 2 « Dart en pratique »

Application console Dart réalisée dans le cadre du TP 2 de programmation
mobile Android avec Flutter (Licence 3 Informatique).

## Contenu

- modèles `UE` et `Etudiant` avec `fromJson`, null safety, `contact` et
  `note()` ;
- statistiques fonctionnelles : moyenne pondérée, classement, moyenne par UE,
  extrêmes (record) ;
- classes scellées `Resultat` et délibération avec `switch` exhaustif ;
- simulation asynchrone (`Future`, `Future.wait`, `Stream`, `FormatException`) ;
- 25 tests unitaires.

## Lancer le projet

```bash
dart pub get
dart run
dart test
dart analyze
```

## Structure

```
lib/modeles.dart        # UE, Etudiant
lib/donnees.dart        # UE et promotion de démonstration (JSON)
lib/statistiques.dart   # moyenne, classement, moyenneParUE, extremes
lib/deliberation.dart   # Resultat, deliberer, message
lib/service.dart        # chargerPromo, chargerUE, journal
bin/scolarite.dart      # démonstration des cinq étapes
test/                   # tests unitaires
```

Le compte rendu (réponses aux questions [Q1] à [Q3], mesures et difficultés)
se trouve dans [COMPTE_RENDU.md](COMPTE_RENDU.md).
