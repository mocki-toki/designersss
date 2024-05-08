// GENERATED FILE. DO NOT MODIFY.
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'ru.g.dart';
part 'en.g.dart';

abstract final class AdminAppLocalizationData {
  String get invalidCredentialsFailure;
  String welcomeMessage(String name);
  String get dateAlreadyExistsError;
  String get createDialog;
  String get confirmDialog;
  String get deleteDialog;
  String get cancelDialog;
  String get deleteDateMessage;
  String get createLinkTitle;
  String get changeLinkTitle;
  String get linkUrlHint;
  String get changeTypeTitle;
  String get newDateButton;
  String get createLinkButton;
  String get uploadFileButton;
  String get deleteDateButton;
  String get saveChangesButton;
  String get discardChangesButton;
  String get noDatesMessage;
  String get changeImageTitle;

  Map<String, String> get map;
}

final class AdminAppLocalizations {
  static const _AdminAppLocalizationsDelegate delegate =
      _AdminAppLocalizationsDelegate();

  static AdminAppLocalizationData of(BuildContext context) {
    return Localizations.of<AdminAppLocalizationData>(
      context,
      AdminAppLocalizationData,
    )!;
  }

  static const List<Locale> supportedLocales = [Locale('ru'), Locale('en')];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AdminAppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

final class _AdminAppLocalizationsDelegate
    extends LocalizationsDelegate<AdminAppLocalizationData> {
  const _AdminAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AdminAppLocalizations.supportedLocales.contains(locale);

  @override
  Future<AdminAppLocalizationData> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ru':
        return const RuAdminAppLocalizationData();
      case 'en':
        return const EnAdminAppLocalizationData();
      default:
        return const RuAdminAppLocalizationData();
    }
  }

  @override
  bool shouldReload(_AdminAppLocalizationsDelegate old) => false;
}

extension AdminAppLocalizationsExtension on BuildContext {
  AdminAppLocalizationData get adminAppLocalizations =>
      AdminAppLocalizations.of(this);
}

