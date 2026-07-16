import 'package:desktop_entry/src/core/helper.dart';
import 'package:test/test.dart';

void main() {
  group('Helper', () {
    test('listToArray', () {
      expect(listToArray(null), isNull);
      expect(listToArray(['a', 'b', 'c']), equals('a;b;c'));
    });

    test('listFromArray', () {
      expect(listFromArray(null), isNull);
      expect(listFromArray('a;b;c'), equals(['a', 'b', 'c']));
      expect(listFromArray('a;b;c;'), equals(['a', 'b', 'c']));
    });

    test('encodeLocalizedKeywords', () {
      expect(encodeLocalizedKeywords(null), isNull);
      final encoded = encodeLocalizedKeywords({
        'en': ['a', 'b'],
        'fr': ['c', 'd'],
      });
      expect(encoded, equals({'en': 'a;b', 'fr': 'c;d'}));
    });

    test('decodeLocalizedKeywords', () {
      expect(decodeLocalizedKeywords(null), isNull);
      final decoded = decodeLocalizedKeywords({
        'en': 'a;b',
        'fr': 'c;d',
        'ru': 'e;f;',
      });
      expect(
        decoded,
        equals({
          'en': ['a', 'b'],
          'fr': ['c', 'd'],
          'ru': ['e', 'f'],
        }),
      );
    });

    test('boolFromJson', () {
      expect(boolFromJson(null), isNull);
      expect(boolFromJson('true'), isTrue);
      expect(boolFromJson('false'), isFalse);
      expect(
        boolFromJson('invalid'),
        isNull,
      ); // tryParse returns null for invalid
    });

    test('typeFromJson', () {
      expect(typeFromJson('Application'), equals('Application'));
      expect(typeFromJson(null), isNull);
    });
  });
}
