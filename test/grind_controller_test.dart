import 'package:flutter_test/flutter_test.dart';
import 'package:grindos/utils/rank_utils.dart';

void main() {
  test('rank progression mapping', () {
    expect(rankForLevel(1), 'Bronze');
    expect(rankForLevel(4), 'Silver');
    expect(rankForLevel(7), 'Gold');
    expect(rankForLevel(12), 'Diamond');
    expect(rankForLevel(20), 'Mythic');
  });
}
