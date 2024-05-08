import 'package:shared_app/domain.dart';
import 'package:shared_app/presentation.dart';

extension CollectionLinkTypeExtension on CollectionLinkType {
  String translate(BuildContext context, bool isMultiple) {
    return SharedAppLocalizations.of(context)
        .map['link_type_${this.name}${isMultiple ? '_multiple' : ''}']!;
  }
}
