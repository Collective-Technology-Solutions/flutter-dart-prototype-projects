##  dart-http-fetch: terminal example of fetching JSON and pretty printing to console output

# GOAL(S)
- show how to fetching data froma RESTful endpoint
- show exception catch and log
- show retry logic

# TODO(S)
- refine retry logic into a function/lambda
- externalize logging solution for reuse


# DISCOVERIES
- if importing packages, to run dart programs from a terminal, you need a pubspec.yaml with the dependancy entreis
- pubspec.yaml needs a name entry
- check fori/address issues:
```
dart analyze
dart fix
```
- to investigate more:
```
dart compile wasm main.dart
```


# TO PREPARE
```dart
dart pub get
```

# TO RUN
```dart
dart main.dart 
```
or
```dart
dart run main.dart
```

