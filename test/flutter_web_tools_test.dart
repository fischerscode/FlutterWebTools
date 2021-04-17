import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_web_tools/flutter_web_tools.dart' as flutter_web_tools;
import 'package:test/test.dart';

void main() {
  test('appendVersion', () {
    FileSystem fileSystem = MemoryFileSystem();

    fileSystem.directory("build").createSync();
    fileSystem.directory("build/web").createSync();

    fileSystem.file("pubspec.yaml").writeAsStringSync("version: 1.2.3+4");
    fileSystem.file("build/web/index.html").writeAsStringSync("""
      <script src="main.dart.js" type="application/javascript"></script>
      <script src="main.dart.js?v=123" type="application/javascript"></script>
      <script src="main.dart.js?v=abcABZ123" type="application/javascript"></script>
    """);
    fileSystem.file("build/web/main.dart.js").writeAsStringSync("""
    somestuff"/version.json"otherstuff
    somestuff"/version.json?v=123"otherstuff
    somestuff"/version.json?v=abcABZ123"otherstuff
    """);

    flutter_web_tools.appendVersion(
      buildDirectory: "build/web",
      directory: ".",
      fileSystem: fileSystem,
    );

    expect("""
      <script src="main.dart.js?v=4" type="application/javascript"></script>
      <script src="main.dart.js?v=4" type="application/javascript"></script>
      <script src="main.dart.js?v=4" type="application/javascript"></script>
    """, fileSystem.file("build/web/index.html").readAsStringSync());

    expect("""
    somestuff"/version.json?v=4"otherstuff
    somestuff"/version.json?v=4"otherstuff
    somestuff"/version.json?v=4"otherstuff
    """, fileSystem.file("build/web/main.dart.js").readAsStringSync());
  });

  test('appendBuildID', () {
    FileSystem fileSystem = MemoryFileSystem();

    fileSystem.directory("build").createSync();
    fileSystem.directory("build/web").createSync();

    fileSystem
        .file("build/web/.last_build_id")
        .writeAsStringSync("fe6bfbb7c2e4d1f29837df2d7a1ea628");
    fileSystem.file("build/web/index.html").writeAsStringSync("""
      <script src="main.dart.js" type="application/javascript"></script>
      <script src="main.dart.js?v=123" type="application/javascript"></script>
      <script src="main.dart.js?v=abcABZ123" type="application/javascript"></script>
    """);
    fileSystem.file("build/web/main.dart.js").writeAsStringSync("""
    somestuff"/version.json"otherstuff
    somestuff"/version.json?v=123"otherstuff
    somestuff"/version.json?v=abcABZ123"otherstuff
    """);

    flutter_web_tools.appendBuildID(
      buildDirectory: "build/web",
      fileSystem: fileSystem,
    );

    expect("""
      <script src="main.dart.js?v=fe6bfbb7c2e4d1f29837df2d7a1ea628" type="application/javascript"></script>
      <script src="main.dart.js?v=fe6bfbb7c2e4d1f29837df2d7a1ea628" type="application/javascript"></script>
      <script src="main.dart.js?v=fe6bfbb7c2e4d1f29837df2d7a1ea628" type="application/javascript"></script>
    """, fileSystem.file("build/web/index.html").readAsStringSync());

    expect("""
    somestuff"/version.json?v=fe6bfbb7c2e4d1f29837df2d7a1ea628"otherstuff
    somestuff"/version.json?v=fe6bfbb7c2e4d1f29837df2d7a1ea628"otherstuff
    somestuff"/version.json?v=fe6bfbb7c2e4d1f29837df2d7a1ea628"otherstuff
    """, fileSystem.file("build/web/main.dart.js").readAsStringSync());
  });
}
