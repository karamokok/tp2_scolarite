import 'package:scolarite/donnees.dart';
import 'package:scolarite/service.dart';
import 'package:test/test.dart';

void main() {
  group('chargerPromo', () {
    test('renvoie les étudiants après le délai simulé', () async {
      final chrono = Stopwatch()..start();
      final promo = await chargerPromo(
        delai: const Duration(milliseconds: 100),
      );
      chrono.stop();

      expect(promo, hasLength(5));
      expect(promo.first.nom, 'Johane Elloh');
      expect(chrono.elapsedMilliseconds, greaterThanOrEqualTo(90));
    });

    test(
      'lève une FormatException pour un matricule commençant par X',
      () async {
        expect(
          chargerPromo(source: jsonPromoInvalide, delai: Duration.zero),
          throwsFormatException,
        );
      },
    );
  });

  group('chargerUE', () {
    test('renvoie l’UE demandée', () async {
      final ue = await chargerUE('INF351', delai: Duration.zero);
      expect(ue.code, 'INF351');
      expect(ue.intitule, 'Algorithmique avancée');
    });

    test('lève une ArgumentError pour un code inconnu', () async {
      expect(chargerUE('INF999', delai: Duration.zero), throwsArgumentError);
    });
  });

  group('chargerUEEnParallele', () {
    test('charge cinq UE en parallèle, pas en séquence', () async {
      final resultat = await chargerUEEnParallele([
        'INF351',
        'INF352',
        'INF353',
        'INF354',
        'MAT351',
      ], delai: const Duration(milliseconds: 100));

      expect(resultat.ues, hasLength(5));
      // En séquentiel : 5 × 100 = 500 ms. En parallèle : environ 100 ms.
      expect(resultat.duree.inMilliseconds, lessThan(400));
    });
  });

  group('journal', () {
    test('émet un message par étudiant', () async {
      final messages = await journal(
        promo: promoDemo.take(3).toList(),
        intervalle: const Duration(milliseconds: 10),
      ).toList();

      expect(messages, hasLength(3));
      expect(messages.first, startsWith('Calcul de la moyenne de'));
      expect(messages.last, contains(promoDemo[2].nom));
    });
  });
}
