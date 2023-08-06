import 'package:amanu/components/kulitan_preview.dart';
import 'package:amanu/screens/user_tools/controllers/tools_controller.dart';
import 'package:amanu/screens/user_tools/widgets/kulitan_editor.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KulitanFormField extends FormField {
  KulitanFormField(
      {required ToolsController controller,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      AutovalidateMode mode = AutovalidateMode.onUserInteraction})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: controller.audioPath,
            autovalidateMode: mode,
            builder: (FormFieldState state) {
              return Column(
                children: [
                  Obx(
                    () => Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          border: state.hasError
                              ? Border.all(color: Colors.red.shade700)
                              : null,
                          color: orangeCard),
                      child: controller.kulitanListEmpty.value
                          ? Container(
                              child: Text(
                                "No data",
                                style: TextStyle(
                                    fontSize: 15, color: disabledGrey),
                              ),
                            )
                          : KulitanPreview(
                              kulitanCharList:
                                  controller.kulitanStringListGetter,
                            ),
                    ),
                  ),
                  state.hasError
                      ? Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          width: double.infinity,
                          child: Text(
                            state.errorText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 12),
                          ))
                      : Container(),
                  SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => KulitanEditorPage());
                      state.reset();
                    },
                    child: Container(
                      height: 50.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          tEnterKulitanEditor.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: pureWhite,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: primaryOrangeDark,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              );
            });
}
