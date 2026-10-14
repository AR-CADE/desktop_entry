import 'dart:async';
import 'dart:io';

import 'package:desktop_entry/src/core/helper.dart'
    show getDefaultApplicationDirectories;
import 'package:desktop_entry/src/data/repositories/application/application_repository.dart'
    show ApplicationRepository;
import 'package:desktop_entry/src/domain/application/bloc/application_bloc.dart'
    show ApplicationBloc;

Future<void> main() async {
  const applicationRepository = ApplicationRepository();
  final bloc = ApplicationBloc(
    repository: applicationRepository,
    directories: getDefaultApplicationDirectories(),
  );
  // print(DateTime.now());

  final _ = await bloc.stream.first; // initial state
  final value = await bloc.stream.first;

  stdout.write(
    '\nApplicationState.status ${DateTime.now()}: ${value.status}\n',
  );

  final applications = value.applications;
  if (applications != null) {
    for (final app in applications) {
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
          stdout
            ..write('action Name: ${action.name}\n')
            ..write('action LocalizedName: ${action.localizedName}\n')
            ..write('action Icon: ${action.icon}\n')
            ..write('action Exec: ${action.exec}\n');
        }
      }
    }
  }

  // print(DateTime.now());

  await bloc.close();
  exit(0);
}
