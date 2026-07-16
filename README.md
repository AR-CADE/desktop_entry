# desktop_entry

A Dart library that implements the [Freedesktop Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry/latest/).

# (re)generate serializers

run:

```$ dart run build_runner build -r```

# current test coverage

[![screenshot](https://github.com/AR-CADE/desktop_entry/raw/main/assets/screenshot-coverage.png?raw=true "coverage")](https://github.com/AR-CADE/desktop_entry/raw/main/assets/screenshot-coverage.png?raw=true)
 
to generate this html report, first install `lcov`, then run:

```

$ dart test --coverage=coverage

$ genhtml coverage/lcov.info -o coverage/html

$ open coverage/html/index.html

```

# note

 - As for now, only the "application" type is fully implemented

# contact

arm-cade@proton.me