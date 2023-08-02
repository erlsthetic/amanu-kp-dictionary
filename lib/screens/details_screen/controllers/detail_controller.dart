import 'package:get/get.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();

  final List<String> engTrans = [
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
  ];
  final List<String> filTrans = [
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
  ];

  final List<String> synonym = [
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
  ];

  final List<String> antonym = [
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
  ];

  final List<String> related = [
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
    "sample",
    "another",
  ];
  final List<String> types = [
    "noun",
    "adjective",
    "adverb",
  ];
  final List<List<List<String>>> definitions = [
    [
      [
        "This is definition 1. Lorem ipsum dolor sit amet, consectetur",
        "Def 1 dialect",
        "Def 1 Lorem ipsum dolor",
        "Def 1 trans Lorem ipsum dolor"
      ],
      [
        "This is definition 2. Lorem ipsum dolor sit amet, consectetur",
        "Def 2 dialect",
        "Def 2 Lorem ipsum dolor",
        "Def 2 trans Lorem ipsum dolor"
      ]
    ],
    [
      [
        "This is definition 1. Lorem ipsum dolor sit amet, consectetur",
        "Def 1 Lorem ipsum dolor",
        "Def 1 trans Lorem ipsum dolor"
      ],
    ]
  ];

  final List<List<String>> kulitanChars = [
    ["ku", "i", "ng"],
    ["a"],
    ["ma"],
    ["nu"]
  ];

  // [[[tx],[],[]],[]]
}
