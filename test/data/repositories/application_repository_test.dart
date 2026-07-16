import 'package:desktop_entry/src/data/models/desktop_action.dart';
import 'package:desktop_entry/src/data/repositories/application/application_repository.dart'
    show ApplicationRepository;
import 'package:test/test.dart';

void main() {
  group('ApplicationRepository', () {
    group('getApplications', () {
      late ApplicationRepository applicationRepository;
      setUp(() async {
        applicationRepository = const ApplicationRepository();
      });

      test('with success', () async {
        final applications = await applicationRepository.getApplications([
          'test/data/applications',
        ]);

        expect(applications.length, 6);

        /// TEST 0
        final test0 = applications.firstWhere(
          (app) => app.name.startsWith('Test 0'),
        );
        expect(test0.exec, 'test');
        expect(test0.tryExec, 'test');
        expect(test0.desktopActions, null);
        expect(test0.icon, 'application');
        expect(test0.type, 'Application');
        expect(test0.desktopNames, ['Test', 'Test']);

        /// TEST 1
        final test1 = applications.firstWhere(
          (app) => app.name.startsWith('Test 1'),
        );
        expect(test1.exec, 'test');
        expect(test1.tryExec, 'test');
        expect(test1.desktopActions, null);
        expect(test1.icon, '');
        expect(test1.type, 'Application');
        expect(test1.desktopNames, ['Test', 'Test']);

        /// TEST 2
        final test2 = applications.firstWhere(
          (app) => app.name.startsWith('Test 2'),
        );
        expect(test2.exec, 'test');
        expect(test2.tryExec, 'test');
        expect(test2.desktopActions, null);
        expect(test2.icon, '');
        expect(test2.type, null);
        expect(test2.desktopNames, ['Test', 'Test']);

        /// TEST 3
        final test3 = applications.firstWhere(
          (app) => app.name.startsWith('Test 3'),
        );
        expect(test3.exec, 'ls');
        expect(test3.tryExec, null);
        expect(test3.type, 'Application');
        expect(test3.actions, ['Action1']);
        expect(test3.actions!.length, test3.desktopActions!.length);
        expect(test3.desktopNames, null);

        expect(test3.localizedName, {
          'en': 'Test English',
          'ru': 'Тест Русский',
          'ar': 'اختبار عربي',
          'zh_CN': '测试中文',
          'zh_TW': '測試中文',
          'fr': 'Test French',
        });
        expect(test3.desktopActions, <DesktopAction>[
          const DesktopAction(
            name: 'Action 1',
            localizedName: {
              'en': 'Action 1 EN',
              'ru': 'Действие 1 РУ',
              'ar': '1 إجراء',
              'zh_CN': '動作中文',
              'zh_TW': '動作中文',
              'fr': 'Action 1 FR',
            },
            exec: 'ls',
          ),
        ]);

        /// TEST 4
        final test4 = applications.firstWhere(
          (app) => app.name.startsWith('Test 4'),
        );
        expect(test4.exec, 'ls');
        expect(test4.tryExec, null);
        expect(test4.desktopActions, null);
        expect(test4.icon, null);
        expect(test4.type, null);
        expect(test4.desktopNames, null);
        expect(test4.hidden, true);

        /// TEST 5
        final test5 = applications.firstWhere(
          (app) => app.name.startsWith('Test 5'),
        );
        expect(test5.exec, 'doesnotexist1234');
        expect(test5.tryExec, 'doesnotexist1234');
        expect(test5.desktopActions, null);
        expect(test5.icon, null);
        expect(test5.type, 'Application');
        expect(test5.desktopNames, null);
      });

      test('with missing directory', () async {
        final applications = await applicationRepository.getApplications([
          'test/data/missing_dir',
        ]);

        expect(applications.length, 0);
      });
    });
  });
}
