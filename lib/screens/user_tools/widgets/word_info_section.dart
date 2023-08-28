import 'package:amanu/screens/user_tools/controllers/modify_word_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WordInfoSection extends StatelessWidget {
  const WordInfoSection({
    super.key,
    required this.controller,
  });

  final ModifyController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      key: controller.typeListKey,
      initialItemCount: controller.typeFields.length,
      itemBuilder: (context, i, animI) {
        return Dismissible(
          key: Key("${i}"),
          child: SizeTransition(
            sizeFactor: animI,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120.0,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value != null) {
                                return controller.validateType(value);
                              } else {
                                return "Please select a type";
                              }
                            },
                            items: controller.typeDropItems,
                            onChanged: (String? newValue) {
                              // ignore: invalid_use_of_protected_member
                              if (newValue != "custom") {
                                controller.customTypeController[i].clear();
                              }
                              // ignore: invalid_use_of_protected_member
                              controller.typeFields.value[i] = newValue!;
                              controller.typeFields.refresh();
                            },
                            // ignore: invalid_use_of_protected_member
                            value: controller.typeFields.value[i] == ''
                                ? null
                                // ignore: invalid_use_of_protected_member
                                : controller.typeFields.value[i],
                            decoration: InputDecoration(
                                labelText: tWordType + " *",
                                hintText: tWordType + " *",
                                hintMaxLines: 5,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                          ),
                        ),
                        // ignore: invalid_use_of_protected_member
                        Obx(() => controller.typeFields.value[i] == "custom"
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value != null) {
                                        return controller
                                            .validateCustomType(value);
                                      } else {
                                        return "Please enter custom type";
                                      }
                                    },
                                    controller:
                                        controller.customTypeController[i],
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        labelText: tCustomWordType + " *",
                                        hintText: tCustomWordType + " *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                  ),
                                ),
                              )
                            : Container()),
                        SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.addTypeField(i + 1);
                            controller.typeFields.refresh();
                            controller.definitionsFields.refresh();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  color: pureWhite,
                                )),
                            decoration: BoxDecoration(
                              color: primaryOrangeDark,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7.5,
                  ),
                  AnimatedList(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    key: controller.definitionListKey[i],
                    initialItemCount: controller.definitionsFields[i].length,
                    itemBuilder: (context, j, animJ) {
                      return Dismissible(
                        key: Key("${i} ${j}"),
                        child: SizeTransition(
                          sizeFactor: animJ,
                          child: Container(
                            child: Column(children: [
                              SizedBox(
                                height: 7.5,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value != null) {
                                            return controller
                                                .validateDefinition(value);
                                          } else {
                                            return "Please enter word";
                                          }
                                        },
                                        controller: controller
                                            .definitionsFields[i][j][0],
                                        minLines: 1,
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                            labelText: tDefinition + " *",
                                            hintText: tDefinition + " *",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.addDefinitionField(i, j + 1);
                                        controller.typeFields.refresh();
                                        controller.definitionsFields.refresh();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.add,
                                              color: pureWhite,
                                            )),
                                        decoration: BoxDecoration(
                                          color: primaryOrangeDark,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [1],
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tExample,
                                      hintText: tExample,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [2],
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tExTrans,
                                      hintText: tExTrans,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [3],
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      labelText: tDialect,
                                      hintText: tDialect,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [4],
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tOrigin,
                                      hintText: tOrigin,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                          ),
                        ),
                        secondaryBackground: Container(
                          padding: EdgeInsets.all(30),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: disabledGrey,
                            size: 50,
                          ),
                        ),
                        background: Container(
                          padding: EdgeInsets.all(30),
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.delete,
                            color: disabledGrey,
                            size: 50,
                          ),
                        ),
                        onDismissed: (direction) {
                          controller.removeDefinitionField(i, j);
                          controller.typeFields.refresh();
                          controller.definitionsFields.refresh();
                        },
                        direction: controller.definitionsFields[i].length > 1
                            ? DismissDirection.horizontal
                            : DismissDirection.none,
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          background: Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: disabledGrey,
              size: 70,
            ),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: disabledGrey,
              size: 70,
            ),
          ),
          onDismissed: (direction) {
            controller.removeTypeField(i);
            controller.typeFields.refresh();
            controller.definitionsFields.refresh();
          },
          direction: controller.typeFields.length > 1
              ? DismissDirection.horizontal
              : DismissDirection.none,
        );
      },
    );
  }
}
