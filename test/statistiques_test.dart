import 'package:scolarite/modeles.dart';
import 'package:scolarite/statistiques.dart';
import 'package:test/test.dart';

void main() {
  const ues = [UE('A', 'Algo', 2), UE('B', 'BD', 1)];

  group('moyenne', () {
    test('moyenne pondérée', () {
      final e = Etudiant('21A0001', 'Test', null, {'A': 12, 'B': 15});
      expect(moyenne(e, ues), closeTo(13.0, 0.001));
    });

    test('une UE sans note compte pour 0', () {
      final e = Etudiant('21A0002', 'Test', null, {'A': 12});
      expect(moyenne(e, ues), closeTo(8.0, 0.001));
    });

    test('une liste d’UE vide donne 0', () {
      final e = Etudiant('21A0003', 'Test', null, {'A': 12});
      expect(moyenne(e, const []), 0);
    });
  });

  group('classement', () {
    test('trie par moyenne décroissante sans modifier la promo', () {
      final promo = [
        Etudiant('1', 'Faible', null, {'A': 8, 'B': 9}),
        Etudiant('2', 'Forte', null, {'A': 16, 'B': 18}),
        Etudiant('3', 'Moyenne', null, {'A': 11, 'B': 12}),
      ];

      final classe = classement(promo, ues);

      expect(classe.map((e) => e.nom), ['Forte', 'Moyenne', 'Faible']);
      expect(promo.map((e) => e.nom), ['Faible', 'Forte', 'Moyenne']);
    });
  });

  group('moyenneParUE', () {
    test('calcule la moyenne de chaque UE notée', () {
      final promo = [
        Etudiant('1', 'A', null, {'A': 10, 'B': 12}),
        Etudiant('2', 'B', null, {'A': 14}),
        Etudiant('3', 'C', null, {'A': 18, 'B': 16}),
      ];

      final resultat = moyenneParUE(promo);

      expect(resultat['A'], closeTo(14.0, 0.001));
      expect(resultat['B'], closeTo(14.0, 0.001));
      expect(resultat.keys, unorderedEquals(['A', 'B']));
    });

    test('renvoie une map vide pour une promotion vide', () {
      expect(moyenneParUE(const []), isEmpty);
    });
  });

  group('extremes', () {
    test('renvoie le minimum et le maximum sous forme de record', () {
      expect(extremes([12.5, 8.0, 17.25, 10.0]), (8.0, 17.25));
    });

    test('fonctionne avec une seule valeur', () {
      expect(extremes([5.0]), (5.0, 5.0));
    });

    test('lève une ArgumentError pour une liste vide', () {
      expect(() => extremes(const []), throwsArgumentError);
    });
  });
}
