import 'package:desktop_entry/src/data/models/desktop_action.dart'
    show DesktopAction;
import 'package:test/test.dart';

void main() {
  group('DesktopAction model', () {
    test('props are correct', () {
      const action = DesktopAction(
        name: 'name_test',
      );
      expect(
        action.props,
        equals(['name_test', null, null, null]),
      );
    });

    test('equality', () {
      expect(
        const DesktopAction(
          name: 'name_test',
        ),
        const DesktopAction(
          name: 'name_test',
        ),
      );
    });

    test('serialize', () {
      const action = DesktopAction(
        name: 'name_test',
      );
      final json = action.toJson();
      final name = json['Name'];

      expect(
        name,
        'name_test',
      );
      json.forEach((key, value) {
        if (key != 'Name') {
          expect(json[key], null);
        }
      });
    });

    test('deserialize', () {
      final json = {
        'Name': 'name_test',
        'Type': 'type_test',
      };
      final action = DesktopAction.fromJson(json);
      expect(
        {
          'Name': 'name_test',
          'LocalizedName': null,
          'Icon': null,
          'Exec': null,
        },
        action.toJson(),
      );
      expect(
        action.name,
        'name_test',
      );
    });

    test('copyWith', () {
      const action = DesktopAction(name: 'name_test');
      final copied = action.copyWith(icon: 'icon_test');
      expect(copied.name, 'name_test');
      expect(copied.icon, 'icon_test');
      expect(copied.exec, null);
    });
  });
}
