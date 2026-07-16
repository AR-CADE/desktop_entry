import 'package:bloc_test/bloc_test.dart';
import 'package:desktop_entry/src/data/models/application_desktop_entry.dart';
import 'package:desktop_entry/src/data/repositories/application/application_repository.dart';
import 'package:desktop_entry/src/domain/application/bloc/application_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApplicationRepository extends Mock implements ApplicationRepository {}

void main() {
  group('ApplicationBloc', () {
    late ApplicationRepository repository;

    setUp(() {
      repository = MockApplicationRepository();
    });

    test('initial state is correct', () async {
      when(() => repository.getApplications(any())).thenAnswer((_) async => []);

      final bloc = ApplicationBloc(
        repository: repository,
        directories: const ['/test'],
      );

      expect(bloc.state.status, equals(ApplicationStatus.initial));
      await bloc.close();
    });

    blocTest<ApplicationBloc, ApplicationState>(
      'emits [loading, ready] when getApplications succeeds',
      setUp: () {
        when(
          () => repository.getApplications(any()),
        ).thenAnswer((_) async => <ApplicationDesktopEntry>[]);
      },
      build: () => ApplicationBloc(
        repository: repository,
        directories: const ['/test'],
      ),
      expect: () => const [
        ApplicationState(status: ApplicationStatus.loading),
        ApplicationState(status: ApplicationStatus.ready, applications: []),
      ],
    );

    blocTest<ApplicationBloc, ApplicationState>(
      'emits [loading, error] when getApplications throws',
      setUp: () {
        when(
          () => repository.getApplications(any()),
        ).thenThrow(Exception('oops'));
      },
      build: () => ApplicationBloc(
        repository: repository,
        directories: const ['/test'],
      ),
      expect: () => const [
        ApplicationState(status: ApplicationStatus.loading),
        ApplicationState(
          status: ApplicationStatus.error,
          message: 'Exception: oops',
        ),
      ],
    );
  });
}
