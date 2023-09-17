import 'package:flutter/material.dart';
import 'dart:math';

TextSpan buildTextSpan(
    {required String text,
    required TextStyle style,
    required FontWeight boldWeight,
    bool isBoldDefault = false}) {
  List<List<String>> outListStr = getStyledText(text, 'r', []);
  return TextSpan(
      children: List.generate(outListStr.length, (i) {
        return TextSpan(
            text: outListStr[i][0],
            style: TextStyle(
                fontStyle:
                    outListStr[i][1].contains("i") ? FontStyle.italic : null,
                fontWeight: isBoldDefault
                    ? boldWeight
                    : outListStr[i][1].contains("b")
                        ? boldWeight
                        : null,
                decoration: outListStr[i][1].contains("u")
                    ? TextDecoration.underline
                    : null));
      }),
      style: style);
}

List<List<String>> getStyledText(
    String inp, String currentTag, List<List<String>> outListStr) {
  List<List<String>> outStr = outListStr;
  int cIdx = 0;
  String cTag = currentTag;

  int nearestI = inp.indexOf("<i>", cIdx);
  int nearestIC = inp.indexOf("</i>", cIdx);
  int nearestB = inp.indexOf("<b>", cIdx);
  int nearestBC = inp.indexOf("</b>", cIdx);
  int nearestU = inp.indexOf("<u>", cIdx);
  int nearestUC = inp.indexOf("</u>", cIdx);

  if (nearestI == -1 &&
      nearestB == -1 &&
      nearestU == -1 &&
      nearestIC == -1 &&
      nearestBC == -1 &&
      nearestUC == -1) {
    String passString = inp
        .replaceAll("<i>", "")
        .replaceAll("</i>", "")
        .replaceAll("<b>", "")
        .replaceAll("</b>", "")
        .replaceAll("<u>", "")
        .replaceAll("</u>", "");
    outStr.add([passString, cTag]);
    return outStr;
  }

  int nearestTagIdx = identifyNearestTagIdx(
      nearestI, nearestIC, nearestB, nearestBC, nearestU, nearestUC);
  if (nearestTagIdx > 0) {
    outStr.add([inp.substring(0, nearestTagIdx), cTag]);
  }

  int closingBracket = inp.indexOf(">", nearestTagIdx);
  String nearestTag = inp.substring(nearestTagIdx, closingBracket + 1);
  cIdx = closingBracket + 1;
  String newInput = inp.substring(cIdx);
  if (nearestTag == "</i>") {
    if (cTag.contains("i")) {
      int lastIdx = cTag.lastIndexOf("i");
      cTag = cTag.replaceFirst("i", "", lastIdx);
    }
  } else if (nearestTag == "</b>") {
    if (cTag.contains("b")) {
      int lastIdx = cTag.lastIndexOf("b");
      cTag = cTag.replaceFirst("b", "", lastIdx);
    }
  } else if (nearestTag == "</u>") {
    if (cTag.contains("u")) {
      int lastIdx = cTag.lastIndexOf("u");
      cTag = cTag.replaceFirst("u", "", lastIdx);
    }
  } else {
    cTag +=
        nearestTag.replaceAll("<", "").replaceAll("/", "").replaceAll(">", "");
  }
  if (newInput != '') {
    getStyledText(newInput, cTag, outStr);
  }
  return outStr;
}

int identifyNearestTagIdx(
  int nI,
  int nIC,
  int nB,
  int nBC,
  int nU,
  int nUC,
) {
  int nearestI = nI == -1
      ? nI.abs() + nIC.abs() + nB.abs() + nBC.abs() + nU.abs() + nUC.abs()
      : nI;
  int nearestIC = nIC == -1
      ? nI.abs() + nIC.abs() + nB.abs() + nBC.abs() + nU.abs() + nUC.abs()
      : nIC;
  int nearestB = nB == -1
      ? nI.abs() + nIC.abs() + nB.abs() + nBC.abs() + nU.abs() + nUC.abs()
      : nB;
  int nearestBC = nBC == -1
      ? nI.abs() + nIC.abs() + nB.abs() + nBC.abs() + nU.abs() + nUC.abs()
      : nBC;
  int nearestU = nU == -1
      ? nI.abs() + nIC.abs() + nB.abs() + nBC.abs() + nU.abs() + nUC.abs()
      : nU;
  int nearestUC = nUC == -1
      ? nI.abs() + nIC.abs() + nB.abs() + nBC.abs() + nU.abs() + nUC.abs()
      : nUC;
  int nearestIdx = min(min(min(nearestI, nearestIC), min(nearestB, nearestBC)),
      min(nearestU, nearestUC));

  if (nearestIdx == nearestI) {
    return nI;
  } else if (nearestIdx == nearestIC) {
    return nIC;
  } else if (nearestIdx == nearestB) {
    return nB;
  } else if (nearestIdx == nearestBC) {
    return nBC;
  } else if (nearestIdx == nearestU) {
    return nU;
  } else {
    return nUC;
  }
}
