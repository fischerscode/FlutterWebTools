import 'dart:io';

import 'package:file/file.dart';
import 'package:yaml/yaml.dart' as yaml;

appendVersion({
  required String directory,
  required String buildDirectory,
  required FileSystem fileSystem,
}) {
  File pubspecFile = fileSystem.file("$directory/pubspec.yaml");
  Map pubspec = yaml.loadYaml(pubspecFile.readAsStringSync());

  if (pubspec["version"] == null) {
    stderr.writeln("No version specified in ${pubspecFile.path}");
    exit(1);
  }

  List<String> version = pubspec["version"].toString().split("+");

  if (version.length != 2) {
    stderr.writeln(
        "The version is not properly specified in ${pubspecFile.path}.");
    exit(1);
  }

  int versionCounter = int.parse(version[1]) + 0;

  appendString(
    buildDirectory: buildDirectory,
    versionIdentifier: versionCounter.toString(),
    fileSystem: fileSystem,
  );
}

appendBuildID({
  required String buildDirectory,
  required FileSystem fileSystem,
}) {
  String buildID =
      fileSystem.file("$buildDirectory/.last_build_id").readAsStringSync();

  appendString(
    buildDirectory: buildDirectory,
    versionIdentifier: buildID,
    fileSystem: fileSystem,
  );
}

appendString({
  required String buildDirectory,
  required String versionIdentifier,
  required FileSystem fileSystem,
}) {
  File indexFile = fileSystem.file("$buildDirectory/index.html");

  indexFile.writeAsStringSync(indexFile.readAsStringSync().replaceAll(
      RegExp(r'src="main\.dart\.js(\?v=\w*)?"'),
      "src=\"main.dart.js?v=$versionIdentifier\""));

  File mainDartFile = fileSystem.file("$buildDirectory/main.dart.js");
  mainDartFile.writeAsStringSync(mainDartFile.readAsStringSync().replaceAll(
      RegExp(r'"/version.json(\?v=\w*)?"'),
      "\"/version.json?v=$versionIdentifier\""));
}
