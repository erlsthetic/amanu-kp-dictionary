import 'package:amanu/screens/user_tools/controllers/modify_word_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TagsField extends StatelessWidget {
  const TagsField({
    super.key,
    required this.controller,
    required this.label,
    required this.width,
    required this.category,
  });

  final double width;
  final TextfieldTagsController controller;
  final String label;
  final String category;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: controller,
      textSeparators: [','],
      letterCase: LetterCase.small,
      validator: (String tag) {
        if (controller.getTags!.contains(tag)) {
          return 'Duplicate tag found.';
        }
        return null;
      },
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return TextField(
            controller: tec,
            focusNode: fn,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: label,
              errorText: error,
              prefixIconConstraints: BoxConstraints(
                maxWidth: width * 0.6,
              ),
              prefixIcon: tags.isNotEmpty
                  ? Container(
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(right: 10, left: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(20),
                            left: Radius.circular(5)),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        controller: sc,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: tags.map((String tag) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: primaryOrangeDark,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Text(
                                    '$tag',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                InkWell(
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 18.0,
                                    color: Color.fromARGB(255, 233, 233, 233),
                                  ),
                                  onTap: () {
                                    onTagDelete(tag);
                                    if (category == 'related') {
                                      final modifyController =
                                          Get.find<ModifyController>();
                                      modifyController.importedRelated
                                          .remove(tag);
                                    } else if (category == 'synonyms') {
                                      final modifyController =
                                          Get.find<ModifyController>();
                                      modifyController.importedSynonyms
                                          .remove(tag);
                                    } else if (category == 'antonyms') {
                                      final modifyController =
                                          Get.find<ModifyController>();
                                      modifyController.importedAntonyms
                                          .remove(tag);
                                    }
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList()),
                      ),
                    )
                  : null,
            ),
          );
        });
      },
    );
  }
}
