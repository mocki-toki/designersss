// ignore_for_file: avoid_print

import 'dart:io';

void main() {
  final projectPath = Directory.current.path;
  final excludeFolders = [
    '.dart_tool',
    'macos',
    'build',
    'ios',
    'android',
    'web',
    'linux',
    'windows',
    'utils'
  ];

  final outputFile = File('project_files.txt');
  final sink = outputFile.openWrite();

  processDirectory(Directory(projectPath), excludeFolders, sink);

  sink.close();
  print('Full prompt generated in project_files.txt');
}

void processDirectory(
    Directory directory, List<String> excludeFolders, IOSink sink) {
  final entities = directory.listSync(recursive: false);

  for (final entity in entities) {
    if (entity is File) {
      final fileName = entity.path;
      if (fileName.endsWith('.dart') || fileName.endsWith('pubspec.yaml')) {
        final relativePath = entity.path.replaceAll(Directory.current.path, '');
        final content = entity.readAsStringSync();

        sink.writeln('File: $relativePath');
        sink.writeln('Content:');
        sink.writeln('```');
        sink.writeln(content);
        sink.writeln('```');
        sink.writeln();
      }
    } else if (entity is Directory) {
      final folderName = entity.path.split('/').last;
      if (!excludeFolders.contains(folderName)) {
        processDirectory(entity, excludeFolders, sink);
      }
    }
  }
}
