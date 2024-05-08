import 'dart:async';
import 'dart:typed_data';

import 'package:admin_app/domain.dart';
import 'package:admin_app/infrastructure.dart';
import 'package:admin_app/presentation.dart';

import 'package:image/image.dart' as img;
import 'package:html/parser.dart' as html_parser;
import 'package:firebase_storage/firebase_storage.dart';

final class CollectionLogic extends Logic {
  CollectionLogic(super.sp);

  final datesDataNotifier = DataNotifier<List<Date>>();
  final selectedDateNotifier = ValueNotifier<Date?>(null);

  final linksDataNotifier = DataNotifier<List<List<CollectionLink>>>();
  final isDraftNotifier = ValueNotifier<bool>(false);

  @override
  Future<void> initLogic() async {
    super.initLogic();

    datesDataNotifier.loadData(
      getRequired<AdminCollectionLinkService>().getDates(),
    );
  }

  @override
  void disposeLogic() {
    datesDataNotifier.dispose();
    super.disposeLogic();
  }

  Future<void> selectDate(Date? date) async {
    if (date == null) {
      selectedDateNotifier.value = null;
      linksDataNotifier.value = DataStateInitial();
      isDraftNotifier.value = false;
      return;
    }

    if (selectedDateNotifier.value == date) return;
    selectedDateNotifier.value = date;

    final data =
        await getRequired<AdminCollectionLinkService>().getLinksByDate(date);

    data.when(
      success: (data) {
        final items = [
          [
            data[0],
            data[1],
            data[2],
          ],
          [
            data[3],
            data[4],
            data[5],
            data[6],
          ],
          [
            data[7],
            data[8],
            data[9],
          ],
          [
            data[10],
            data[11],
            data[12],
            data[13],
            data[14],
            data[15],
            data[16],
            data[17],
          ],
        ];

        linksDataNotifier.value = DataStateSuccess(items);
      },
      failure: (failure) {
        linksDataNotifier.value = DataStateFailed(failure);
      },
    );

    isDraftNotifier.value = false;
  }

  Future<void> createDate() async {
    if (!datesDataNotifier.value.isSuccess) return;

    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (result == null) return;
    final date = Date(result);

    if (datesDataNotifier.value.asSuccess!.data.contains(date)) {
      await getRequired<ScaffoldMessengerProvider>()
          .scaffoldMessenger
          .showSnackBar(SnackBar(
            content: Text(context.adminAppLocalizations.dateAlreadyExistsError),
          ));
      return;
    }

    datesDataNotifier.value = DataStateSuccess(
      [...datesDataNotifier.value.asSuccess!.data, date],
    );
    selectedDateNotifier.value = date;

    linksDataNotifier.value = DataStateSuccess(_initialData);
    isDraftNotifier.value = true;
  }

  Future<void> deleteSelectedDate() async {
    if (!datesDataNotifier.value.isSuccess) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.adminAppLocalizations.confirmDialog),
          content: Text(context.adminAppLocalizations.deleteDateMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.adminAppLocalizations.cancelDialog),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.adminAppLocalizations.confirmDialog),
            ),
          ],
        );
      },
    );

    if (result == false) return;

    final date = selectedDateNotifier.value!;
    unawaited(getRequired<AdminCollectionLinkService>().deleteByDate(date));

    datesDataNotifier.value = DataStateSuccess(datesDataNotifier
        .value.asSuccess!.data
        .where((d) => d != date)
        .toList());

    selectedDateNotifier.value = null;
    linksDataNotifier.value = DataStateInitial();
    isDraftNotifier.value = false;
  }

  Future<void> discardChanges() async {
    final selectedDate = selectedDateNotifier.value!;

    selectedDateNotifier.value = null;
    linksDataNotifier.value = DataStateInitial();
    isDraftNotifier.value = false;

    selectDate(selectedDate);
  }

  // Future<void> createLinkInSelectedDate() async {
  //   if (selectedDateNotifier.value == null) return;

  //   final url = await GetLinkDialog(
  //     title: context.adminAppLocalizations.createLinkTitle,
  //   ).show(context);
  //   if (url == null) return;

  //   final backup = linksDataNotifier.value.asSuccess!.data;
  //   linksDataNotifier.value = DataStateLoading();

  //   final response = await fetchPreviewData(
  //     url,
  //     backup.lastOrNull?.type ?? CollectionLinkType.site,
  //   );

  //   response.when(
  //     success: (link) {
  //       isDraftNotifier.value = true;
  //       linksDataNotifier.value = DataStateSuccess(
  //         [...backup, link],
  //       );
  //     },
  //     failure: (failure) {
  //       linksDataNotifier.value = DataStateSuccess(backup);
  //       return get<ScaffoldMessengerProvider>()
  //           .scaffoldMessenger
  //           .showSnackBar(SnackBar(
  //             content: Text(failure.toLocalizedString(context)),
  //           ));
  //     },
  //   );
  // }

  Future<void> setPreviewFromUrl(CollectionLink link) async {
    final backup = linksDataNotifier.value.asSuccess!;
    linksDataNotifier.value = DataStateLoading();

    final response = await fetchPreviewData('${link.url}');

    response.when(
      success: (data) async {
        final url = await _uploadImage(UrlOrFile(url: data.$2));

        url.when(
          success: (url) {
            linksDataNotifier.value = backup;
            editLink(
              link.copyWith(
                title: data.$1,
                previewImageUrl: Uri.tryParse(url ?? ''),
              ),
            );
          },
          failure: (failure) {
            getRequired<ScaffoldMessengerProvider>()
                .scaffoldMessenger
                .showSnackBar(SnackBar(
                  content: Text(failure.toLocalizedString(context)),
                ));

            linksDataNotifier.value = backup;
          },
        );
      },
      failure: (failure) {
        getRequired<ScaffoldMessengerProvider>()
            .scaffoldMessenger
            .showSnackBar(SnackBar(
              content: Text(failure.toLocalizedString(context)),
            ));

        linksDataNotifier.value = backup;
      },
    );
  }

  Future<DataOrFailure<(String title, String? previewImageUrl)>>
      fetchPreviewData(String url) async {
    try {
      final dio = Dio();

      if (url.startsWith('https://www.behance.net/gallery/')) {
        final match = RegExp(r'\/(\d+)\/').firstMatch(url);
        if (match != null) {
          url =
              'https://www.behance.net/embed/project/${match.group(1)}?ilo0=1';
        }
      }

      final response = await dio.get(url);
      final document = html_parser.parse(response.data);

      final String title;
      String? previewImageUrl;

      if (url.startsWith('https://www.behance.net/embed/project/')) {
        title = document
                .querySelector('.e2e-EmbedShareProjectCover-projectName')
                ?.text
                .trim() ??
            document.head
                ?.querySelector("meta[property='og:title']")
                ?.attributes['content'] ??
            document.head?.querySelector('title')?.text ??
            'No title';

        previewImageUrl = document
                .querySelector('.EmbedShareProjectCover-image-OwG')
                ?.attributes['src'] ??
            document.head
                ?.querySelector("meta[property='og:image']")
                ?.attributes['content'];
      } else {
        title = document.head
                ?.querySelector("meta[property='og:title']")
                ?.attributes['content'] ??
            document.head?.querySelector('title')?.text ??
            'No title';
        previewImageUrl = document.head
            ?.querySelector("meta[property='og:image']")
            ?.attributes['content'];
      }

      if (previewImageUrl != null && previewImageUrl[0] == '/') {
        previewImageUrl = url + previewImageUrl.substring(1);
      }

      return successful(
        (title, previewImageUrl),
      );
    } on DioException catch (_) {
      return failed(NetworkFailure());
    }
  }

  Future<void> saveLinks() async {
    if (selectedDateNotifier.value == null) return;

    final date = selectedDateNotifier.value!;
    final links = linksDataNotifier.value.asSuccess!.data;

    linksDataNotifier.value = DataStateLoading();
    isDraftNotifier.value = false;

    await getRequired<AdminCollectionLinkService>()
        .setLinksByDate(date, links.expand((e) => e).toList());
    linksDataNotifier.value = DataStateSuccess(links);
  }

  void editLink(CollectionLink link) {
    final nestedList = linksDataNotifier.value.asSuccess!.data;
    for (var sublist in nestedList) {
      for (var i = 0; i < sublist.length; i++) {
        if (sublist[i].id == link.id) {
          sublist[i] = link;
          linksDataNotifier.value = DataStateSuccess(nestedList);
          isDraftNotifier.value = true;
          return;
        }
      }
    }
  }

  Future<void> changeImage(CollectionLink link) async {
    final urlOrFile = await GetImageUrlOrFileDialog(
      title: context.adminAppLocalizations.changeImageTitle,
      initialUrl: link.previewImageUrl?.toString(),
    ).show(context);
    if (urlOrFile == null) return;

    final backup = linksDataNotifier.value.asSuccess!;
    linksDataNotifier.value = DataStateLoading();

    final response = await _uploadImage(urlOrFile);
    linksDataNotifier.value = backup;

    response.when(
      success: (url) {
        editLink(link.copyWith(previewImageUrl: Uri.tryParse(url ?? '')));
      },
      failure: (failure) {
        getRequired<ScaffoldMessengerProvider>()
            .scaffoldMessenger
            .showSnackBar(SnackBar(
              content: Text(failure.toLocalizedString(context)),
            ));
      },
    );
  }

  Future<DataOrFailure<String?>> _uploadImage(UrlOrFile urlOrFile) async {
    try {
      final storage = getRequired<FirebaseStorageService>().storage;
      final imagesRef = storage.ref('images/');
      final imageFileRef = imagesRef.child('${Uuid().v4()}.png');

      late final Uint8List bytes;
      if (urlOrFile.isFile) {
        bytes = await urlOrFile.file!.readAsBytes();
      } else {
        if (urlOrFile.url == null) return successful(null);
        final response = await Dio().get(
          urlOrFile.url!,
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.data == null) return successful(null);
        bytes = response.data;
      }

      img.Image image = img.decodeImage(bytes)!;
      image = img.copyResize(
        image,
        width: 600,
        interpolation: img.Interpolation.cubic,
      );
      final newImageBytes = img.encodeJpg(image);

      await imageFileRef.putData(
        newImageBytes,
        SettableMetadata(contentType: "image/jpeg"),
      );

      return successful(await imageFileRef.getDownloadURL());
    } on DioException catch (_) {
      return failed(NetworkFailure());
    }
  }

  void changeTitle(CollectionLink link, String title) {
    editLink(link.copyWith(title: title));
  }

  Future<void> changeUrl(CollectionLink link, String url) async {
    if (!url.contains('http')) url = 'https://$url';
    editLink(link.copyWith(url: Uri.parse(url)));
  }

  void deleteLink(CollectionLink link) {
    final backup = linksDataNotifier.value.asSuccess!.data;
    linksDataNotifier.value = DataStateSuccess(
      backup.where((l) => l != link).toList(),
    );
    isDraftNotifier.value = true;
  }
}

final _initialData = [
  [
    _createLink(CollectionLinkType.video),
    _createLink(CollectionLinkType.startup),
    _createLink(CollectionLinkType.utility),
  ],
  [
    _createLink(CollectionLinkType.site),
    _createLink(CollectionLinkType.site),
    _createLink(CollectionLinkType.site),
    _createLink(CollectionLinkType.site),
  ],
  [
    _createLink(CollectionLinkType.article),
    _createLink(CollectionLinkType.article),
    _createLink(CollectionLinkType.article),
  ],
  [
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
    _createLink(CollectionLinkType.cases),
  ],
];

CollectionLink _createLink(CollectionLinkType type) {
  return CollectionLink(
    id: Uuid().v4obj(),
    title: 'Заголовок',
    url: Uri.parse('https://example.com/'),
    previewImageUrl: null,
    type: type,
    date: DateTime.now().toDate(),
  );
}
