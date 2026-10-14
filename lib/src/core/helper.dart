import 'dart:io';

import 'package:meta/meta.dart';

@visibleForTesting
List<String> splitDesktopEntryList(String input, {String delimiter = ';'}) {
  if (input.isEmpty) return [];

  final parts = input.split(delimiter);

  if (input.endsWith(delimiter)) {
    return parts.sublist(0, parts.length - 1);
  }

  return parts;
}

String? listToArray(List<String>? value) => value?.join(';');
List<String>? listFromArray(String? value) =>
    value != null ? splitDesktopEntryList(value) : null;

Map<String, dynamic>? encodeLocalizedKeywords(
  Map<String, List<String>>? value,
) {
  if (value == null) {
    return null;
  }

  return value.map((k, v) {
    return MapEntry(k, v.join(';'));
  });
}

Map<String, List<String>>? decodeLocalizedKeywords(
  Map<String, dynamic>? value,
) {
  if (value == null) {
    return null;
  }
  return value.map((k, v) {
    return MapEntry(k, splitDesktopEntryList(v as String));
  });
}

bool? boolFromJson(String? value) {
  if (value == null) {
    return null;
  }
  return bool.tryParse(value);
}

String? typeFromJson(String? value) {
  if (value == null) {
    stdout.write(
      'WARNING: the value `Type` is null but should not be, according to '
      'the specification, see https://specifications.freedesktop.org/desktop-entry/latest/recognized-keys.html\n',
    );
  }
  return value;
}

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

List<String> getDefaultIconDirectories() {
  final home = Platform.environment['HOME'] ?? '~';
  final xdgDataDirs = getXdgDataDirs() ?? <String>{};

  if (!xdgDataDirs.contains('/usr/share')) {
    xdgDataDirs.add('/usr/share');
  }

  final dataDirs = xdgDataDirs.map((e) => '$e/icons').toList()
    ..add('/usr/share/pixmaps');

  final xdgDataHome = getXdgDataHome(home);

  final directories = ['$home/.icons', '$xdgDataHome/icons', ...dataDirs];
  return directories;
}

List<String> getDefaultApplicationDirectories() {
  final directories = <String>{};

  final xdgDataDirs = getXdgDataDirs();
  if (xdgDataDirs != null) {
    final dirs = xdgDataDirs.map((dir) => '$dir/applications');

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
