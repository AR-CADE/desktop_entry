import 'package:desktop_entry/src/data/models/application_desktop_entry.dart';
import 'package:desktop_entry/src/data/models/desktop_entry.dart';
import 'package:desktop_entry/src/data/models/directory_desktop_entry.dart';
import 'package:desktop_entry/src/data/models/link_desktop_entry.dart';
import 'package:test/test.dart';

void main() {
  group('DesktopEntry', () {
    test('fromJson returns ApplicationDesktopEntry for Type=Application', () {
      final entry = DesktopEntry.fromJson(const {
        'Type': 'Application',
        'Name': 'TestApp',
      });
      expect(entry, isA<ApplicationDesktopEntry>());
    });

    test('fromJson returns DirectoryDesktopEntry for Type=Directory', () {
      final entry = DesktopEntry.fromJson(const {
        'Type': 'Directory',
        'Name': 'TestDir',
      });
      expect(entry, isA<DirectoryDesktopEntry>());
    });

    test('fromJson returns LinkDesktopEntry for Type=Link', () {
      final entry = DesktopEntry.fromJson(const {
        'Type': 'Link',
        'Name': 'TestLink',
        'Url': 'http://test',
      });
      expect(entry, isA<LinkDesktopEntry>());
    });

    test('fromJson throws FormatException for unknown type', () {
      expect(
        () => DesktopEntry.fromJson(const {
          'Type': 'Unknown',
          'Name': 'Test',
        }),
        throwsFormatException,
      );
    });

    test('fromJson throws FormatException for missing type', () {
      expect(
        () => DesktopEntry.fromJson(const {
          'Name': 'Test',
        }),
        throwsFormatException,
      );
    });

    test('props includes all fields', () {
      const dummy = DummyDesktopEntry();
      expect(dummy.props, [
        'Dummy',
        'DummyType',
        'C',
        true,
        'G',
        false,
        'I',
        const ['A'],
        false,
        'N',
        'O',
        '1.0',
        const {'en': 'C'},
        const {'en': 'G'},
        const {'en': 'N'},
      ]);
    });
  });
}

class DummyDesktopEntry extends DesktopEntry {
  const DummyDesktopEntry()
    : super(
        name: 'Dummy',
        type: 'DummyType',
        comment: 'C',
        dBusActivatable: true,
        genericName: 'G',
        hidden: false,
        icon: 'I',
        implements: const ['A'],
        noDisplay: false,
        notShowIn: 'N',
        onlyShowIn: 'O',
        version: '1.0',
        localizedComment: const {'en': 'C'},
        localizedGenericName: const {'en': 'G'},
        localizedName: const {'en': 'N'},
      );

  @override
  Map<String, dynamic> toJson() => {};
}
