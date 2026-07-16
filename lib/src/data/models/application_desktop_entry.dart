import 'package:desktop_entry/src/core/helper.dart';
import 'package:desktop_entry/src/data/models/desktop_action.dart';
import 'package:desktop_entry/src/data/models/desktop_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_desktop_entry.g.dart';

/// Type 1
@JsonSerializable(fieldRename: FieldRename.pascal)
class ApplicationDesktopEntry extends DesktopEntry {
  const ApplicationDesktopEntry({
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
    this.actions,
    this.categories,
    this.exec,
    this.keywords,
    this.mimeType,
    this.path,
    this.prefersNonDefaultGPU,
    this.singleMainWindow,
    this.startupNotify,
    this.startupWMClass,
    this.terminal,
    this.tryExec,
    this.localizedKeywords,
    this.desktopNames,
    this.desktopActions,
  });

  factory ApplicationDesktopEntry.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDesktopEntryFromJson(json);

  /// Path to an executable file on disk used to determine if the program is
  /// actually installed. If the path is not an absolute path, the file is
  /// looked up in the $PATH environment variable. If the file is not present or
  /// if it is not executable, the entry may be ignored (not be used in menus,
  /// for example).
  final String? tryExec;

  /// Program to execute, possibly with arguments.
  /// See the [Exec key](https://specifications.freedesktop.org/desktop-entry/latest/exec-variables.html)
  /// for details on how this key works. The Exec key is required if
  /// DBusActivatable is not set to true. Even if DBusActivatable is true,
  /// Exec should be specified for compatibility with implementations that do
  /// not understand DBusActivatable.
  final String? exec;

  /// If entry is of type Application, the working directory to
  /// run the program in.
  final String? path;

  /// Whether the program runs in a terminal window.
  @JsonKey(fromJson: boolFromJson)
  final bool? terminal;

  /// Identifiers for application actions. This can be used to tell
  /// the application to make a specific action, different from the default
  /// behavior.
  /// The [Application actions](https://specifications.freedesktop.org/desktop-entry/latest/extra-actions.html)
  /// section describes how actions work.
  @JsonKey(toJson: listToArray, fromJson: listFromArray)
  final List<String>? actions;

  /// The MIME type(s) supported by this application.
  @JsonKey(toJson: listToArray, fromJson: listFromArray)
  final List<String>? mimeType;

  /// Categories in which the entry should be shown in a menu
  /// (for possible values see the
  /// [Desktop Menu Specification](http://www.freedesktop.org/Standards/menu-spec)).
  @JsonKey(toJson: listToArray, fromJson: listFromArray)
  final List<String>? categories;

  /// A list of strings which may be used in addition to other metadata to
  /// describe this entry. This can be useful e.g. to facilitate searching
  /// through entries. The values are not meant for display, and should not be
  /// redundant with the values of Name or GenericName.
  @JsonKey(toJson: listToArray, fromJson: listFromArray)
  final List<String>? keywords;
  @JsonKey(toJson: encodeLocalizedKeywords, fromJson: decodeLocalizedKeywords)
  final Map<String, List<String>>? localizedKeywords;

  /// If true, it is KNOWN that the application will send a "remove" message
  /// when started with the DESKTOP_STARTUP_ID environment variable set.
  /// If false, it is KNOWN that the application does not work with startup
  /// notification at all (does not shown any window, breaks even when using
  /// StartupWMClass, etc.). If absent, a reasonable handling is up to
  /// implementations (assuming false, using StartupWMClass, etc.).
  /// (See the [Startup Notification Protocol Specification](http://www.freedesktop.org/Standards/startup-notification-spec)
  /// for more details).
  @JsonKey(fromJson: boolFromJson)
  final bool? startupNotify;

  /// If specified, it is known that the application will map at least one
  /// window with the given string as its WM class or WM name hint (see the
  /// [Startup Notification Protocol Specification](http://www.freedesktop.org/Standards/startup-notification-spec)
  /// for more details).
  final String? startupWMClass;

  /// If true, the application prefers to be run on a more powerful discrete
  /// GPU if available, which we describe as “a GPU other than the default one”
  /// in this spec to avoid the need to define what a discrete GPU is and in
  /// which cases it might be considered more powerful than the default GPU.
  /// This key is only a hint and support might not be present depending on the
  /// implementation.
  @JsonKey(fromJson: boolFromJson)
  final bool? prefersNonDefaultGPU;

  /// If true, the application has a single main window, and does not support
  /// having an additional one opened. This key is used to signal to the
  /// implementation to avoid offering a UI to launch another window of the app.
  /// This key is only a hint and support might not be present depending on the
  /// implementation.
  @JsonKey(fromJson: boolFromJson)
  final bool? singleMainWindow;

  /// Not found in the Table of Standard Keys, and found only one mention of it
  /// in the scpecification, but some use it in the session file to declare the
  /// compositor name and type (eg. Wayfire;wlroots)
  @JsonKey(toJson: listToArray, fromJson: listFromArray)
  final List<String>? desktopNames;

  /// Desktop entries of type Application can include one or more actions.
  /// An action represents an additional way to invoke the application.
  /// Application launchers should expose them to the user
  /// (for example, as a submenu) within the context of the application.
  /// This is used to build so called "Quicklists" or "Jumplists".
  /// See the [Application actions](https://specifications.freedesktop.org/desktop-entry/latest/extra-actions.html)
  /// for more details.
  /// See also [actions].
  final List<DesktopAction>? desktopActions;

  @override
  Map<String, dynamic> toJson() => _$ApplicationDesktopEntryToJson(this);

  ApplicationDesktopEntry copyWith({
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
    String? tryExec,
    String? exec,
    String? path,
    bool? terminal,
    List<String>? actions,
    List<String>? mimeType,
    List<String>? categories,
    List<String>? keywords,
    bool? startupNotify,
    String? startupWMClass,
    bool? prefersNonDefaultGPU,
    bool? singleMainWindow,
    Map<String, String?>? localizedComment,
    Map<String, String>? localizedGenericName,
    Map<String, String>? localizedName,
    Map<String, List<String>>? localizedKeywords,
    List<String>? desktopNames,
    List<DesktopAction>? desktopActions,
  }) {
    return ApplicationDesktopEntry(
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
      tryExec: tryExec ?? this.tryExec,
      exec: exec ?? this.exec,
      path: path ?? this.path,
      terminal: terminal ?? this.terminal,
      actions: actions ?? this.actions,
      mimeType: mimeType ?? this.mimeType,
      categories: categories ?? this.categories,
      keywords: keywords ?? this.keywords,
      startupNotify: startupNotify ?? this.startupNotify,
      startupWMClass: startupWMClass ?? this.startupWMClass,
      prefersNonDefaultGPU: prefersNonDefaultGPU ?? this.prefersNonDefaultGPU,
      singleMainWindow: singleMainWindow ?? this.singleMainWindow,

      localizedComment: localizedComment ?? this.localizedComment,
      localizedGenericName: localizedGenericName ?? this.localizedGenericName,
      localizedName: localizedName ?? this.localizedName,

      localizedKeywords: localizedKeywords ?? this.localizedKeywords,
      desktopNames: desktopNames ?? this.desktopNames,
      desktopActions: desktopActions ?? this.desktopActions,
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
    tryExec,
    exec,
    path,
    terminal,
    actions,
    mimeType,
    categories,
    keywords,
    startupNotify,
    startupWMClass,
    prefersNonDefaultGPU,
    singleMainWindow,
    localizedComment,
    localizedGenericName,
    localizedName,
    localizedKeywords,
    desktopNames,
    desktopActions,
  ];
}
