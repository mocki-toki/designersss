// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

bool isReplacing = false;

void replaceContent(File file) async {
  if (!isReplacing) {
    isReplacing = true;
    try {
      int lineIndex = -1;

      final replaces = <int, String>{};
      await for (final line in file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        lineIndex++;
        if (line == '') continue;
        if (line.contains(RegExp(r"^import"))) {
          final layers = ['domain', 'infrastructure', 'presentation'];
          for (final layer in layers) {
            if (line.contains(layer)) {
              final newLine = line.replaceAll(
                RegExp(r"\/" + layer + r"\/.*';"),
                "/$layer.dart';",
              );

              if (newLine != line) replaces[lineIndex] = newLine;
            }
          }
        } else {
          break;
        }
      }

      final keys = replaces.keys.toList();
      for (final key in keys) {
        if (replaces[key] == replaces[key - 1]) {
          replaces.remove(key);
        }
      }

      if (replaces.isNotEmpty) {
        final lines = await file.readAsLines();
        for (final replace in replaces.entries) {
          print('Replaced: ${lines[replace.key]} to ${replace.value})');
          lines[replace.key] = replace.value;
        }
        await file.writeAsString(lines.join('\n'));
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isReplacing = false;
    }
  }
}

// void main() {
//   print('Watching...');
//   Directory('../')
//       .watch(recursive: true, events: FileSystemEvent.modify)
//       .listen((event) {
//     if (event.path.endsWith('.dart')) {
//       final file = File(event.path);
//       replaceContent(file);
//     }
//   });
// }

// without watching
void main() async {
  print('Replacing...');
  final files = Directory('./').listSync(recursive: true).whereType<File>();
  for (final file in files) {
    if (file.path.endsWith('.dart')) {
      replaceContent(file);
    }
  }
}
