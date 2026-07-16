import 'package:desktop_entry/src/core/helper.dart';
import 'package:desktop_entry/src/data/models/application_desktop_entry.dart';
import 'package:desktop_entry/src/data/models/directory_desktop_entry.dart';
import 'package:desktop_entry/src/data/models/link_desktop_entry.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class DesktopEntry extends Equatable {
  const DesktopEntry({
    required this.name,
    required this.type,
    this.comment,
    this.dBusActivatable,
    this.genericName,
    this.hidden,
    this.icon,
    this.implements,
    this.noDisplay,
    this.notShowIn,
    this.onlyShowIn,
    this.version,
    this.localizedComment,
    this.localizedGenericName,
    this.localizedName,
  });

  factory DesktopEntry.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('Type')) {
      final type = json['Type'] as String?;

      switch (type) {
        case 'Application':
          return ApplicationDesktopEntry.fromJson(json);
        case 'Directory':
          return DirectoryDesktopEntry.fromJson(json);
        case 'Link':
          return LinkDesktopEntry.fromJson(json);
        default:
      }
    }

    throw const FormatException('Invalid Desktop Entry type');
  }

  /// This specification defines 3 types of desktop entries:
  /// Application (type 1),
  /// Link (type 2)
  /// and Directory (type 3).
  /// To allow the addition of new types in the future,
  /// implementations should ignore desktop entries with an unknown type.
  ///
  /// NOTE: According to the specification, the Key `Type` should required,
  /// but i made it conditionnal to workaround the .desktop file
  /// of KDE plasma (at least on my system)
  @JsonKey(fromJson: typeFromJson)
  final String? type;

  /// Version of the Desktop Entry Specification that the desktop entry conforms
  /// with. Entries that confirm with this version of the specification should
  /// use 1.5. Note that the version field is not required to be present.
  final String? version;

  /// Specific name of the application, for example "Mozilla".
  final String name;
  final Map<String, String>? localizedName;

  /// Generic name of the application, for example "Web Browser".
  final String? genericName;
  final Map<String, String>? localizedGenericName;

  /// NoDisplay means
  /// "this application exists, but don't display it in the menus".
  /// This can be useful to e.g. associate this application with MIME types,
  /// so that it gets launched from a file manager (or other apps),
  /// without having a menu entry for it (there are tons of good reasons
  /// for this, including e.g. the netscape -remote,
  /// or kfmclient openURL kind of stuff).
  @JsonKey(fromJson: boolFromJson)
  final bool? noDisplay;

  /// Tooltip for the entry, for example "View sites on the Internet".
  /// The value should not be redundant with the values of Name and GenericName.
  /// Valid for Type 1-3
  final String? comment;
  final Map<String, String?>? localizedComment;

  /// Icon to display in file manager, menus, etc. If the name is an
  /// absolute path, the given file will be used. If the name is not an
  /// absolute path, the algorithm described in
  /// the [Icon Theme Specification](http://freedesktop.org/wiki/Standards/icon-theme-spec)
  /// will be used to locate the icon.
  final String? icon;

  /// Hidden should have been called Deleted. It means the user deleted
  /// (at their level) something that was present (at an upper level, e.g. in
  /// the system dirs). It's strictly equivalent to the .desktop file not
  /// existing at all, as far as that user is concerned. This can also be used
  /// to "uninstall" existing files (e.g. due to a renaming) - by letting
  /// `make install` install a file with Hidden=true in it.
  @JsonKey(fromJson: boolFromJson)
  final bool? hidden;

  /// A list of strings identifying the desktop environments that should
  /// display/not display a given desktop entry. By default, a desktop file
  /// should be shown, unless an OnlyShowIn key is present, in which case,
  /// the default is for the file not to be shown. If $XDG_CURRENT_DESKTOP is
  /// set then it contains a colon-separated list of strings. In order, each
  /// string is considered. If a matching entry is found in OnlyShowIn then the
  /// desktop file is shown. If an entry is found in NotShowIn then the desktop
  /// file is not shown. If none of the strings match then the default action
  /// is taken (as above). $XDG_CURRENT_DESKTOP should have been set by the
  /// login manager, according to the value of the DesktopNames found in the
  /// session file. The entry in the session file has multiple values separated
  /// in the usual way: with a semicolon. The same desktop name may not appear
  /// in both OnlyShowIn and NotShowIn of a group.
  final String? onlyShowIn;

  /// A list of strings identifying the desktop environments that should
  /// display/not display a given desktop entry. By default, a desktop file
  /// should be shown, unless an OnlyShowIn key is present, in which case,
  /// the default is for the file not to be shown. If $XDG_CURRENT_DESKTOP is
  /// set then it contains a colon-separated list of strings. In order, each
  /// string is considered. If a matching entry is found in OnlyShowIn then the
  /// desktop file is shown. If an entry is found in NotShowIn then the desktop
  /// file is not shown. If none of the strings match then the default action
  /// is taken (as above). $XDG_CURRENT_DESKTOP should have been set by the
  /// login manager, according to the value of the DesktopNames found in the
  /// session file. The entry in the session file has multiple values separated
  /// in the usual way: with a semicolon. The same desktop name may not appear
  /// in both OnlyShowIn and NotShowIn of a group.
  final String? notShowIn;

  /// A boolean value specifying if D-Bus activation is supported for
  /// this application. If this key is missing, the default value is false.
  /// If the value is true then implementations should ignore the Exec key and
  /// send a D-Bus message to launch the application.
  /// See [D-Bus Activation](https://specifications.freedesktop.org/desktop-entry/latest/dbus.html)
  /// for more information on how this works. Applications should still include
  /// Exec= lines in their desktop files for compatibility with implementations
  /// that do not understand the DBusActivatable key.
  @JsonKey(fromJson: boolFromJson)
  final bool? dBusActivatable;

  /// A list of interfaces that this application implements. By default, a
  /// desktop file implements no interfaces.
  /// See [Interfaces](https://specifications.freedesktop.org/desktop-entry/latest/interfaces.html) for more
  /// information on how this works.
  @JsonKey(toJson: listToArray, fromJson: listFromArray)
  final List<String>? implements;

  Map<String, dynamic> toJson();

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
