import 'dart:convert';

import 'modeles.dart';

/// Les six UE de démonstration du semestre.
const List<UE> uesInformatique = [
  UE('INF351', 'Algorithmique avancée', 3),
  UE('INF352', 'Bases de données', 2),
  UE('INF353', 'Réseaux informatiques', 2),
  UE('INF354', 'Programmation mobile', 3),
  UE('MAT351', 'Probabilités et statistiques', 1),
  UE('ANG351', 'Anglais technique', 1),
];

/// Chaîne JSON fournie pour l'exercice (un étudiant sans e-mail).
const String jsonPromo = '''
[
  {
    "matricule": "21A0001",
    "nom": "Johane Elloh",
    "email": "johane.elloh@univ.cm",
    "notes": {"INF351": 7, "INF352": 8, "INF353": 6, "INF354": 9, "MAT351": 5, "ANG351": 10}
  },
  {
    "matricule": "21A0002",
    "nom": "Fofana Falikou",
    "email": "fofana.falikou@univ.cm",
    "notes": {"INF351": 9, "INF352": 10, "INF353": 8, "INF354": 11, "MAT351": 9, "ANG351": 10}
  },
  {
    "matricule": "21A0003",
    "nom": "Komian Christ Josue",
    "email": "komian.christjosue@univ.cm",
    "notes": {"INF351": 17, "INF352": 16, "INF353": 15, "INF354": 18, "MAT351": 14, "ANG351": 16}
  },
  {
    "matricule": "21A0004",
    "nom": "Kande Karamoko",
    "email": null,
    "notes": {"INF351": 15.5, "INF352": 14, "INF353": 12, "INF354": 16, "MAT351": 11, "ANG351": 14}
  },
  {
    "matricule": "21A0005",
    "nom": "Kossonou Emma",
    "email": "kossonou.emma@univ.cm",
    "notes": {"INF351": 11, "INF352": 12.5, "INF354": 13, "MAT351": 8.5, "ANG351": 11}
  }
]
''';

/// Même structure, mais avec un matricule commençant par « X » :
/// sert à déclencher volontairement une [FormatException].
const String jsonPromoInvalide = '''
[
  {
    "matricule": "X21A0099",
    "nom": "Étudiant Invalide",
    "email": null,
    "notes": {"INF351": 10}
  }
]
''';

/// Décode une chaîne JSON contenant une liste d'étudiants.
List<Etudiant> decoderPromo(String source) =>
    (jsonDecode(source) as List<dynamic>)
        .map((element) => Etudiant.fromJson(element as Map<String, dynamic>))
        .toList();

/// Promotion de démonstration, décodée une seule fois.
final List<Etudiant> promoDemo = decoderPromo(jsonPromo);
