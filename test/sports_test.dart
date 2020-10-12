import 'package:SportsGuide/change_notifiers/sports_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sports notifier', () {
    SportsNotifier uut;

    setUp(() {
      uut = SportsNotifier();
    });

    test('should not add two identical items', () {
      final sport = 'Sport';
      final sport2 = 'sport';
      final sport3 = 'sport ';

      uut.addSport(sport);
      uut.addSport(sport);
      uut.addSport(sport2);
      uut.addSport(sport3);

      expect(uut.sports.length, 1);
    });

    test('should remove sport', () {
      final sport = 'sport';
      uut.addSport(sport);

      uut.removeSport(sport);

      expect(uut.sports.isEmpty, true);
    });

    test('should not remove sport', () {
      final sport = 'sport';
      uut.addSport(sport);

      uut.removeSport('someothersport');

      expect(uut.sports.length, 1);
    });
  });
}
