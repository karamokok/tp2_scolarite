import 'modeles.dart';

/// Moyenne pondérée de [etudiant] sur les UE [ues].
///
/// Une UE sans note compte pour 0. Aucun `for` n'est utilisé : le calcul
/// repose sur `fold`.
double moyenne(Etudiant etudiant, List<UE> ues) {
  final totalCoefficients = ues.fold<int>(
    0,
    (total, ue) => total + ue.coefficient,
  );

  if (totalCoefficients == 0) return 0;

  final totalPoints = ues.fold<double>(
    0,
    (total, ue) => total + (etudiant.note(ue.code) ?? 0) * ue.coefficient,
  );

  return totalPoints / totalCoefficients;
}

/// Promotion triée par moyenne décroissante, sans modifier [promo].
List<Etudiant> classement(List<Etudiant> promo, List<UE> ues) =>
    List<Etudiant>.of(promo)
      ..sort((a, b) => moyenne(b, ues).compareTo(moyenne(a, ues)));

/// Moyenne des notes enregistrées pour chaque UE.
///
/// Les étudiants qui n'ont pas de note pour une UE ne sont pas comptés
/// dans la moyenne de cette UE.
Map<String, double> moyenneParUE(List<Etudiant> promo) {
  if (promo.isEmpty) return <String, double>{};

  final codes = promo
      .map((etudiant) => etudiant.notes.keys.toSet())
      .reduce((accumul, cles) => accumul.union(cles));

  return Map<String, double>.fromEntries(
    codes.map((code) {
      final notes = promo
          .map((etudiant) => etudiant.note(code))
          .whereType<double>()
          .toList();

      final moyenneUE = notes.isEmpty
          ? 0.0
          : notes.reduce((a, b) => a + b) / notes.length;

      return MapEntry(code, moyenneUE);
    }),
  );
}

/// Renvoie le minimum et le maximum d'une liste non vide.
(double, double) extremes(List<double> valeurs) {
  if (valeurs.isEmpty) {
    throw ArgumentError('La liste des valeurs ne peut pas être vide.');
  }

  return valeurs.fold<(double, double)>(
    (valeurs.first, valeurs.first),
    (ext, valeur) =>
        (valeur < ext.$1 ? valeur : ext.$1, valeur > ext.$2 ? valeur : ext.$2),
  );
}
