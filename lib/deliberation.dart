import 'modeles.dart';
import 'statistiques.dart';

/// Résultat de délibération d'un étudiant.
///
/// `sealed` ferme la hiérarchie : tous les sous-types sont connus dans cette
/// bibliothèque, ce qui permet à l'analyseur de vérifier l'exhaustivité d'un
/// `switch`.
sealed class Resultat {
  const Resultat();
}

class Admis extends Resultat {
  final String mention;

  const Admis(this.mention);
}

class Rattrapage extends Resultat {
  final List<String> ues;

  const Rattrapage(this.ues);
}

class Ajourne extends Resultat {
  const Ajourne();
}

/// Délibère un étudiant :
/// - admis si la moyenne est supérieure ou égale à 10 ;
/// - rattrapage entre 8 et 10, avec la liste des UE sous 10 ;
/// - ajourné sinon.
Resultat deliberer(Etudiant etudiant, List<UE> ues) {
  final moyenneGenerale = moyenne(etudiant, ues);

  if (moyenneGenerale >= 10) {
    return Admis(_mention(moyenneGenerale));
  }

  if (moyenneGenerale >= 8) {
    final uesEnRattrapage = ues
        .where((ue) => (etudiant.note(ue.code) ?? 0) < 10)
        .map((ue) => ue.code)
        .toList();
    return Rattrapage(uesEnRattrapage);
  }

  return Ajourne();
}

/// Message lisible associé à un résultat, avec une expression `switch`
/// exhaustive.
String message(Resultat resultat) => switch (resultat) {
  Admis(:final mention) => 'Admis avec la mention $mention.',
  Rattrapage(:final ues) when ues.isEmpty => 'Admis en rattrapage.',
  Rattrapage(:final ues) => 'Rattrapage en ${ues.join(', ')}.',
  Ajourne() => 'Ajourné : moyenne insuffisante.',
};

String _mention(double moyenneGenerale) {
  if (moyenneGenerale >= 16) return 'Très bien';
  if (moyenneGenerale >= 14) return 'Bien';
  if (moyenneGenerale >= 12) return 'Assez bien';
  return 'Passable';
}
