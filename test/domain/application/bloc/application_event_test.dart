import 'package:desktop_entry/src/domain/application/bloc/application_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('ApplicationEvent', () {
    group('ApplicationGetListRequested', () {
      test('supports value comparisons', () {
        expect(
          const ApplicationGetListRequested(),
          equals(
            const ApplicationGetListRequested(),
          ),
        );
      });

      test('props are correct', () {
        expect(
          const ApplicationGetListRequested().props,
          equals([]),
        );
      });
    });
  });
}
