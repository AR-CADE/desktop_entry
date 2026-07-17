import 'package:desktop_entry/src/data/models/application_desktop_entry.dart'
    show ApplicationDesktopEntry;
import 'package:test/test.dart';

void main() {
  group('ApplicationDesktopEntry model', () {
    test('props are correct', () {
      const application = ApplicationDesktopEntry(
        name: 'name_test',
        type: 'type_test',
      );
      expect(
        application.props,
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
          null,
          null,
        ]),
      );
    });

    test('equality', () {
      expect(
        const ApplicationDesktopEntry(
          name: 'name_test',
          type: 'type_test',
        ),
        const ApplicationDesktopEntry(
          name: 'name_test',
          type: 'type_test',
        ),
      );
    });

    test('serialize', () {
      const application = ApplicationDesktopEntry(
        name: 'name_test',
        type: 'type_test',
      );
      final json = application.toJson();
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
      final application = ApplicationDesktopEntry.fromJson(json);
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
          'TryExec': null,
          'Exec': null,
          'Path': null,
          'Terminal': null,
          'Actions': null,
          'MimeType': null,
          'Categories': null,
          'Keywords': null,
          'LocalizedKeywords': null,
          'StartupNotify': null,
          'StartupWMClass': null,
          'PrefersNonDefaultGPU': null,
          'SingleMainWindow': null,
          'DesktopNames': null,
          'DesktopActions': null,
        },
        application.toJson(),
      );
      expect(
        application.name,
        'name_test',
      );
      expect(
        application.type,
        'type_test',
      );
    });

    test('copyWith', () {
      const application = ApplicationDesktopEntry(
        name: 'name_test',
        type: 'type_test',
      );
      final copied = application.copyWith(name: 'name_test2');
      expect(copied.name, 'name_test2');
      expect(copied.type, 'type_test');
      expect(copied.icon, null);

      final copied2 = copied.copyWith(type: 'type_test2');
      expect(copied2.name, 'name_test2');
      expect(copied2.type, 'type_test2');
      expect(copied2.icon, null);

      final copied3 = application.copyWith();
      expect(copied3.name, 'name_test');
      expect(copied3.type, 'type_test');
      expect(copied3.icon, null);

      expect(
        application.copyWith(),
        application,
      );
    });
  });
}
