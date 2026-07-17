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

        expect(applications.length, 7);

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
        expect(test3.actions, ['Action1', 'Action2']);
        expect(test3.actions!.length, test3.desktopActions!.length);
        expect(test3.desktopNames, null);

        expect(test3.localizedName, {
          'en': 'Test - English',
          'ru': 'Тест - Русский',
          'ar': 'اختبار - العربية',
          'zh_CN': '测试 - 中文',
          'zh_TW': '测试 - 中文',
          'ko': '테스트 - 한국의',
          'jp': 'テスト - 日本語',
          'es': 'Test - Español',
          'it': 'Test - Italiano',
          'pt': 'Test - Português',
          'de': 'Test - Deutsch',
          'wo': 'Test - Wolof',
        });
        expect(test3.desktopActions, <DesktopAction>[
          const DesktopAction(
            name: 'Action 1',
            localizedName: {
              'en': 'Action 1 EN',
              'ru': 'Действие 1 RU',
              'ar': 'الإجراء 1 AR',
              'zh_CN': '行动 1 zh_CN',
              'zh_TW': '行动 1 zh_TW',
              'ko': '액션1 KO',
              'jp': 'アクション1 JP',
              'es': 'Acción 1 ES',
              'it': 'Azione 1 IT',
              'pt': 'Ação 1 PT',
              'de': 'Aktion 1 DE',
              'wo': 'Jëf 1 WO',
            },
            exec: 'ls',
          ),
          const DesktopAction(
            name: 'Action 2',
            localizedName: {
              'en': 'Action 2 EN',
              'ru': 'Действие 2 RU',
              'ar': 'الإجراء 2 AR',
              'zh_CN': '行动 2 zh_CN',
              'zh_TW': '行动 2 zh_TW',
              'ko': '액션2 KO',
              'jp': 'アクション2 JP',
              'es': 'Acción 2 ES',
              'it': 'Azione 2 IT',
              'pt': 'Ação 2 PT',
              'de': 'Aktion 2 DE',
              'wo': 'Jëf 2 WO',
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

        /// TEST 6
        final test6 = applications.firstWhere(
          (app) => app.name.startsWith('Test 6'),
        );
        expect(test6.exec, 'test');
        expect(test6.tryExec, 'test');
        expect(test6.desktopActions, null);
        expect(test6.icon, '');
        expect(test6.type, 'Application');
        expect(test6.desktopNames, ['Test', 'Test']);
        expect(test6.genericName, 'Generic name');
        expect(test6.comment, 'Comments');
        expect(test6.localizedGenericName, {
          'en': 'Generic name - English',
          'ru': 'Родовое название - Русский',
          'ar': 'الاسم العام - العربية',
          'zh_CN': '通用名称 - 中文',
          'zh_TW': '通用名稱 - 中文',
          'ko': '일반 이름 - 한국의',
          'jp': '一般名前 - 日本語',
          'es': 'Nombre genérico - Español',
          'it': 'Nome generico - Italiano',
          'pt': 'Nome genérico - Português',
          'de': 'Generischer Name - Deutsch',
          'wo': 'Tur generik - Wolof',
        });
        expect(test6.localizedComment, {
          'en': 'Comments - English',
          'ru': 'Комментарии - Русский',
          'ar': 'تعليقات - العربية',
          'zh_CN': '评论 - 中文',
          'zh_TW': '评论 - 中文',
          'ko': '댓글 - 한국의',
          'jp': 'コメント - 日本語',
          'es': 'Comentarios - Español',
          'it': 'Commenti - Italiano',
          'pt': 'Comentários - Português',
          'de': 'Kommentare - Deutsch',
          'wo': 'Komànteer - Wolof',
        });
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
