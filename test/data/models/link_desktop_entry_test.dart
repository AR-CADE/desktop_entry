import 'package:desktop_entry/src/data/models/link_desktop_entry.dart'
    show LinkDesktopEntry;
import 'package:test/test.dart';

void main() {
  group('LinkDesktopEntry model', () {
    test('props are correct', () {
      const link = LinkDesktopEntry(
        name: 'name_test',
        type: 'type_test',
        url: 'url_test',
      );
      expect(
        link.props,
        equals([
          'name_test',
          'type_test',
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          'url_test',
          null,
          null,
          null,
        ]),
      );
    });

    test('equality', () {
      expect(
        const LinkDesktopEntry(
          name: 'name_test',
          type: 'type_test',
          url: 'url_test',
        ),
        const LinkDesktopEntry(
          name: 'name_test',
          type: 'type_test',
          url: 'url_test',
        ),
      );
    });

    test('serialize', () {
      const link = LinkDesktopEntry(
        name: 'name_test',
        type: 'type_test',
        url: 'url_test',
      );
      final json = link.toJson();
      final name = json['Name'];
      final type = json['Type'];
      final url = json['Url'];

      expect(
        name,
        'name_test',
      );
      expect(
        url,
        'url_test',
      );
      expect(
        type,
        'type_test',
      );

      json.forEach((key, value) {
        if (key != 'Name' && key != 'Type' && key != 'Url') {
          expect(json[key], null);
        }
      });
    });

    test('deserialize', () {
      final json = {
        'Name': 'name_test',
        'Type': 'type_test',
        'Url': 'url_test',
      };
      final link = LinkDesktopEntry.fromJson(json);
      expect(
        {
          'Type': 'type_test',
          'Version': null,
          'Name': 'name_test',
          'LocalizedName': null,
          'GenericName': null,
          'LocalizedGenericName': null,
          'NoDisplay': null,
          'Comment': null,
          'LocalizedComment': null,
          'Icon': null,
          'Hidden': null,
          'OnlyShowIn': null,
          'NotShowIn': null,
          'DBusActivatable': null,
          'Implements': null,
          'Url': 'url_test',
        },
        link.toJson(),
      );
      expect(
        link.name,
        'name_test',
      );
      expect(
        link.type,
        'type_test',
      );
      expect(
        link.url,
        'url_test',
      );
    });

    test('copyWith', () {
      const link = LinkDesktopEntry(
        name: 'name_test',
        type: 'type_test',
        url: 'url_test',
      );
      final copied = link.copyWith(name: 'name_test2');
      expect(copied.name, 'name_test2');
      expect(copied.type, 'type_test');
      expect(copied.url, 'url_test');
    });
  });
}
