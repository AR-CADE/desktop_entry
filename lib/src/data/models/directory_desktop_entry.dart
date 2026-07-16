import 'package:desktop_entry/src/core/helper.dart';
import 'package:desktop_entry/src/data/models/desktop_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'directory_desktop_entry.g.dart';

/// Type 3
@JsonSerializable(fieldRename: FieldRename.pascal)
class DirectoryDesktopEntry extends DesktopEntry {
  const DirectoryDesktopEntry({
    required super.name,
    required super.type,
    super.comment,
    super.dBusActivatable,
    super.genericName,
    super.hidden,
    super.icon,
    super.implements,
    super.noDisplay,
    super.notShowIn,
    super.onlyShowIn,
    super.version,
    super.localizedComment,
    super.localizedGenericName,
    super.localizedName,
  });

  factory DirectoryDesktopEntry.fromJson(Map<String, dynamic> json) =>
      _$DirectoryDesktopEntryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DirectoryDesktopEntryToJson(this);

  DirectoryDesktopEntry copyWith({
    String? name,
    String? type,
    String? comment,
    bool? dBusActivatable,
    String? genericName,
    bool? hidden,
    String? icon,
    List<String>? implements,
    bool? noDisplay,
    String? notShowIn,
    String? onlyShowIn,
    String? version,
    String? url,
    Map<String, String?>? localizedComment,
    Map<String, String>? localizedGenericName,
    Map<String, String>? localizedName,
  }) {
    return DirectoryDesktopEntry(
      name: name ?? this.name,
      type: type ?? this.type,
      comment: comment ?? this.comment,
      dBusActivatable: dBusActivatable ?? this.dBusActivatable,
      genericName: genericName ?? this.genericName,
      hidden: hidden ?? this.hidden,
      icon: icon ?? this.icon,
      implements: implements ?? this.implements,
      noDisplay: noDisplay ?? this.noDisplay,
      notShowIn: notShowIn ?? this.notShowIn,
      onlyShowIn: onlyShowIn ?? this.onlyShowIn,
      version: version ?? this.version,
      localizedComment: localizedComment ?? this.localizedComment,
      localizedGenericName: localizedGenericName ?? this.localizedGenericName,
      localizedName: localizedName ?? this.localizedName,
    );
  }

  @override
  List<Object?> get props => [
    name,
    type,
    comment,
    dBusActivatable,
    genericName,
    hidden,
    icon,
    implements,
    noDisplay,
    notShowIn,
    onlyShowIn,
    version,
    localizedComment,
    localizedGenericName,
    localizedName,
  ];
}
