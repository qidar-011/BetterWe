import 'dart:ui';
import 'package:flutter/material.dart';
import '../../extensions/decorations.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/text_styles.dart';
import '../models/equipment_response.dart';
import '../screens/exercise_list_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_common.dart';

class EquipmentComponent extends StatefulWidget {
  final isGrid;
  final isSearch;
  final int? isEquId;
  final Function? onCall;

  final EquipmentModel? mEquipmentModel;

  EquipmentComponent({this.mEquipmentModel, this.isGrid = false, this.isSearch = false, this.isEquId, this.onCall});

  @override
  _EquipmentComponentState createState() => _EquipmentComponentState();
}

class _EquipmentComponentState extends State<EquipmentComponent> {
  bool isEquipment = false;
  List<int>? mId = [];

  @override
  Widget build(BuildContext context) {
    double width = widget.isGrid == true ? (context.width() - 48) / 2 : context.width() * 0.4;
    double height = widget.isGrid == true ? 190 : 185;
    return Column(
      children: [
        widget.isSearch == true
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), border: Border.all(color: widget.mEquipmentModel!.isSelected == true ? primaryColor : Colors.transparent)),
                      child: cachedImage(
                        widget.mEquipmentModel!.equipmentImage.validate(),
                        height: 135,
                        width: (context.width() - 54) / 3,
                        fit: BoxFit.fill,
                      ).cornerRadiusWithClipRRect(12)),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1),
                      width: (context.width() - 54) / 3,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.grey.shade200.withOpacity(0.5)),
                      child: Text(widget.mEquipmentModel!.title.validate(), style: boldTextStyle(color: Colors.black)).center(),
                    ),
                  )
                ],
              ).onTap(() {
                if (widget.isSearch == true) {
                  widget.mEquipmentModel!.isSelected = !widget.mEquipmentModel!.isSelected!;
                  if (widget.mEquipmentModel!.isSelected == true) {
                    mId!.add(widget.mEquipmentModel!.id.validate());
                  } else {
                    mId!.remove(widget.mEquipmentModel!.id.validate());
                  }
                  widget.onCall!.call(mId);
                } else {
                  ExerciseListScreen(mTitle: widget.mEquipmentModel!.title.validate(), isEquipment: true, id: widget.mEquipmentModel!.id.validate()).launch(context);
                }
              })
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  cachedImage(
                    widget.mEquipmentModel!.equipmentImage.validate(),
                    height: height,
                    width: width,
                    fit: BoxFit.fill,
                  ).cornerRadiusWithClipRRect(16),
                  ClipRRect(
                    borderRadius: radius(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.grey.shade100.withOpacity(0.5)),
                        child: Text(widget.mEquipmentModel!.title.validate(), style: boldTextStyle(color: Colors.black)).center(),
                      ),
                    ),
                  )
                ],
              ).onTap(() {
                ExerciseListScreen(mTitle: widget.mEquipmentModel!.title.validate(),isEquipment: true, id: widget.mEquipmentModel!.id.validate()).launch(context);
              }),
      ],
    );
  }
}
