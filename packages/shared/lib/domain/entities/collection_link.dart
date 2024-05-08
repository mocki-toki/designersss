import 'package:shared/domain.dart';

final class CollectionLink {
  CollectionLink({
    required this.id,
    required this.title,
    required this.url,
    required this.previewImageUrl,
    required this.type,
    required this.date,
  });

  final UuidValue id;
  final String title;
  final Uri url;
  final Uri? previewImageUrl;
  final CollectionLinkType type;
  final Date date;

  Map<String, dynamic> toJson() {
    return {
      'id': '$id',
      'title': title,
      'url': '$url',
      'preview_image_url':
          previewImageUrl == null || previewImageUrl?.host == null
              ? null
              : '$previewImageUrl',
      'type': type.name,
      'date': date.dateTime.toIso8601String(),
    };
  }

  static CollectionLink fromJson(Map<String, dynamic> json) {
    var previewImageUrl = json['preview_image_url'] as String?;
    if (previewImageUrl != null && previewImageUrl.isEmpty)
      previewImageUrl = null;
    return CollectionLink(
      id: UuidValue.fromString(json['id'] as String),
      title: json['title'] as String,
      url: Uri.parse(json['url'] as String),
      previewImageUrl:
          previewImageUrl == null ? null : Uri.tryParse(previewImageUrl),
      type: CollectionLinkType.values.byName(json['type'] as String),
      date: Date(DateTime.parse(json['date'] as String)),
    );
  }

  CollectionLink copyWith({
    UuidValue? id,
    String? title,
    Uri? url,
    Uri? previewImageUrl,
    CollectionLinkType? type,
    Date? date,
  }) {
    return CollectionLink(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}

enum CollectionLinkType {
  video,
  startup,
  utility,
  site,
  article,
  cases,
}
