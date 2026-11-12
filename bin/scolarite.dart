import 'package:scolarite/scolarite.dart';

Future<void> main() async {
  print('=== TP 2 – Dart en pratique : application scolarité ===\n');

  // ---------------------------------------------------------------------------
  // Étape 1 : modèles et null safety
  // ---------------------------------------------------------------------------
  print('--- 1. Modèles et null safety ---');
  final promo = decoderPromo(jsonPromo);

  for (final etudiant in promo) {
    final notes = etudiant.notes.entries
        .map((entree) => '${entree.key} : ${entree.value}')
        .join(', ');
    print('${etudiant.matricule} | ${etudiant.nom} | ${etudiant.contact}');
    print('  notes : ${notes.isEmpty ? 'aucune' : notes}');
  }

  final premier = promo.first;
  print(
    '\nMoyenne de ${premier.nom} : '
    '${moyenne(premier, uesInformatique).toStringAsFixed(2)}',
  );
  print('note("UE_INCONNUE") -> ${premier.note('UE_INCONNUE')} (null attendu)');
  print('contact sans e-mail -> ${promo[3].contact}');

  // ---------------------------------------------------------------------------
  // Étape 2 : collections et statistiques
  // ---------------------------------------------------------------------------
  print('\n--- 2. Collections et statistiques ---');
  print('Classement :');
  final classe = classement(promo, uesInformatique);
  for (var i = 0; i < classe.length; i++) {
    final etudiant = classe[i];
    final moyenneEtudiant = moyenne(etudiant, uesInformatique);
    print(
      '${i + 1}. ${etudiant.nom.padRight(20)} '
      '${moyenneEtudiant.toStringAsFixed(2)}',
    );
  }

  print('\nMoyenne par UE :');
  final moyennesUE = moyenneParUE(promo);
  for (final ue in uesInformatique) {
    final valeur = moyennesUE[ue.code] ?? 0;
    print(
      '${ue.code} – ${ue.intitule.padRight(30)} '
      '${valeur.toStringAsFixed(2)}',
    );
  }

  final moyennes = promo
      .map((etudiant) => moyenne(etudiant, uesInformatique))
      .toList();
  final (minimum, maximum) = extremes(moyennes);
  print(
    '\nExtrêmes des moyennes : '
    'min = ${minimum.toStringAsFixed(2)}, '
    'max = ${maximum.toStringAsFixed(2)}',
  );

  // ---------------------------------------------------------------------------
  // Étape 3 : classes scellées et switch
  // ---------------------------------------------------------------------------
  print('\n--- 3. Délibération ---');
  for (final etudiant in promo) {
    final resultat = deliberer(etudiant, uesInformatique);
    print('${etudiant.nom.padRight(20)} ${message(resultat)}');
  }

  // ---------------------------------------------------------------------------
  // Étape 4 : asynchronisme
  // ---------------------------------------------------------------------------
  print('\n--- 4. Asynchronisme ---');
  final chronoPromo = Stopwatch()..start();
  final promoDistante = await chargerPromo();
  chronoPromo.stop();
  print(
    '${promoDistante.length} étudiants chargés en '
    '${chronoPromo.elapsedMilliseconds} ms (2 s simulées).',
  );

  final chargement = await chargerUEEnParallele([
    'INF351',
    'INF352',
    'INF353',
    'INF354',
    'MAT351',
  ]);
  print(
    '${chargement.ues.length} UE chargées en parallèle en '
    '${chargement.duree.inMilliseconds} ms '
    '(5 × 500 ms en séquentiel = 2500 ms).',
  );

  print('\nJournal (3 premiers étudiants) :');
  final apercu = promoDistante.take(3).toList();
  await for (final ligne in journal(promo: apercu)) {
    print('  $ligne');
  }

  try {
    await chargerPromo(source: jsonPromoInvalide);
    print('Erreur : la FormatException aurait dû être levée.');
  } on FormatException catch (erreur) {
    print('FormatException interceptée : ${erreur.message}');
  }

  print('\n=== Fin du TP 2 ===');
}
