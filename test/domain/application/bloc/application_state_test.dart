import 'package:desktop_entry/src/data/models/application_desktop_entry.dart';
import 'package:desktop_entry/src/domain/application/bloc/application_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('ApplicationState', () {
    group('ApplicationState.initial', () {
      test('supports value comparisons', () {
        expect(
          ApplicationState.initial(),
          equals(ApplicationState.initial()),
        );
      });

      test('props are correct', () {
        expect(
          ApplicationState.initial().props,
          equals([ApplicationStatus.initial, null, null]),
        );
      });
    });

    test('copyWith works', () {
      final initial = ApplicationState.initial();
      final copied = initial.copyWith(
        status: ApplicationStatus.loading,
        message: 'test',
      );
      expect(copied.status, equals(ApplicationStatus.loading));
      expect(copied.message, equals('test'));
      expect(copied.applications, isNull);

      final copied2 = copied.copyWith();
      expect(copied2.status, equals(ApplicationStatus.loading));
      expect(copied2.message, equals('test'));
      expect(copied2.applications, isNull);
    });

    test('copyWith with applications', () {
      final initial = ApplicationState.initial();
      final copied = initial.copyWith(
        status: ApplicationStatus.loading,
        message: 'test',
        applications: [],
      );
      expect(copied.status, equals(ApplicationStatus.loading));
      expect(copied.message, equals('test'));
      expect(copied.applications, equals([]));

      final copied2 = copied.copyWith();
      expect(copied2.status, equals(ApplicationStatus.loading));
      expect(copied2.message, equals('test'));
      expect(copied2.applications, equals([]));
    });

    test('props are correct', () {
      expect(
        ApplicationState.initial()
            .copyWith(
              status: ApplicationStatus.ready,
              applications: [],
              message: 'test',
            )
            .props,
        equals([
          ApplicationStatus.ready,
          <ApplicationDesktopEntry>[],
          'test',
        ]),
      );
    });
  });
}
