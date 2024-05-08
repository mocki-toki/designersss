// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

String _snakeToUpperCamel(String input) {
  final parts = input.split('_');
  final result = StringBuffer();
  for (final part in parts) {
    result.write(part[0].toUpperCase() + part.substring(1));
  }
  return result.toString();
}

String _snakeToLowerCamel(String input) {
  final parts = input.split('_');
  final result = StringBuffer();
  for (var i = 0; i < parts.length; i++) {
    if (i == 0) {
      result.write(parts[i]);
    } else {
      result.write(parts[i][0].toUpperCase() + parts[i].substring(1));
    }
  }
  return result.toString();
}

void generateLocalizations() {
  for (final directory in Directory('.')
      .listSync(recursive: true)
      .whereType<Directory>()
      .where((e) =>
          e.path.contains('assets/locales') && !e.path.contains('build'))) {
    final packageName =
        directory.path.replaceFirst('/assets/locales', '').split('/').last;

    print('Generating localizations for $packageName...');

    final presentationDirectory = Directory(directory.path
        .replaceAll('assets/locales', 'lib/presentation/localizations'))
      ..createSync(recursive: true);

    final files = directory
        .listSync()
        .whereType<File>()
        .where((e) => e.path.endsWith('.json'));

    final localizationKeys = <String, List<String>>{};

    void generateLocalization(final File file) {
      final fileName = file.path.split('/').last;
      final locale = fileName.split('.').first;
      final Map<String, dynamic> map = json.decode(file.readAsStringSync());

      final buffer = StringBuffer();

      buffer.writeln(
        '// GENERATED FILE. DO NOT MODIFY.\n\n'
        'part of \'localizations.g.dart\';\n\n'
        'final class ${_snakeToUpperCamel(locale)}${_snakeToUpperCamel(packageName)}LocalizationData implements ${_snakeToUpperCamel(packageName)}LocalizationData {\n'
        '  const ${_snakeToUpperCamel(locale)}${_snakeToUpperCamel(packageName)}LocalizationData();\n',
      );

      for (final key in map.keys) {
        if (map[key].toString().contains('{')) {
          final placeholders = RegExp(r'{(.*?)}').allMatches(map[key]);
          final placeholderNames = placeholders
              .map((e) => e.group(1))
              .map((e) => e!.replaceAll(RegExp(r'\W'), ''))
              .toList();

          var value = map[key].toString();
          for (final placeholder in placeholderNames) {
            value = value.replaceAll('{$placeholder}', '\$$placeholder');
          }

          localizationKeys[key] = placeholderNames;

          buffer.writeln(
            '  @override\n'
            '  String ${_snakeToLowerCamel(key)}(${placeholderNames.map((e) => 'String $e').join(', ')}) => '
            '\'$value\';',
          );
        } else {
          localizationKeys[key] = [];
          buffer.writeln(
            '  @override\n'
            '  String get ${_snakeToLowerCamel(key)} => r\'${map[key]}\';',
          );
        }
      }

      buffer.writeln('\n  @override\n  Map<String, String> get map => {');
      for (final key in map.keys) {
        buffer.writeln('        \'$key\': r\'${map[key]}\',');
      }

      buffer.writeln('      };\n}');

      File('${presentationDirectory.path}/$locale.g.dart')
          .writeAsStringSync(buffer.toString(), mode: FileMode.writeOnly);
    }

    void generateInterfaceAndManager() {
      final buffer = StringBuffer();

      buffer.writeln(
        '// GENERATED FILE. DO NOT MODIFY.\n// ignore_for_file: library_private_types_in_public_api\n\n'
        'import \'package:flutter/widgets.dart\';\n'
        'import \'package:flutter_localizations/flutter_localizations.dart\';\n',
      );

      for (final file in files) {
        final fileName = file.path.split('/').last;
        final locale = fileName.split('.').first;
        buffer.writeln(
          'part \'$locale.g.dart\';',
        );
      }

      buffer.writeln(
          '\nabstract final class ${_snakeToUpperCamel(packageName)}LocalizationData {');
      for (final entry in localizationKeys.entries) {
        if (entry.value.isNotEmpty) {
          buffer.writeln(
            '  String ${_snakeToLowerCamel(entry.key)}(${entry.value.map((e) => 'String $e').join(', ')});',
          );
        } else {
          buffer.writeln(
            '  String get ${_snakeToLowerCamel(entry.key)};',
          );
        }
      }
      buffer.writeln(
        '\n  Map<String, String> get map;\n'
        '}\n\n'
        'final class ${_snakeToUpperCamel(packageName)}Localizations {\n'
        '  static const _${_snakeToUpperCamel(packageName)}LocalizationsDelegate delegate =\n'
        '      _${_snakeToUpperCamel(packageName)}LocalizationsDelegate();\n\n'
        '  static ${_snakeToUpperCamel(packageName)}LocalizationData of(BuildContext context) {\n'
        '    return Localizations.of<${_snakeToUpperCamel(packageName)}LocalizationData>(\n'
        '      context,\n'
        '      ${_snakeToUpperCamel(packageName)}LocalizationData,\n'
        '    )!;\n'
        '  }\n\n'
        '  static const List<Locale> supportedLocales = ['
        '${files.map((e) => 'Locale(\'${e.path.split('/').last.split('.').first}\')').join(', ')}'
        '];\n\n'
        '  static const List<LocalizationsDelegate> localizationsDelegates = [\n'
        '    ${_snakeToUpperCamel(packageName)}Localizations.delegate,\n'
        '    GlobalMaterialLocalizations.delegate,\n'
        '    GlobalCupertinoLocalizations.delegate,\n'
        '    GlobalWidgetsLocalizations.delegate,\n'
        '  ];\n'
        '}\n\n'
        'final class _${_snakeToUpperCamel(packageName)}LocalizationsDelegate\n'
        '    extends LocalizationsDelegate<${_snakeToUpperCamel(packageName)}LocalizationData> {\n'
        '  const _${_snakeToUpperCamel(packageName)}LocalizationsDelegate();\n\n'
        '  @override\n'
        '  bool isSupported(Locale locale) =>\n'
        '      ${_snakeToUpperCamel(packageName)}Localizations.supportedLocales.contains(locale);\n\n'
        '  @override\n'
        '  Future<${_snakeToUpperCamel(packageName)}LocalizationData> load(Locale locale) async {\n'
        '    switch (locale.languageCode) {\n'
        '${files.map((e) => '      case \'${e.path.split('/').last.split('.').first}\':\n'
            '        return const ${_snakeToUpperCamel(e.path.split('/').last.split('.').first)}${_snakeToUpperCamel(packageName)}LocalizationData();').join('\n')}\n'
        '      default:\n'
        '        return const ${_snakeToUpperCamel(files.first.path.split('/').last.split('.').first)}${_snakeToUpperCamel(packageName)}LocalizationData();\n'
        '    }\n'
        '  }\n\n'
        '  @override\n'
        '  bool shouldReload(_${_snakeToUpperCamel(packageName)}LocalizationsDelegate old) => false;\n'
        '}\n\n'
        'extension ${_snakeToUpperCamel(packageName)}LocalizationsExtension on BuildContext {\n'
        '  ${_snakeToUpperCamel(packageName)}LocalizationData get ${_snakeToLowerCamel(packageName)}Localizations =>\n'
        '      ${_snakeToUpperCamel(packageName)}Localizations.of(this);\n'
        '}\n',
      );

      File('${presentationDirectory.path}/localizations.g.dart')
          .writeAsStringSync(buffer.toString());
    }

    for (final file in files) {
      generateLocalization(file);
    }

    generateInterfaceAndManager();
  }
}

void main() {
  generateLocalizations();
}
