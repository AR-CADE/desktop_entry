import 'dart:async';
import 'dart:io';

import 'package:desktop_entry/src/data/repositories/application/application_repository.dart'
    show ApplicationRepository;
import 'package:desktop_entry/src/domain/application/bloc/application_bloc.dart'
    show ApplicationBloc;

// ---------------------------------------------------------------------------
// XDG helpers
// ---------------------------------------------------------------------------

Set<String>? getXdgDataDirs() {
  final dirs = Platform.environment['XDG_DATA_DIRS']?.split(':') ?? [];
  if (dirs.isEmpty) {
    return Platform.environment['XDG_DATA_DIRS']?.split(';').toSet();
  }
  return dirs.where((d) => d.isNotEmpty).map((d) {
    final home = Platform.environment['HOME'] ?? '~';
    if (d.startsWith('~')) {
      return d.replaceFirst('~', home);
    }
    return d;
  }).toSet();
}

String getXdgDataHome(String home) {
  final xdgDataHome =
      Platform.environment['XDG_DATA_HOME'] ?? '$home/.local/share';

  if (xdgDataHome.startsWith('~')) {
    return xdgDataHome.replaceFirst('~', home);
  }
  return xdgDataHome;
}

List<String> getDefaultApplicationDirectories() {
  final directories = <String>{};

  final xdgDataDirs = getXdgDataDirs();
  if (xdgDataDirs != null) {
    final dirs = xdgDataDirs.map(
      (dir) => '$dir/applications',
    );

    for (final directory in dirs) {
      final dir = Directory(directory);
      if (dir.existsSync()) {
        directories.add(directory);
      }
    }
  }

  if (directories.isEmpty) {
    final home = Platform.environment['HOME'] ?? '~';
    final xdgDataHome = getXdgDataHome(home);
    final dir = Directory('$xdgDataHome/applications');
    if (dir.existsSync()) {
      directories.add(dir.path);
    }
  }

  if (directories.isEmpty) {
    final xdgDataHome = Platform.environment['XDG_DATA_HOME'];
    if (xdgDataHome != null) {
      final dir = Directory('$xdgDataHome/applications');
      if (dir.existsSync()) {
        directories.addAll(
          [
            '/usr/share/applications/',
            '~/.local/share/applications',
            '/var/lib/snapd/desktop/applications/',
            '/var/lib/flatpak/exports/share/applications',
            '~/.local/share/flatpak/exports/share/applications',
          ].map((d) {
            final home = Platform.environment['HOME'] ?? '~';
            if (d.startsWith('~')) {
              return d.replaceFirst('~', home);
            }
            return d;
          }),
        );
      }
    }
  }
  return directories.toList();
}

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
        ..write(
          '\nApplications: ${app.name}\n',
        )
        ..write(
          'icon: ${app.icon}\n',
        )
        ..write(
          'localizedName: ${app.localizedName}\n',
        )
        ..write(
          'mimeType: ${app.mimeType}\n',
        )
        ..write(
          'keywords: ${app.keywords}\n',
        )
        ..write(
          'noDisplay: ${app.noDisplay}\n',
        )
        ..write(
          'exec: ${app.exec}\n',
        )
        ..write(
          'tryExec: ${app.tryExec}\n',
        )
        ..write(
          'actions: ${app.actions}\n',
        );

      if (app.desktopActions?.isNotEmpty ?? false) {
        for (final action in app.desktopActions!) {
          stdout
            ..write(
              'action Name: ${action.name}\n',
            )
            ..write(
              'action LocalizedName: ${action.localizedName}\n',
            )
            ..write(
              'action Icon: ${action.icon}\n',
            )
            ..write(
              'action Exec: ${action.exec}\n',
            );
        }
      }
    }
  }

  // print(DateTime.now());

  await bloc.close();
  exit(0);
}
