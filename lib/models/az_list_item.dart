import 'package:azlistview/azlistview.dart';

class AZItem extends ISuspensionBean {
  final String wordID;
  final String tag;

  AZItem({required this.wordID, required this.tag});

  @override
  String getSuspensionTag() => tag;
}
