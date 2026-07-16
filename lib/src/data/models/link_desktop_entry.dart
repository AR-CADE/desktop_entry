import 'package:desktop_entry/src/core/helper.dart';
import 'package:desktop_entry/src/data/models/desktop_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'link_desktop_entry.g.dart';

/// Type 2
@JsonSerializable(fieldRename: FieldRename.pascal)
class LinkDesktopEntry extends DesktopEntry {
  const LinkDesktopEntry({
    required this.url,
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

  factory LinkDesktopEntry.fromJson(Map<String, dynamic> json) =>
      _$LinkDesktopEntryFromJson(json);

  /// If entry is Link type, the URL to access.
  final String url;

  @override
  Map<String, dynamic> toJson() => _$LinkDesktopEntryToJson(this);

  LinkDesktopEntry copyWith({
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
    return LinkDesktopEntry(
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
      url: url ?? this.url,
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
    url,
    localizedComment,
    localizedGenericName,
    localizedName,
  ];
}
