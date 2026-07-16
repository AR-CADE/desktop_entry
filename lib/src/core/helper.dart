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
