import 'package:flutter/material.dart';

const Color primaryOrangeLightShine = Color(0xFFEDB793);
const Color primaryOrangeLight = Color(0xfff2a068); //f2a068 fb8c32
const Color primaryOrangeDark = Color(0xffff7200); //ff7200 fd6f02
const Color primaryOrangeDarkShine = Color(0xFFFC8D32);
const Color pureWhite = Color(0xffFFFFFF);
const Color muteBlack = Color(0xff272727);
const Color cardText = Color(0xFF646464);
const Color darkGrey = Color(0xFF4B4B4B);
const Color lightGrey = Color(0xFFC8C8C8);
const Color orangeCard = Color(0xffFBE5D6);
const Color orangeCardShine = Color(0xFFF7EBE4);
const Color darkerOrange = Color(0xFFc4570d);
const Color disabledGrey = Color(0xFF9B9B9B);

const Color contributorBadge = Color(0xFF934A32);
const Color expertBadge = Color(0xFFFDD835);
const Color adminBadge = Color.fromARGB(255, 255, 66, 66);
const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment(-0.9, -1),
    end: Alignment(0.9, 1),
    stops: [0.0, 0.75],
    colors: [primaryOrangeLight, primaryOrangeDark]);

const LinearGradient whiteGradient = LinearGradient(
    begin: Alignment(-0.9, -1),
    end: Alignment(0.9, 1),
    stops: [0.0, 0.75],
    colors: [pureWhite, pureWhite]);

const ColorFilter greyscale = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);
