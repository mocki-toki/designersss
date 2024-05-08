// GENERATED FILE. DO NOT MODIFY.
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'ru.g.dart';
part 'en.g.dart';

abstract final class MainAppLocalizationData {
  String get collectionTitle;
  String get interfacesTitle;
  String get bookmarksTitle;
  String get settingsTitle;
  String get inDevelopment;

  Map<String, String> get map;
}

final class MainAppLocalizations {
  static const _MainAppLocalizationsDelegate delegate =
      _MainAppLocalizationsDelegate();

  static MainAppLocalizationData of(BuildContext context) {
    return Localizations.of<MainAppLocalizationData>(
      context,
      MainAppLocalizationData,
    )!;
  }

  static const List<Locale> supportedLocales = [Locale('ru'), Locale('en')];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    MainAppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

final class _MainAppLocalizationsDelegate
    extends LocalizationsDelegate<MainAppLocalizationData> {
  const _MainAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      MainAppLocalizations.supportedLocales.contains(locale);

  @override
  Future<MainAppLocalizationData> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ru':
        return const RuMainAppLocalizationData();
      case 'en':
        return const EnMainAppLocalizationData();
      default:
        return const RuMainAppLocalizationData();
    }
  }

  @override
  bool shouldReload(_MainAppLocalizationsDelegate old) => false;
}

extension MainAppLocalizationsExtension on BuildContext {
  MainAppLocalizationData get mainAppLocalizations =>
      MainAppLocalizations.of(this);
}

