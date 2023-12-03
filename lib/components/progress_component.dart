import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../extensions/colors.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../../extensions/app_button.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../../main.dart';
import '../extensions/app_text_field.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/constants.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../models/graph_response.dart';
import '../network/rest_api.dart';
import '../utils/app_common.dart';

class ProgressComponent extends StatefulWidget {
  static String tag = '/UserAddMeasurementDialog';
  final GraphModel? mGraphModel;
  final String? mType;
  final String? mUnit;
  final Function? onCall;

  ProgressComponent({this.mGraphModel, this.mType, this.mUnit, this.onCall});

  @override
  ProgressComponentState createState() => ProgressComponentState();
}

class ProgressComponentState extends State<ProgressComponent> {
  var formKey = GlobalKey<FormState>();

  TextEditingController mValueCont = TextEditingController();
  TextEditingController countDownCont = TextEditingController();
  bool mIsUpdate = false;

  DateTime? pickedDate;
  String? formattedDate;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.mGraphModel != null;

    if (mIsUpdate) {
      mValueCont.text = widget.mGraphModel!.value!;
      formattedDate = progressDateStringWidget(widget.mGraphModel!.date.toString());
      countDownCont.text = formattedDate.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> save({String? id}) async {
    if (formKey.currentState!.validate()) {
      Map req;
      if (mIsUpdate) {
        req = {"id": id, "value": mValueCont.text, "type": widget.mType, "unit": widget.mUnit, "date": countDownCont.text};
      } else {
        req = {"value": mValueCont.text, "type": widget.mType, "unit": widget.mUnit, "date": countDownCont.text};
      }
      await setProgressApi(req).then((value) {
        toast(value.message);
        widget.onCall!.call();
        finish(context);
        setState(() {});
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  Future<void> delete() async {
    Map req = {
      "id": widget.mGraphModel!.id,
    };
    await deleteProgressApi(req).then((value) {
      toast(value.message);
      widget.onCall!.call();
      finish(context);
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500),
        child: Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            backgroundColor: appStore.isDarkMode ? cardDarkColor : cardLightColor,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(mIsUpdate ? '${languages.lblUpdate} ${widget.mType.capitalizeFirstLetter()}' : '${languages.lblAdd} ${widget.mType.capitalizeFirstLetter()}', style: boldTextStyle()),
                      4.height,
                      InkWell(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: appStore.isDarkMode ? cardDarkColor : context.cardColor),
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.close, color: appStore.isDarkMode ? cardLightColor : cardDarkColor),
                        ),
                      )
                    ],
                  ),
                  20.height,
                  AppTextField(
                    controller: mValueCont,
                    textFieldType: TextFieldType.PHONE,
                    decoration: defaultInputDecoration(context, label: languages.lblHint),
                    suffix: Text(widget.mUnit.toString(), style: secondaryTextStyle()).paddingSymmetric(vertical: 16, horizontal: 0),
                    autoFocus: false,
                    isValidationRequired: true,
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: countDownCont,
                    textFieldType: TextFieldType.NAME,
                    onChanged: (s) {
                      setState(() {});
                    },
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                      if (pickedDate != null) {
                        print(pickedDate);
                        formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
                        print(formattedDate);
                        setState(() {
                          countDownCont.text = formattedDate!;
                        });
                      } else {}
                    },
                    readOnly: true,
                    suffix: Icon(Icons.calendar_today),
                    decoration: defaultInputDecoration(context, label: languages.lblDate),
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  25.height,
                  mIsUpdate == true
                      ? Row(
                          children: [
                            AppButton(
                              color: primaryColor,
                              onTap: () {
                                showConfirmDialogCustom(context,
                                    dialogType: DialogType.CONFIRMATION,
                                    iconColor: primaryColor,
                                    primaryColor: primaryColor,
                                    title: "${languages.lblDelete} ${widget.mType.capitalizeFirstLetter()}",
                                    image: ic_delete,
                                    subTitle: "${languages.lblDeleteAccountMSg} ${widget.mType.capitalizeFirstLetter()}?", onAccept: (context) {
                                  delete();
                                });
                              },
                              text: languages.lblDelete,
                            ).expand(),
                            16.width,
                            AppButton(
                              color: primaryColor,
                              text: languages.lblUpdate,
                              onTap: () {
                                save(id: widget.mGraphModel!.id.toString());
                              },
                            ).expand()
                          ],
                        )
                      : AppButton(
                          color: primaryColor,
                          width: context.width(),
                          text: languages.lblSave,
                          onTap: () {
                            save();
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
