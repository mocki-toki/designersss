import 'dart:io';

void addExportFile(Directory dir) {
  var f = File('${dir.parent.path}/${basename(dir.path)}.dart');
  if (f.existsSync()) {
    f.deleteSync();
  }
  var sink = f.openWrite();
  sink.write('// GENERATED FILE: DO NOT MODIFY\n\n');

  var files = dir.listSync(recursive: true).where((entity) {
    return entity.path.endsWith('.dart') &&
        !entity.path.endsWith('.g.dart') &&
        !entity.path.endsWith('.gr.dart') &&
        !basename(entity.path).startsWith('_') &&
        !basename(entity.path).contains('/_');
  });

  for (var file in files) {
    var fileName = basename(file.path);
    if (fileName != '${basename(dir.path)}.dart') {
      var relativePath = file.path.substring(dir.parent.path.length + 1);
      sink.write('export \'$relativePath\';\n');
    }
  }

  sink.close();
}

// Возвращает базовое имя пути.
String basename(String path) {
  return path.split('/').last;
}

bool _isCreating = false;

void generateIndexes() {
  if (_isCreating) return;
  _isCreating = true;

  const directoryNames = ['domain', 'infrastructure', 'presentation'];

  for (var dirName in directoryNames) {
    Directory('./').listSync(recursive: true).forEach((entity) {
      if (entity is Directory && basename(entity.path) == dirName) {
        addExportFile(entity);
      }
    });
  }

  _isCreating = false;
}

void main() {
  generateIndexes();
}
