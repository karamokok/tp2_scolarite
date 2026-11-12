import 'donnees.dart';
import 'modeles.dart';

/// Simule le chargement distant de la promotion (2 s par défaut).
///
/// Lève une [FormatException] si un matricule commence par « X ».
Future<List<Etudiant>> chargerPromo({
  String source = jsonPromo,
  Duration delai = const Duration(seconds: 2),
}) async {
  await Future<void>.delayed(delai);

  final promo = decoderPromo(source);
  final invalides = promo.where((e) => e.matricule.startsWith('X'));

  if (invalides.isNotEmpty) {
    throw FormatException('Matricule invalide : ${invalides.first.matricule}');
  }

  return promo;
}

/// Simule le chargement distant d'une UE (500 ms par défaut).
Future<UE> chargerUE(
  String code, {
  Duration delai = const Duration(milliseconds: 500),
}) async {
  await Future<void>.delayed(delai);

  final correspondances = uesInformatique.where((ue) => ue.code == code);
  if (correspondances.isEmpty) {
    throw ArgumentError.value(code, 'code', 'Code UE inconnu');
  }

  return correspondances.first;
}

/// Charge plusieurs UE en parallèle avec [Future.wait] et mesure la durée.
Future<({List<UE> ues, Duration duree})> chargerUEEnParallele(
  List<String> codes, {
  Duration delai = const Duration(milliseconds: 500),
}) async {
  final chrono = Stopwatch()..start();
  final ues = await Future.wait(
    codes.map((code) => chargerUE(code, delai: delai)),
  );
  chrono.stop();

  return (ues: ues, duree: chrono.elapsed);
}

/// Simule un journal de calcul : un message par seconde.
Stream<String> journal({
  List<Etudiant>? promo,
  Duration intervalle = const Duration(seconds: 1),
}) async* {
  final etudiants = promo ?? promoDemo;

  for (final etudiant in etudiants) {
    await Future<void>.delayed(intervalle);
    yield 'Calcul de la moyenne de ${etudiant.nom}…';
  }
}
