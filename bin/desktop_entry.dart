import 'dart:async';
import 'dart:io';

import 'package:desktop_entry/desktop_entry.dart';

Future<void> main() async {
  final iconDirectories = getDefaultIconDirectories();

  const applicationRepository = ApplicationRepository();
  final bloc = ApplicationBloc(
    repository: applicationRepository,
    directories: getDefaultApplicationDirectories(),
  );

  final _ = await bloc.stream.first; // initial state
  final value = await bloc.stream.first;

  final icons = <String>[];

  stdout.write(
    '\nApplicationState.status ${DateTime.now()}: ${value.status}\n',
  );

  final applications = value.applications;
  if (applications != null) {
    for (final app in applications) {
      final icon = app.icon;
      if (icon != null &&
          icon != 'null' &&
          app.noDisplay != true &&
          app.hidden != true) {
        icons.add(icon);
      }
      stdout
        ..write('\nApplications: ${app.name}\n')
        ..write('icon: ${app.icon}\n')
        ..write('localizedName: ${app.localizedName}\n')
        ..write('mimeType: ${app.mimeType}\n')
        ..write('keywords: ${app.keywords}\n')
        ..write('noDisplay: ${app.noDisplay}\n')
        ..write('exec: ${app.exec}\n')
        ..write('tryExec: ${app.tryExec}\n')
        ..write('actions: ${app.actions}\n');

      if (app.desktopActions?.isNotEmpty ?? false) {
        for (final action in app.desktopActions!) {
          final icon = action.icon;
          if (icon != null &&
              icon != 'null' &&
              app.noDisplay != true &&
              app.hidden != true) {
            icons.add(icon);
          }
          stdout
            ..write('action Name: ${action.name}\n')
            ..write('action LocalizedName: ${action.localizedName}\n')
            ..write('action Icon: ${action.icon}\n')
            ..write('action Exec: ${action.exec}\n');
        }
      }
    }
  }

  final results = await Future.wait(
    icons.map((icon) => findIcon(icon, iconDirectories, size: 64)),
  );

  results.whereType<IconRef>().map((i) => i.path).forEach(stdout.write);

  await bloc.close();
  exit(0);
}
