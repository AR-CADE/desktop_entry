import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'desktop_action.g.dart';

/// Type 1
@JsonSerializable(fieldRename: FieldRename.pascal)
class DesktopAction extends Equatable {
  const DesktopAction({
    required this.name,
    this.localizedName,
    this.icon,
    this.exec,
  });

  factory DesktopAction.fromJson(Map<String, dynamic> json) =>
      _$DesktopActionFromJson(json);

  /// Label that will be shown to the user.
  /// Since actions are always shown in the context of a specific application
  /// (that is, as a submenu of a launcher), this only needs to be unambiguous
  /// swithin one application and should not include the application name.
  final String name;
  final Map<String, String>? localizedName;

  /// Icon to be shown together with the action.
  /// If the name is an absolute path, the given file will be used.
  /// If the name is not an absolute path, the algorithm described in the
  /// [Icon Theme Specification](http://freedesktop.org/wiki/Standards/icon-theme-spec)
  /// will be used to locate the icon. Implementations may choose to ignore it.
  final String? icon;

  /// Program to execute for this action, possibly with arguments.
  /// See the
  /// [Exec key](https://specifications.freedesktop.org/desktop-entry/latest/exec-variables.html)
  /// for details on how this key works.
  /// The Exec key is required if DBusActivatable is not set to true in
  /// the main desktop entry group. Even if DBusActivatable is true,
  /// Exec should be specified for compatibility with implementations that
  /// do not understand DBusActivatable.
  final String? exec;

  Map<String, dynamic> toJson() => _$DesktopActionToJson(this);

  DesktopAction copyWith({
    String? name,
    String? icon,
    String? exec,
    Map<String, String>? localizedName,
  }) {
    return DesktopAction(
      name: name ?? this.name,
      localizedName: localizedName ?? this.localizedName,
      icon: icon ?? this.icon,
      exec: exec ?? this.exec,
    );
  }

  @override
  List<Object?> get props => [
    name,
    localizedName,
    icon,
    exec,
  ];
}
