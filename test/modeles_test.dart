import 'package:scolarite/modeles.dart';
import 'package:test/test.dart';

void main() {
  group('UE.fromJson', () {
    test('construit une UE depuis un objet JSON', () {
      final ue = UE.fromJson(const {
        'code': 'INF351',
        'intitule': 'Algorithmique avancée',
        'coefficient': 3,
      });

      expect(ue.code, 'INF351');
      expect(ue.intitule, 'Algorithmique avancée');
      expect(ue.coefficient, 3);
    });
  });

  group('Etudiant', () {
    test('fromJson convertit les notes numériques en double', () {
      final etudiant = Etudiant.fromJson(const {
        'matricule': '21A0001',
        'nom': 'Johane Elloh',
        'email': 'johane.elloh@univ.cm',
        'notes': {'INF351': 14, 'INF352': 15.5},
      });

      expect(etudiant.notes['INF351'], isA<double>());
      expect(etudiant.notes['INF351'], 14.0);
      expect(etudiant.notes['INF352'], 15.5);
    });

    test('contact renvoie l’e-mail quand il existe', () {
      final etudiant = Etudiant('21A0001', 'Johane', 'johane@univ.cm', const {});
      expect(etudiant.contact, 'johane@univ.cm');
    });

    test('contact renvoie « non renseigné » sans e-mail', () {
      final etudiant = Etudiant('21A0002', 'Fofana', null, const {});
      expect(etudiant.contact, 'non renseigné');
    });

    test('note renvoie null pour une UE absente', () {
      final etudiant = Etudiant('21A0003', 'Komian', null, const {'INF351': 12});
      expect(etudiant.note('INF351'), 12.0);
      expect(etudiant.note('INF999'), isNull);
    });
  });
}
