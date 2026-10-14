import 'dart:convert';
import 'dart:io' show Directory, File, Platform, stdout;
import 'dart:isolate' show Isolate;

import 'package:desktop_entry/src/core/helper.dart'
    show getDefaultIconDirectories;
import 'package:ini/ini.dart';

class IconRef {
  const new({required this.name, this.path});
  final String name;
  final String? path;
}

/// ---------------------------------------------------------------------------
/// ThemeSettings model
/// ---------------------------------------------------------------------------
class ThemeSettings {
  const new({
    required this.gtkTheme,
    required this.iconTheme,
    required this.cursorTheme,
    required this.cursorSize,
    required this.preferDarkTheme,
  });

  final String gtkTheme;
  final String iconTheme;
  final String cursorTheme;
  final String cursorSize;
  final String preferDarkTheme;
}

/// ---------------------------------------------------------------------------
/// Icon-lookup cache
/// ---------------------------------------------------------------------------
class IconCache {
  new _();
  static final IconCache instance = IconCache._();

  ThemeSettings? _settings;
  Config? _gtkConfig;
  String? _gtkConfigHome;
  int? _gtkConfigVersion;

  final Map<String, String?> _icons = {};
  final Map<String, List<String>?> _themeParents = {};
  final Map<String, Config?> _themeConfigs = {};

  final Map<String, Map<String, String>> _dirContents = {};

  String? getIcon(String key) => _icons[key];
  bool hasIcon(String key) => _icons.containsKey(key);
  void putIcon(String key, String? value) => _icons[key] = value;

  static String get _persistPath {
    final home = Platform.environment['HOME'] ?? '';
    return '$home/.cache/icon_theme_cache.json';
  }

  Future<void> loadFromDisk() async {
    try {
      final file = File(_persistPath);
      if (!file.existsSync()) return;
      final data =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final icons = data['icons'] as Map<String, dynamic>?;
      if (icons != null) {
        for (final e in icons.entries) {
          _icons[e.key] = e.value as String?;
        }
      }
    } on Exception catch (_) {}
  }

  Future<void> saveToDisk() async {
    try {
      final file = File(_persistPath);
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode({'icons': _icons}));
    } on Exception catch (_) {}
  }

  void clear() {
    _settings = null;
    _gtkConfig = null;
    _gtkConfigHome = null;
    _gtkConfigVersion = null;
    _icons.clear();
    _themeParents.clear();
    _themeConfigs.clear();
    _dirContents.clear();
  }
}

Map<String, String> _getDirectoryFiles(String path) {
  final cache = IconCache.instance;
  if (cache._dirContents.containsKey(path)) {
    return cache._dirContents[path]!;
  }

  final dir = Directory(path);
  if (!dir.existsSync()) {
    cache._dirContents[path] = {};
    return {};
  }

  try {
    final filesMap = <String, String>{};
    for (final entity in dir.listSync()) {
      if (entity is File) {
        final filename = entity.path.split('/').last.toLowerCase();
        filesMap[filename] = entity.path;
      }
    }
    cache._dirContents[path] = filesMap;
    return filesMap;
  } on Exception catch (_) {
    cache._dirContents[path] = {};
    return {};
  }
}

Config? _getThemeConfig(String theme, List<String> directories) {
  final cache = IconCache.instance;
  if (cache._themeConfigs.containsKey(theme)) {
    return cache._themeConfigs[theme];
  }

  for (final directory in directories) {
    final themeFile = File('$directory/$theme/index.theme');
    if (themeFile.existsSync()) {
      try {
        final config = Config.fromString(themeFile.readAsStringSync());
        cache._themeConfigs[theme] = config;
        return config;
      } on Exception catch (_) {}
    }
  }

  cache._themeConfigs[theme] = null;
  return null;
}

// ---------------------------------------------------------------------------
// GTK settings
// ---------------------------------------------------------------------------
Future<ThemeSettings> getThemeSettings({
  int gtkVersion = 3,
  bool persistCache = false,
}) async {
  final cache = IconCache.instance;

  if (persistCache && cache._icons.isEmpty) await cache.loadFromDisk();
  if (cache._settings != null) return cache._settings!;

  final home = Platform.environment['HOME'] ?? '';
  final env = Platform.environment;

  final config = _getGtkConfig(home, gtkVersion);

  final gtkTheme =
      env['GTK_THEME'] ??
      config?.get('Settings', 'gtk-theme-name') ??
      'Adwaita';
  final iconTheme =
      env['ICON_THEME'] ??
      config?.get('Settings', 'gtk-icon-theme-name') ??
      'Adwaita';
  final cursorTheme =
      env['XCURSOR_THEME'] ??
      config?.get('Settings', 'gtk-cursor-theme-name') ??
      'Adwaita';
  final cursorSize =
      env['XCURSOR_SIZE'] ??
      config?.get('Settings', 'gtk-cursor-theme-size') ??
      '24';
  final preferDarkTheme =
      env['GTK_SETTINGS_PREFER_DARK_THEME'] ??
      config?.get('Settings', 'gtk-application-prefer-dark-theme') ??
      'true';
  // final doFindClosest =
  //     bool.tryParse(
  //       env['ICON_THEME_FIND_CLOSEST'] ?? '',
  //     ) ??
  //     findClosest;

  final settings = ThemeSettings(
    gtkTheme: gtkTheme,
    iconTheme: iconTheme,
    cursorTheme: cursorTheme,
    cursorSize: cursorSize,
    preferDarkTheme: preferDarkTheme,
  );

  cache._settings = settings;
  return settings;
}

Config? _getGtkConfig(String home, int gtkVersion) {
  final cache = IconCache.instance;
  if (cache._gtkConfig != null &&
      cache._gtkConfigHome == home &&
      cache._gtkConfigVersion == gtkVersion) {
    return cache._gtkConfig;
  }
  try {
    final file = File('$home/.config/gtk-$gtkVersion.0/settings.ini');
    if (!file.existsSync()) return null;
    final config = Config.fromString(file.readAsStringSync());
    cache
      .._gtkConfig = config
      .._gtkConfigHome = home
      .._gtkConfigVersion = gtkVersion;
    return config;
  } on Exception catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Icon lookup API
// ---------------------------------------------------------------------------
Future<IconRef?> findIcon(
  String? icon,
  List<String> directories, {
  int size = 16,
  int scale = 1,
  bool persistCache = false,
  bool findClosest = false,
}) async {
  if (findClosest) {
    return await Isolate.run(
      () => _findIcon(
        icon,
        directories,
        size: size,
        scale: scale,
        persistCache: persistCache,
        findClosest: findClosest,
      ),
    );
  }
  return await _findIcon(
    icon,
    directories,
    size: size,
    scale: scale,
    persistCache: persistCache,
    findClosest: findClosest,
  );
}

Future<IconRef?> _findIcon(
  String? icon,
  List<String> directories, {
  int size = 16,
  int scale = 1,
  bool persistCache = false,
  bool findClosest = false,
}) async {
  if (icon == null || icon.isEmpty) return null;

  if ((icon.startsWith('/') || icon.startsWith('~')) &&
      File(icon).existsSync()) {
    return IconRef(name: icon, path: icon);
  }

  final settings = await getThemeSettings(persistCache: persistCache);

  final filename = await _findIconHelper(
    icon,
    directories,
    size,
    scale,
    settings.iconTheme,
    settings,
    findClosest: findClosest,
  );
  if (filename != null) return IconRef(name: icon, path: filename);

  if (settings.iconTheme != 'hicolor') {
    final filenameHicolor = await _findIconHelper(
      icon,
      directories,
      size,
      scale,
      'hicolor',
      settings,
      findClosest: findClosest,
    );
    if (filenameHicolor != null) {
      return IconRef(name: icon, path: filenameHicolor);
    }
  }

  return null;
}

const _iconExtensions = ['.png', '.svg', '.xpm'];

String? _lookupFallbackIcon(
  List<String> directories,
  String theme,
  String iconLower,
) {
  for (final directory in directories) {
    final themeDir = Directory('$directory/$theme');
    if (themeDir.existsSync()) continue;

    final filesMap = _getDirectoryFiles(directory);

    for (final ext in _iconExtensions) {
      final key = '$iconLower$ext';
      if (filesMap.containsKey(key)) return filesMap[key];
    }
  }
  return null;
}

Future<String?> _findIconHelper(
  String icon,
  List<String> directories,
  int size,
  int scale,
  String theme,
  ThemeSettings settings, {
  bool isParentSearch = false,
  Set<String>? visitedThemes,
  bool findClosest = false,
}) async {
  visitedThemes ??= {};
  final themeContextKey = '$theme|$icon';
  if (visitedThemes.contains(themeContextKey)) return null;
  visitedThemes.add(themeContextKey);

  final userSelectedTheme = _getThemeConfig(theme, directories);

  if (userSelectedTheme != null) {
    final filename = _lookupIcon(
      icon,
      directories,
      size,
      scale,
      theme,
      userSelectedTheme,
      settings,
      findClosest: findClosest,
    );
    if (filename != null) return filename;

    if (!isParentSearch) {
      final parents = _getThemeParents(userSelectedTheme);
      if (parents != null) {
        for (final parent in parents) {
          final parentFilename = await _findIconHelper(
            icon,
            directories,
            size,
            scale,
            parent,
            settings,
            isParentSearch: true,
            visitedThemes: visitedThemes,
            findClosest: findClosest,
          );
          if (parentFilename != null) return parentFilename;
        }
      }
    }
  }

  if (isParentSearch) {
    return _lookupFallbackIcon(directories, theme, icon.toLowerCase());
  }

  return null;
}

List<String>? _getThemeParents(Config userSelectedTheme) {
  final cache = IconCache.instance;
  final theme = userSelectedTheme.get('Icon Theme', 'Name');

  if (theme != null && cache._themeParents.containsKey(theme)) {
    return cache._themeParents[theme];
  }

  final inheritsRaw = userSelectedTheme.get('Icon Theme', 'Inherits');
  final parents = inheritsRaw?.split(',').map((e) => e.trim()).toList();

  if (theme != null) cache._themeParents[theme] = parents;
  return parents;
}

String? _lookupIcon(
  String iconName,
  List<String> directories,
  int size,
  int scale,
  String theme,
  Config userSelectedTheme,
  ThemeSettings settings, {
  bool findClosest = false,
}) {
  final themeName = userSelectedTheme.get('Icon Theme', 'Name') ?? theme;
  final cacheKey = '$themeName|$iconName|$size|$scale';
  final cache = IconCache.instance;

  if (cache.hasIcon(cacheKey)) return cache.getIcon(cacheKey);

  final result = _lookupIconSync(
    iconName,
    directories,
    theme,
    size,
    scale,
    userSelectedTheme,
    settings,
    findClosest: findClosest,
  );
  cache.putIcon(cacheKey, result);
  return result;
}

bool _sectionMatchesSize(String section, int size, int scale, Config config) {
  if (section == 'Icon Theme') return false;
  final options = config.options(section) ?? [];
  if (options.contains('Scale')) {
    final configScale = int.tryParse(config.get(section, 'Scale') ?? '') ?? 1;
    if (configScale != scale) return false;
  }
  final configSize = int.tryParse(config.get(section, 'Size') ?? '');
  if (configSize == null) return false;

  final configType = config.get(section, 'Type') ?? 'Threshold';

  if (configType == 'Fixed') return configSize == size;
  if (configType == 'Scalable') {
    final minSize =
        int.tryParse(config.get(section, 'MinSize') ?? configSize.toString()) ??
        configSize;
    final maxSize =
        int.tryParse(config.get(section, 'MaxSize') ?? configSize.toString()) ??
        configSize;
    return size >= minSize && size <= maxSize;
  }
  if (configType == 'Threshold') {
    final threshold =
        int.tryParse(config.get(section, 'Threshold') ?? '2') ?? 2;
    return size >= (configSize - threshold) && size <= (configSize + threshold);
  }
  return false;
}

int _sectionSizeDistance(String section, int size, int scale, Config config) {
  if (section == 'Icon Theme') return 999999;
  final configSize = int.tryParse(config.get(section, 'Size') ?? '');
  final configScale = int.tryParse(config.get(section, 'Scale') ?? '') ?? 1;

  if (configSize == null) return 999999;

  final sizeScaled = size * scale;
  final configSizeScaled = configSize * configScale;
  final configType = config.get(section, 'Type') ?? 'Threshold';

  if (configType == 'Fixed') return (configSizeScaled - sizeScaled).abs();

  if (configType == 'Scalable') {
    final minSize =
        int.tryParse(config.get(section, 'MinSize') ?? '') ?? configSize;
    final maxSize =
        int.tryParse(config.get(section, 'MaxSize') ?? '') ?? configSize;
    final minSizeScaled = minSize * configScale;
    final maxSizeScaled = maxSize * configScale;
    if (sizeScaled < minSizeScaled) return minSizeScaled - sizeScaled;
    if (sizeScaled > maxSizeScaled) return sizeScaled - maxSizeScaled;
    return 0;
  }

  if (configType == 'Threshold') {
    final threshold =
        int.tryParse(config.get(section, 'Threshold') ?? '2') ?? 2;
    final thresholdScaled = threshold * configScale;
    if (sizeScaled < (configSizeScaled - thresholdScaled)) {
      return configSizeScaled - sizeScaled;
    }
    if (sizeScaled > (configSizeScaled + thresholdScaled)) {
      return sizeScaled - configSizeScaled;
    }
    return 0;
  }
  return 999999;
}

String? _lookupIconSync(
  String iconName,
  List<String> directories,
  String theme,
  int size,
  int scale,
  Config userSelectedTheme,
  ThemeSettings settings, {
  bool findClosest = false,
}) {
  final allSections = userSelectedTheme.sections().toList();
  final iconLower = iconName.toLowerCase();

  final matchingSections = allSections.where(
    (s) => _sectionMatchesSize(s, size, scale, userSelectedTheme),
  );

  for (final section in matchingSections) {
    for (final baseDir in directories) {
      final filesMap = _getDirectoryFiles('$baseDir/$theme/$section');
      for (final ext in _iconExtensions) {
        if (filesMap.containsKey('$iconLower$ext')) {
          return filesMap['$iconLower$ext'];
        }
      }
    }
  }

  if (findClosest) {
    final validSections = allSections.where((s) => s != 'Icon Theme').toList()
      ..sort((a, b) {
        final distA = _sectionSizeDistance(a, size, scale, userSelectedTheme);
        final distB = _sectionSizeDistance(b, size, scale, userSelectedTheme);
        return distA.compareTo(distB);
      });

    for (final section in validSections) {
      for (final baseDir in directories) {
        final filesMap = _getDirectoryFiles('$baseDir/$theme/$section');
        for (final ext in _iconExtensions) {
          if (filesMap.containsKey('$iconLower$ext')) {
            return filesMap['$iconLower$ext'];
          }
        }
      }
    }
  }
  return null;
}

Future<void> main() async {
  final directories = getDefaultIconDirectories();
  final stopwatch = Stopwatch()..start();

  final results = await Future.wait([
    findIcon('alacritty', directories, size: 64),
    findIcon('io.mpv.Mpv', directories, size: 64),
    findIcon('qBittorrent', directories, size: 64),
    findIcon('pavucontrol', directories, size: 64),
    findIcon('vscodium', directories, size: 64),
    findIcon('wcm', directories, size: 64),
    findIcon('glade', directories, size: 64),
    findIcon('io.github.prateekmedia.appimagepool', directories, size: 64),
    findIcon('com.supermodel3.Supermodel', directories, size: 64),
    findIcon(
      'com.supermodel3.Supermodel',
      directories,
      size: 64,
      findClosest: true,
    ),
  ]);

  stopwatch.stop();

  for (final res in results) {
    stdout.write('${res?.name} -> ${res?.path}\n');
  }
  stdout.write('\nTemps total : ${stopwatch.elapsedMilliseconds}ms\n');
}
