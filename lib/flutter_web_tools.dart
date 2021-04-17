import 'dart:io';

import 'package:yaml/yaml.dart' as yaml;

appendVersion({
  String directory,
  String buildDirectory,
}) {
  File pubspecFile = File("$directory/pubspec.yaml");
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
  );
}

appendBuildID({
  String buildDirectory,
}) {
  String buildID = File("$buildDirectory/.last_build_id").readAsStringSync();

  appendString(
    buildDirectory: buildDirectory,
    versionIdentifier: buildID,
  );
}

appendString({String buildDirectory, String versionIdentifier}) {
  File indexFile = File("$buildDirectory/index.html");

  indexFile.writeAsStringSync(indexFile.readAsStringSync().replaceAll(
      RegExp(r'src="main\.dart\.js(\?v=\w*)?"'),
      "src=\"main.dart.js?v=$versionIdentifier\""));

  File mainDartFile = File("$buildDirectory/main.dart.js");
  mainDartFile.writeAsStringSync(mainDartFile.readAsStringSync().replaceAll(
      RegExp(r'"/version.json(\?v=\w*)?"'),
      "\"/version.json?v=$versionIdentifier\""));
}
