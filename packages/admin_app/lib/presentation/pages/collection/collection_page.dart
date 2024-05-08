import 'package:admin_app/presentation.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
final class CollectionPage extends WidgetWithLogic<CollectionLogic> {
  const CollectionPage({super.key});

  @override
  logicBuilder(context) => CollectionLogic(context);

  @override
  Widget build(context, logic) {
    return Scaffold(
      body: logic.datesDataNotifier.when(
        success: (dates) {
          return logic.selectedDateNotifier.builder(
            (context, selectedDate, _) => Row(
              children: [
                SizedBox(
                  width: 300,
                  child: logic.isDraftNotifier.builder(
                    (context, isDraft, child) => IgnorePointer(
                      ignoring: isDraft,
                      child: Opacity(
                        opacity: isDraft ? 0.5 : 1,
                        child: child,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          title:
                              Text(context.adminAppLocalizations.newDateButton),
                          leading: Icon(Icons.add),
                          onTap: logic.createDate,
                        ),
                        if (dates.isEmpty)
                          ListTile(
                            title: Text(
                                context.adminAppLocalizations.noDatesMessage),
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: dates.length,
                            itemBuilder: (context, index) {
                              final date = dates[index];
                              return ListTile(
                                title: Text(date.toString()),
                                selected: selectedDate == date,
                                onTap: () {
                                  final value =
                                      selectedDate == date ? null : date;
                                  logic.selectDate(value);
                                },
                                selectedTileColor: Colors.black12,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ColoredBox(
                  color: Colors.black12,
                  child: SizedBox(width: 1, height: double.infinity),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.white,
                    child: logic.linksDataNotifier.when(
                      success: (links) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                // IntrinsicWidth(
                                //   child: ListTile(
                                //     title: Text(context.adminAppLocalizations
                                //         .createLinkButton),
                                //     leading: Icon(Icons.add),
                                //     onTap: logic.createLinkInSelectedDate,
                                //   ),
                                // ),
                                const Spacer(),
                                IntrinsicWidth(
                                  child: ListTile(
                                    title: Text(context.adminAppLocalizations
                                        .deleteDateButton),
                                    leading: Icon(Icons.delete_forever),
                                    iconColor: Colors.red,
                                    textColor: Colors.red,
                                    onTap: logic.deleteSelectedDate,
                                  ),
                                ),
                                // отмена изменений

                                logic.isDraftNotifier.builder(
                                  (context, isDraft, __) => Opacity(
                                    opacity: !isDraft ? 0.5 : 1,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IntrinsicWidth(
                                          child: ListTile(
                                            title: Text(context
                                                .adminAppLocalizations
                                                .discardChangesButton),
                                            leading: Icon(Icons.save),
                                            iconColor: Colors.black,
                                            textColor: Colors.black,
                                            onTap: !isDraft
                                                ? null
                                                : logic.discardChanges,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: links.isEmpty ? 0.5 : 1,
                                          child: IntrinsicWidth(
                                            child: ListTile(
                                              title: Text(context
                                                  .adminAppLocalizations
                                                  .saveChangesButton),
                                              leading: Icon(Icons.save),
                                              iconColor: Colors.blue,
                                              textColor: Colors.blue,
                                              onTap: !isDraft || links.isEmpty
                                                  ? null
                                                  : logic.saveLinks,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: CollectionViewer(
                                  links,
                                  onChangeImage: logic.changeImage,
                                  onChangeTitle: logic.changeTitle,
                                  onChangeUrl: logic.changeUrl,
                                  onSetPreviewFromUrl: logic.setPreviewFromUrl,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final class UrlOrFile {
  const UrlOrFile({this.url, this.file});

  final String? url;
  final XFile? file;

  bool get isUrl => url != null;
  bool get isFile => file != null;
}

final class GetImageUrlOrFileDialog extends StatefulWidget {
  const GetImageUrlOrFileDialog({
    super.key,
    required this.title,
    this.initialUrl,
  });

  final String title;
  final String? initialUrl;

  Future<UrlOrFile?> show(BuildContext context) {
    return showDialog<UrlOrFile>(
      context: context,
      builder: (_) => this,
    );
  }

  @override
  State<GetImageUrlOrFileDialog> createState() =>
      _GetImageUrlOrFileDialogState();
}

final class _GetImageUrlOrFileDialogState
    extends State<GetImageUrlOrFileDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialUrl);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: context.adminAppLocalizations.linkUrlHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final file =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file == null) return;

            Navigator.of(context).pop(UrlOrFile(file: file));
          },
          child: Text(context.adminAppLocalizations.uploadFileButton),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(context.adminAppLocalizations.cancelDialog),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(UrlOrFile(url: _controller.text)),
          child: Text(context.adminAppLocalizations.confirmDialog),
        ),
      ],
    );
  }
}
