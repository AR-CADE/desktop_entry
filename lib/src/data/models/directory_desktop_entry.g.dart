// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_desktop_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectoryDesktopEntry _$DirectoryDesktopEntryFromJson(
  Map<String, dynamic> json,
) => DirectoryDesktopEntry(
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
);

Map<String, dynamic> _$DirectoryDesktopEntryToJson(
  DirectoryDesktopEntry instance,
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
};
