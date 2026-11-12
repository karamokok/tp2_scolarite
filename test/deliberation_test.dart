import 'package:scolarite/deliberation.dart';
import 'package:scolarite/modeles.dart';
import 'package:test/test.dart';

void main() {
  const ues = [UE('A', 'Algo', 2), UE('B', 'BD', 1)];

  group('deliberer', () {
    test('admet un étudiant avec une moyenne supérieure ou égale à 10', () {
      final e = Etudiant('1', 'Admis', null, {'A': 12, 'B': 15});
      final resultat = deliberer(e, ues);

      expect(resultat, isA<Admis>());
      expect((resultat as Admis).mention, 'Assez bien');
    });

    test('place en rattrapage entre 8 et 10 avec les UE sous 10', () {
      final e = Etudiant('2', 'Rattrapage', null, {'A': 9, 'B': 8});
      final resultat = deliberer(e, ues);

      expect(resultat, isA<Rattrapage>());
      expect((resultat as Rattrapage).ues, ['A', 'B']);
    });

    test('ajourne en dessous de 8', () {
      final e = Etudiant('3', 'Ajourné', null, {'A': 5, 'B': 6});
      expect(deliberer(e, ues), isA<Ajourne>());
    });

    test('une UE sans note est considérée comme éliminatoire', () {
      final e = Etudiant('4', 'Note manquante', null, {'A': 14});
      final resultat = deliberer(e, ues);

      expect(resultat, isA<Rattrapage>());
      expect((resultat as Rattrapage).ues, ['B']);
    });
  });

  group('message', () {
    test('décrit chaque résultat avec un switch exhaustif', () {
      expect(message(const Admis('Très bien')), contains('Très bien'));
      expect(
        message(const Rattrapage(['INF351', 'MAT351'])),
        contains('INF351, MAT351'),
      );
      expect(message(const Ajourne()), contains('Ajourné'));
    });
  });
}
