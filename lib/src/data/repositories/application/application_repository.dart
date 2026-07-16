import 'dart:io' show Directory, File, stderr;

import 'package:desktop_entry/src/data/models/application_desktop_entry.dart';
import 'package:ini/ini.dart';
import 'package:meta/meta.dart' show immutable;

final _strictNameKeyRegex = RegExp(r'^\s*(.+?)\s*\[\s*(.+)\s*\]\s*$');

bool _isLocalizedProperty(String? input) {
  if (input == null) {
    return false;
  }
  return _strictNameKeyRegex.hasMatch(input);
}

Map<String, dynamic> _extractPropertyNameAndKey(String input) {
  final match = _strictNameKeyRegex.firstMatch(input)!;
  return {
    'propertyName': match.group(1)!.trim(),
    'key': match.group(2)!.trim(),
  };
}

// bool _isExecutableAvailable(String? tryExec) {
//   if (tryExec == null || tryExec.isEmpty) return true;
//   final whichResult = Process.runSync('which', [tryExec]);
//   return whichResult.exitCode == 0;
// }

@immutable
class ApplicationRepository {
  const ApplicationRepository();

  ApplicationDesktopEntry? getApplication(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      stderr.write('file do not existe $filePath');
      return null;
    }

    final lines = file.readAsLinesSync();
    final entries = <String, dynamic>{};

    try {
      final config = Config.fromStrings(lines);
      if (config.hasSection('Desktop Entry')) {
        final options = config.options('Desktop Entry');

        if (options != null) {
          for (final key in options) {
            final value = config.get('Desktop Entry', key);

            if (_isLocalizedProperty(key)) {
              final extraction = _extractPropertyNameAndKey(key);

              final localizedProperty =
                  entries['Localized${extraction['propertyName']}']
                      as Map<String, dynamic>?;
              final k = extraction['key'] as String?;

              if (k != null) {
                if (localizedProperty != null) {
                  try {
                    final map = localizedProperty..putIfAbsent(k, () => value);

                    entries['Localized${extraction['propertyName']}'] = map;
                  } on Exception catch (e) {
                    stderr.write(e);
                  }
                } else {
                  entries['Localized${extraction['propertyName']}'] =
                      <String, dynamic>{
                        k: value,
                      };
                }
              }
            } else {
              entries[key] = value;
            }
          }
        }
      }

      final actions = <Map<String, dynamic>>[];

      for (final section in config.sections()) {
        final action = <String, dynamic>{};

        if (section.startsWith('Desktop Action')) {
          final options = config.options(section);

          if (options != null) {
            for (final key in options) {
              final value = config.get(section, key);
              if (_isLocalizedProperty(key)) {
                final extraction = _extractPropertyNameAndKey(key);

                final localizedProperty =
                    action['Localized${extraction['propertyName']}']
                        as Map<String, dynamic>?;
                final k = extraction['key'] as String?;

                if (k != null) {
                  if (localizedProperty != null) {
                    try {
                      final map = localizedProperty
                        ..putIfAbsent(k, () => value);

                      action['Localized${extraction['propertyName']}'] = map;
                    } on Exception catch (e) {
                      stderr.write(e);
                    }
                  } else {
                    action['Localized${extraction['propertyName']}'] =
                        <String, dynamic>{
                          k: value,
                        };
                  }
                }
              } else {
                action[key] = value;
              }
            }
          }
        }

        if (action.isNotEmpty) {
          actions.add(action);
        }
      }
      if (actions.isNotEmpty) {
        entries['DesktopActions'] = actions;
      }
    } on Exception catch (e) {
      stderr.write(e);
    }

    try {
      return ApplicationDesktopEntry.fromJson(entries);
    } on Exception catch (e) {
      stderr.write(e);
      return null;
    }
  }

  Future<List<ApplicationDesktopEntry>> getApplications(
    List<String> directories,
  ) async {
    final applications = <ApplicationDesktopEntry>[];
    for (final directory in directories) {
      if (directory.isEmpty) continue;

      applications.addAll(_getApplications(directory));
    }
    return applications;
  }

  List<ApplicationDesktopEntry> _getApplications(String directory) {
    if (directory.isEmpty) return [];

    final dir = Directory(directory);
    if (!dir.existsSync()) {
      stderr.write('Unable to find $directory');
      return [];
    }

    final applications = <ApplicationDesktopEntry>[];
    final entities = dir.listSync().toList();

    for (final entity in entities) {
      if (entity is Directory) {
        continue;
      }

      if (!entity.path.endsWith('.desktop')) {
        continue;
      }

      final application = getApplication(entity.path);
      if (application == null) {
        continue;
      }

      // if (!_isExecutableAvailable(application.exec) &&
      //     !_isExecutableAvailable(application.tryExec)) {
      //   stdout.write(
      //     'Application ignored (neither Exec or TryExec are avaible):'
      //     ' ${application.name}',
      //   );
      //   continue;
      // }

      applications.add(application);
    }

    applications.sort((a, b) => a.name.compareTo(b.name));
    return applications;
  }
}
