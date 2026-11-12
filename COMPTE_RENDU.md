# Compte rendu – TP 2 : Dart en pratique

**Binôme :** _(à compléter : nom 1, nom 2)_
**Dépôt :** _(à compléter : URL du dépôt Git)_
**Environnement :** Dart 3.13.7 (stable), Windows 11, `dart run` / `dart test`

## Mise en place

```bash
dart create -t console scolarite
cd scolarite
dart run
```

Le projet a été complété dans le dossier `scolarite` fourni. L'application
console exécute successivement les cinq étapes du TP.

## Structure des fichiers

```
lib/
├── scolarite.dart      # bibliothèque qui exporte les autres fichiers
├── modeles.dart        # UE, Etudiant, fromJson, contact, note()
├── donnees.dart        # UE de démo, chaîne JSON, décodage
├── statistiques.dart   # moyenne, classement, moyenneParUE, extremes
├── deliberation.dart   # Resultat scellé, deliberer(), message()
└── service.dart        # chargerPromo, chargerUE, Future.wait, journal
bin/
└── scolarite.dart      # programme principal (démonstration des 5 étapes)
test/
├── modeles_test.dart
├── statistiques_test.dart
├── deliberation_test.dart
└── service_test.dart
```

## Étape 1 – Modèles et null safety

- `UE.fromJson` reconstruit une UE à partir de `code`, `intitule` et
  `coefficient`.
- `Etudiant.fromJson` convertit chaque note en `double` avec
  `(valeur as num).toDouble()` : le JSON peut contenir `14` (entier) ou
  `14.5` (décimale).
- `contact` renvoie l'e-mail ou `non renseigné` grâce à `??`.
- `note(String codeUE)` renvoie `double?` : l'absence de note est représentée
  par `null`.
- `bin/scolarite.dart` décode la chaîne JSON avec `dart:convert` et affiche
  chaque étudiant.

### [Q1] Pourquoi `note()` renvoie-t-elle `double?` et pas `double` ?

Parce qu'un étudiant peut ne pas avoir de note pour une UE : la map `notes`
ne contient alors aucune entrée pour ce code. Le type `double?` exprime
explicitement cette absence. Si la méthode renvoyait `double`, il faudrait
inventer une valeur sentinelle (0 par exemple), ce qui confondrait « pas de
note » et « note égale à 0 ». Avec `double?`, l'appelant choisit consciemment
le comportement : `?? 0` dans le calcul de moyenne, ou `!` lorsqu'il est sûr
que la note existe.

`note('X')! + 1` pour une UE absente lève une erreur à l'exécution :
`Null check operator used on a null value` (l'opérateur `!` affirme à tort
que la valeur n'est pas nulle). Le programme s'arrête si l'erreur n'est pas
interceptée.

## Étape 2 – Collections et statistiques

Aucune boucle `for` n'est utilisée dans `statistiques.dart` : les calculs
reposent sur `map`, `where`, `fold`, `reduce`, `sort` et `Set.union`.

- `moyenne` : somme des `note × coefficient`, divisée par la somme des
  coefficients ; une UE sans note vaut 0.
- `classement` : copie de la promo triée par moyenne décroissante (la liste
  d'origine n'est pas modifiée).
- `moyenneParUE` : moyenne des notes réellement enregistrées pour chaque UE
  (un étudiant sans note pour cette UE n'est pas compté).
- `extremes` : record `(min, max)` calculé avec `fold`.

Extrait de sortie :

```text
Classement :
1. Komian Christ Josue  16.42
2. Kande Karamoko       14.29
3. Kossonou Emma         9.71
4. Fofana Falikou        9.58
5. Johane Elloh          7.58
```

## Étape 3 – Classes scellées et switch

`Resultat` est une classe `sealed` avec trois sous-types : `Admis`,
`Rattrapage` et `Ajourne`. `deliberer` applique les seuils demandés et
`message` utilise une expression `switch` exhaustive avec déstructuration
(`Admis(:final mention)`, `Rattrapage(:final ues)`).

### [Q2] Suppression du cas `Ajourne()` dans le switch

L'analyseur signale une erreur de compilation, du type :

```text
The type 'Resultat' is not exhaustively matched by the switch cases since it
doesn't match 'Ajourne()'. Try adding a default case or cases that match
'Ajourne()'.
```

`sealed` présente deux intérêts :

1. **Exhaustivité vérifiée** : le compilateur connaît tous les sous-types
   directs (ils doivent être déclarés dans la même bibliothèque) et refuse un
   `switch` incomplet. Ajouter un nouveau résultat obligera à traiter tous les
   switches existants.
2. **Hiérarchie fermée** : aucune classe extérieure ne peut étendre
   `Resultat`, ce qui garantit que l'ensemble des cas reste celui prévu.

## Étape 4 – Asynchronisme

- `chargerPromo()` attend 2 s puis décode la promo ; une `FormatException` est
  levée si un matricule commence par `X`.
- `chargerUE(code)` attend 500 ms.
- `chargerUEEnParallele` lance les cinq chargements avec `Future.wait` et
  mesure la durée avec un `Stopwatch`.
- `journal()` est un `Stream<String>` asynchrone (`async*`) qui émet un
  message par seconde ; il est consommé avec `await for`.
- L'erreur du matricule `X21A0099` est interceptée dans `main` avec
  `on FormatException catch`.

Durées mesurées sur la machine :

```text
5 étudiants chargés en 2021 ms (2 s simulées).
5 UE chargées en parallèle en 513 ms (5 × 500 ms en séquentiel = 2500 ms).
FormatException interceptée : Matricule invalide : X21A0099
```

### [Q3] Durée mesurée à l'étape 4.2

Environ **500 ms** (513 ms mesurés, soit 500 ms d'attente + le temps de
création des objets). Les cinq `Future` démarrent en même temps : la durée
totale est celle du plus long, pas leur somme.

Avec cinq `await` successifs, il faudrait environ **2500 ms** (5 × 500 ms),
car chaque `await` bloque la suite de la fonction avant de lancer le
chargement suivant. C'est précisément l'intérêt de `Future.wait` pour des
traitements indépendants.

## Étape 5 – Tests unitaires

```bash
dart test
```

**25 tests** couvrent les modèles, la moyenne pondérée, l'UE manquante, le
classement, les moyennes par UE, les extrêmes, les trois résultats de
délibération, les messages, le chargement asynchrone, l'erreur de matricule,
le chargement parallèle et le stream.

```text
00:00 +25: All tests passed!
```

## Vérifications

```bash
dart analyze   # No issues found!
dart test      # 25 tests, All tests passed!
dart run       # exécute les cinq étapes
```

## Difficultés rencontrées

- **Encodage de la console Windows** : les accents s'affichaient mal avec le
  code page par défaut ; la commande `chcp 65001` (ou la configuration UTF-8
  du terminal) règle le problème. Le code source, lui, est bien en UTF-8.
- **Notes entières ou décimales dans le JSON** : `jsonDecode` produit des
  `int` pour `14` et des `double` pour `14.5`. La conversion
  `(valeur as num).toDouble()` uniformise les deux cas.
- **Moyenne des UE sans note** : il a fallu choisir entre compter 0 et ignorer
  l'étudiant. Pour `moyenneParUE`, l'étudiant sans note est ignoré (on moyenne
  les notes existantes) ; pour la moyenne individuelle, l'UE vaut 0 comme
  demandé dans le sujet.

## Captures d'écran

_(à insérer : sortie de `dart run`, résultat de `dart test`, résultat de
`dart analyze`)_
