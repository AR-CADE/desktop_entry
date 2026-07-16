// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesktopAction _$DesktopActionFromJson(Map<String, dynamic> json) =>
    DesktopAction(
      name: json['Name'] as String,
      localizedName: (json['LocalizedName'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      icon: json['Icon'] as String?,
      exec: json['Exec'] as String?,
    );

Map<String, dynamic> _$DesktopActionToJson(DesktopAction instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'LocalizedName': instance.localizedName,
      'Icon': instance.icon,
      'Exec': instance.exec,
    };
