/// Modèles métier du TP 2 : UE et étudiant.
///
/// La null safety est utilisée pour représenter les données facultatives :
/// l'e-mail d'un étudiant et la note d'une UE peuvent être absents.
class UE {
  final String code;
  final String intitule;
  final int coefficient;

  const UE(this.code, this.intitule, this.coefficient);

  factory UE.fromJson(Map<String, dynamic> j) => UE(
    j['code'] as String,
    j['intitule'] as String,
    (j['coefficient'] as num).toInt(),
  );

  @override
  String toString() => '$code – $intitule (coef. $coefficient)';
}

class Etudiant {
  final String matricule;
  final String nom;
  final String? email; // facultatif
  final Map<String, double> notes;

  const Etudiant(this.matricule, this.nom, this.email, this.notes);

  factory Etudiant.fromJson(Map<String, dynamic> j) {
    final notesJson =
        j['notes'] as Map<String, dynamic>? ?? const <String, dynamic>{};

    return Etudiant(
      j['matricule'] as String,
      j['nom'] as String,
      j['email'] as String?,
      notesJson.map(
        (code, valeur) => MapEntry(code, (valeur as num).toDouble()),
      ),
    );
  }

  /// E-mail de l'étudiant, ou « non renseigné » s'il est absent.
  String get contact => email ?? 'non renseigné';

  /// Note de l'UE [codeUE], ou `null` si l'étudiant n'a pas de note.
  double? note(String codeUE) => notes[codeUE];

  @override
  String toString() => '$matricule – $nom ($contact)';
}
