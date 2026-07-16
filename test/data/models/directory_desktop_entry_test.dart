import 'package:desktop_entry/src/data/models/directory_desktop_entry.dart'
    show DirectoryDesktopEntry;
import 'package:test/test.dart';

void main() {
  group('DirectoryDesktopEntry model', () {
    test('props are correct', () {
      const directory = DirectoryDesktopEntry(
        name: 'name_test',
        type: 'type_test',
      );
      expect(
        directory.props,
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
          null,
          null,
          null,
        ]),
      );
    });

    test('equality', () {
      expect(
        const DirectoryDesktopEntry(
          name: 'name_test',
          type: 'type_test',
        ),
        const DirectoryDesktopEntry(
          name: 'name_test',
          type: 'type_test',
        ),
      );
    });

    test('serialize', () {
      const link = DirectoryDesktopEntry(
        name: 'name_test',
        type: 'type_test',
      );
      final json = link.toJson();
      final name = json['Name'];
      final type = json['Type'];

      expect(
        name,
        'name_test',
      );

      expect(
        type,
        'type_test',
      );

      json.forEach((key, value) {
        if (key != 'Name' && key != 'Type') {
          expect(json[key], null);
        }
      });
    });

    test('deserialize', () {
      final json = {
        'Name': 'name_test',
        'Type': 'type_test',
      };
      final link = DirectoryDesktopEntry.fromJson(json);
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
    });

    test('copyWith', () {
      const directory = DirectoryDesktopEntry(
        name: 'name_test',
        type: 'type_test',
      );
      final copied = directory.copyWith(name: 'name_test2');
      expect(copied.name, 'name_test2');
      expect(copied.type, 'type_test');
      expect(copied.icon, null);
    });
  });
}
