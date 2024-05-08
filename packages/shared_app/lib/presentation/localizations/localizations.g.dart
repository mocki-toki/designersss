// GENERATED FILE. DO NOT MODIFY.
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'ru.g.dart';
part 'en.g.dart';

abstract final class SharedAppLocalizationData {
  String get languageName;
  String get unknownServerError;
  String get networkError;
  String get unknownError;
  String get email;
  String get password;
  String get authorization;
  String get signIn;
  String get signOut;
  String get fillAllFieldsError;
  String get linkTypeVideo;
  String get linkTypeStartup;
  String get linkTypeUtility;
  String get linkTypeSite;
  String get linkTypeArticle;
  String get linkTypeCases;
  String get linkTypeVideoMultiple;
  String get linkTypeStartupMultiple;
  String get linkTypeUtilityMultiple;
  String get linkTypeSiteMultiple;
  String get linkTypeArticleMultiple;
  String get linkTypeCasesMultiple;

  Map<String, String> get map;
}

final class SharedAppLocalizations {
  static const _SharedAppLocalizationsDelegate delegate =
      _SharedAppLocalizationsDelegate();

  static SharedAppLocalizationData of(BuildContext context) {
    return Localizations.of<SharedAppLocalizationData>(
      context,
      SharedAppLocalizationData,
    )!;
  }

  static const List<Locale> supportedLocales = [Locale('ru'), Locale('en')];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    SharedAppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

final class _SharedAppLocalizationsDelegate
    extends LocalizationsDelegate<SharedAppLocalizationData> {
  const _SharedAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      SharedAppLocalizations.supportedLocales.contains(locale);

  @override
  Future<SharedAppLocalizationData> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ru':
        return const RuSharedAppLocalizationData();
      case 'en':
        return const EnSharedAppLocalizationData();
      default:
        return const RuSharedAppLocalizationData();
    }
  }

  @override
  bool shouldReload(_SharedAppLocalizationsDelegate old) => false;
}

extension SharedAppLocalizationsExtension on BuildContext {
  SharedAppLocalizationData get sharedAppLocalizations =>
      SharedAppLocalizations.of(this);
}

