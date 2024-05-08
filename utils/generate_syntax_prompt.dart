// // ignore_for_file: avoid_print

// import 'dart:io';

// void main() async {
//   final projectPath = Directory.current.path;
//   final outputFile = File('project_syntax.txt');
//   final sink = outputFile.openWrite();

//   final allDartFiles = await getAllDartFiles(projectPath);
//   print('Total Dart files to process: ${allDartFiles.length}');
//   final progressBar = ProgressBar(complete: allDartFiles.length);

//   for (final filePath in allDartFiles) {
//     progressBar.update(progressBar.current + 1, filePath);
//     await analyzeDartFile(filePath, sink);
//   }

//   await sink.close();
//   print('Syntax analysis completed. Output written to project_syntax.txt');
// }

// class ProgressBar {
//   final int complete;
//   int _current = 0;

//   ProgressBar({required this.complete});

//   int get current => _current;

//   void update(int current, String filePath) {
//     _current = current;
//     var progress = (_current / complete * 100).toStringAsFixed(1);
//     stdout.write('\x1B[2K'); // Clear the current line
//     stdout.write('\rProcessing: $progress% complete [$filePath]');
//     if (_current == complete) {
//       print('\n'); // Move to next line after completion
//     }
//   }
// }

// Future<List<String>> getAllDartFiles(String rootPath) async {
//   final excludeFoldersAndFiles = [
//     '.dart_tool',
//     'macos',
//     'build',
//     'ios',
//     'android',
//     'web',
//     'linux',
//     'windows',
//     'utils',
//     'domain.dart',
//     'infrastructure.dart',
//     'presentation.dart',
//     'exports.dart',
//     'test.dart',
//     '.dart_frog',
//     '_middleware.dart',
//     '.g.dart'
//   ];

//   List<String> dartFiles = [];
//   await for (var entity
//       in Directory(rootPath).list(recursive: true, followLinks: false)) {
//     if (entity is File && entity.path.endsWith('.dart')) {
//       var exclude = false;
//       for (var excludeItem in excludeFoldersAndFiles) {
//         if (entity.path.contains(excludeItem)) {
//           exclude = true;
//           break;
//         }
//       }
//       if (!exclude) {
//         dartFiles.add(entity.path);
//       }
//     }
//   }
//   return dartFiles;

// }

// ignore_for_file: avoid_print
import 'dart:io';

Future<void> main() async {
  final projectPath = Directory.current.path;
  final excludeFoldersAndFiles = [
    '.dart_tool',
    'macos',
    'build',
    'ios',
    'android',
    'web',
    'linux',
    'windows',
    'utils',
    'domain.dart',
    'infrastructure.dart',
    'presentation.dart',
    'exports.dart',
    'test.dart',
    '.dart_frog'
  ];
  final outputFile = File('project_syntax.txt');
  final sink = outputFile.openWrite();
  await processDirectory(Directory(projectPath), excludeFoldersAndFiles, sink);
  sink.close();
  print('Syntax prompt generated in project_syntax.txt');
}

Future<void> processDirectory(Directory directory,
    List<String> excludeFoldersAndFiles, IOSink sink) async {
  final entities = directory.listSync(recursive: false);
  for (final entity in entities) {
    if (entity is File) {
      final fileName = entity.path.split('/').last;
      if (excludeFoldersAndFiles.any((e) => fileName.endsWith(e))) continue;
      if (fileName.endsWith('pubspec.yaml')) {
        final relativePath = entity.path.replaceAll(Directory.current.path, '');
        final content = entity.readAsStringSync();
        sink.writeln('File: $relativePath');
        sink.writeln('Content:');
        sink.writeln('```yaml');
        sink.writeln(content);
        sink.writeln('```');
        sink.writeln();
      }
      if (entity.path.endsWith('.dart')) {
        final relativePath = entity.path.replaceAll(Directory.current.path, '');
        var content = entity.readAsStringSync();

        // Remove import statements
        content = content.replaceAllMapped(
          RegExp(r'^import\s+.*?;$', multiLine: true),
          (match) => '',
        );

        // Remove function bodies
        final lines = content.split('\n');
        final stack = <int>[];
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.contains('{')) {
            stack.add(i);
          } else if (line.contains('}')) {
            if (stack.isNotEmpty) {
              final startIndex = stack.removeLast();
              if (stack.isEmpty) {
                lines[startIndex] =
                    lines[startIndex].replaceFirst('{', '{...}');
                for (var j = startIndex + 1; j < i; j++) {
                  lines[j] = '';
                }
              }
            }
          }
        }
        content = lines.join('\n');

        sink.writeln('File: $relativePath');
        sink.writeln('Content:');
        sink.writeln('```dart');
        sink.writeln(content.trim());
        sink.writeln('```');
        sink.writeln();
        await sink.flush();
      }
    } else if (entity is Directory) {
      final folderName = entity.path.split('/').last;
      if (!excludeFoldersAndFiles.contains(folderName)) {
        processDirectory(entity, excludeFoldersAndFiles, sink);
      }
    }
  }
}
