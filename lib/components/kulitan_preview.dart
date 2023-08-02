import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class KulitanPreview extends StatelessWidget {
  const KulitanPreview({
    super.key,
    required this.kulitanCharList,
  });

  final List<List<String>> kulitanCharList;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(children: <Widget>[
          for (List<String> line in kulitanCharList)
            !(line.join() == '')
                ? Container(
                    height: 60,
                    constraints: BoxConstraints(minWidth: 60, maxWidth: 180),
                    child: line.length == 0
                        ? Container()
                        : FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              children: [
                                Text(
                                  line.join(),
                                  style: TextStyle(
                                      fontFamily: 'KulitanKeith',
                                      fontSize: 35,
                                      color: primaryOrangeDark),
                                ),
                              ],
                            ),
                          ),
                  )
                : Container(
                    child: Text(
                      "No data",
                      style: TextStyle(fontSize: 15, color: disabledGrey),
                    ),
                  ),
        ]),
        SizedBox(
          width: 5,
        ),
        Column(children: <Widget>[
          for (List<String> line in kulitanCharList)
            !(line.join() == '')
                ? Container(
                    alignment: Alignment.center,
                    height: 60,
                    constraints: BoxConstraints(minWidth: 30, maxWidth: 60),
                    child: line.length == 0
                        ? Container()
                        : Container(
                            child: Text(
                              line
                                  .join()
                                  .replaceAll("aa", "á")
                                  .replaceAll("ai", "e")
                                  .replaceAll("au", "o")
                                  .replaceAll("ii", "í")
                                  .replaceAll("uu", "ú"),
                              style:
                                  TextStyle(fontSize: 12, color: disabledGrey),
                            ),
                          ),
                  )
                : Container(),
        ]),
      ],
    );
  }
}
