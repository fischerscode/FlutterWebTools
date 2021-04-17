import 'dart:io';

import 'package:args/args.dart';
import 'package:file/local.dart';
import 'package:flutter_web_tools/flutter_web_tools.dart' as flutter_web_tools;

void main(List<String> arguments) {
  ArgParser parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      defaultsTo: false,
      help: "Show the help text.",
      negatable: false,
    )
    ..addOption(
      "dir",
      abbr: "d",
      help: "The directory of your web project.",
      defaultsTo: ".",
    )
    ..addOption(
      "build-dir",
      abbr: "b",
      help: "The directory of your build web project.",
      defaultsTo: "./build/web",
    )
    ..addFlag(
      'append-version',
      abbr: 'V',
      defaultsTo: false,
      help:
          "Append the build number to queried file names in order to prevent caching of old versions.",
    )
    ..addFlag(
      "append-buildID",
      abbr: "B",
      defaultsTo: false,
      help:
          "Append the build ID (.last_build_id) to queried file names in order to prevent caching of old versions.",
    );

  ArgResults argResults = parser.parse(arguments);
  parser.usage;
  if (argResults["help"] || argResults.arguments.length == 0) {
    stdout.writeln(parser.usage);
    exit(0);
  }

  if (argResults["append-version"]) {
    if (argResults["dir"] == null || argResults["build-dir"] == null) {
      stderr.writeln(
          "You have to specify the directory and the build directory.");
      exit(1);
    } else {
      flutter_web_tools.appendVersion(
        directory: argResults["dir"],
        buildDirectory: argResults["build-dir"],
        fileSystem: LocalFileSystem(),
      );
    }
  }

  if (argResults["append-buildID"]) {
    if (argResults["build-dir"] == null) {
      stderr.writeln("You have to specify the build directory.");
      exit(1);
    } else {
      flutter_web_tools.appendBuildID(
        buildDirectory: argResults["build-dir"],
        fileSystem: LocalFileSystem(),
      );
    }
  }
}
