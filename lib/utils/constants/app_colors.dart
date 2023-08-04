import 'package:flutter/material.dart';

const Color primaryOrangeLightShine = Color.fromARGB(255, 237, 183, 147);
const Color primaryOrangeLight = Color(0xfff2a068); //f2a068 fb8c32
const Color primaryOrangeDark = Color(0xffff7200); //ff7200 fd6f02
const Color primaryOrangeDarkShine = Color.fromARGB(255, 252, 141, 50);
const Color pureWhite = Color(0xffFFFFFF);
const Color muteBlack = Color(0xff272727);
const Color darkGrey = Color.fromARGB(255, 75, 75, 75);
const Color lightGrey = Color.fromARGB(255, 200, 200, 200);
const Color orangeCard = Color(0xffFBE5D6);
const Color orangeCardShine = Color.fromARGB(255, 247, 235, 228);
const Color darkerOrange = Color(0xFFc4570d);
const Color disabledGrey = Color(0xFF9B9B9B);
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
