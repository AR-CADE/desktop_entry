# desktop_entry

A Dart library that implements the freedesktop [Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry/latest/).

# (re)generate serializers

run:

```$ dart run build_runner build -r```

# current test coverage

[![screenshot](https://github.com/AR-CADE/desktop_entry/raw/main/assets/screenshot-coverage.png?raw=true "coverage")](https://github.com/AR-CADE/desktop_entry/raw/main/assets/screenshot-coverage.png?raw=true)
 
to generate this html report, first install [`lcov`](https://github.com/linux-test-project/lcov), then run:

```

$ dart test --coverage-path=coverage/lcov.info

$ genhtml coverage/lcov.info -o coverage/html

$ open coverage/html/index.html

```

# note

 - As for now, only the type 1 (Application) is fully implemented
 - type 2 (Link) and type 3 (Directory) are partially implemented
 

# contact

arm-cade@proton.me