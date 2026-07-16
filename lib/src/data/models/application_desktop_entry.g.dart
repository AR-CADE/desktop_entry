// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_desktop_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationDesktopEntry _$ApplicationDesktopEntryFromJson(
  Map<String, dynamic> json,
) => ApplicationDesktopEntry(
  name: json['Name'] as String,
  type: typeFromJson(json['Type'] as String?),
  comment: json['Comment'] as String?,
  dBusActivatable: boolFromJson(json['DBusActivatable'] as String?),
  genericName: json['GenericName'] as String?,
  hidden: boolFromJson(json['Hidden'] as String?),
  icon: json['Icon'] as String?,
  implements: listFromArray(json['Implements'] as String?),
  noDisplay: boolFromJson(json['NoDisplay'] as String?),
  notShowIn: json['NotShowIn'] as String?,
  onlyShowIn: json['OnlyShowIn'] as String?,
  version: json['Version'] as String?,
  localizedComment: (json['LocalizedComment'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String?),
  ),
  localizedGenericName: (json['LocalizedGenericName'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, e as String)),
  localizedName: (json['LocalizedName'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  actions: listFromArray(json['Actions'] as String?),
  categories: listFromArray(json['Categories'] as String?),
  exec: json['Exec'] as String?,
  keywords: listFromArray(json['Keywords'] as String?),
  mimeType: listFromArray(json['MimeType'] as String?),
  path: json['Path'] as String?,
  prefersNonDefaultGPU: boolFromJson(json['PrefersNonDefaultGPU'] as String?),
  singleMainWindow: boolFromJson(json['SingleMainWindow'] as String?),
  startupNotify: boolFromJson(json['StartupNotify'] as String?),
  startupWMClass: json['StartupWMClass'] as String?,
  terminal: boolFromJson(json['Terminal'] as String?),
  tryExec: json['TryExec'] as String?,
  localizedKeywords: decodeLocalizedKeywords(
    json['LocalizedKeywords'] as Map<String, dynamic>?,
  ),
  desktopNames: listFromArray(json['DesktopNames'] as String?),
  desktopActions: (json['DesktopActions'] as List<dynamic>?)
      ?.map((e) => DesktopAction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ApplicationDesktopEntryToJson(
  ApplicationDesktopEntry instance,
) => <String, dynamic>{
  'Type': instance.type,
  'Version': instance.version,
  'Name': instance.name,
  'LocalizedName': instance.localizedName,
  'GenericName': instance.genericName,
  'LocalizedGenericName': instance.localizedGenericName,
  'NoDisplay': instance.noDisplay,
  'Comment': instance.comment,
  'LocalizedComment': instance.localizedComment,
  'Icon': instance.icon,
  'Hidden': instance.hidden,
  'OnlyShowIn': instance.onlyShowIn,
  'NotShowIn': instance.notShowIn,
  'DBusActivatable': instance.dBusActivatable,
  'Implements': listToArray(instance.implements),
  'TryExec': instance.tryExec,
  'Exec': instance.exec,
  'Path': instance.path,
  'Terminal': instance.terminal,
  'Actions': listToArray(instance.actions),
  'MimeType': listToArray(instance.mimeType),
  'Categories': listToArray(instance.categories),
  'Keywords': listToArray(instance.keywords),
  'LocalizedKeywords': encodeLocalizedKeywords(instance.localizedKeywords),
  'StartupNotify': instance.startupNotify,
  'StartupWMClass': instance.startupWMClass,
  'PrefersNonDefaultGPU': instance.prefersNonDefaultGPU,
  'SingleMainWindow': instance.singleMainWindow,
  'DesktopNames': listToArray(instance.desktopNames),
  'DesktopActions': instance.desktopActions?.map((e) => e.toJson()).toList(),
};
