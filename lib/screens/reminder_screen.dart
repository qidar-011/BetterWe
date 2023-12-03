import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../models/reminder_model.dart';
import '../utils/app_colors.dart';
import '../components/notification_utils.dart';
import '../extensions/app_button.dart';
import '../extensions/app_text_field.dart';
import '../extensions/constants.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool? isSet = false;
  DateTime _dateTime = DateTime.now();

  DateTime now = DateTime.now();
  int? selectedDay;
  int? currentIndex = -1;

  TextEditingController mReminderNameCount = TextEditingController();
  TextEditingController mDescriptionCont = TextEditingController();

  FocusNode mNameFocus = FocusNode();
  FocusNode mDescriptionFocus = FocusNode();

  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    mReminderNameCount.text.trim();
    mDescriptionCont.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.lblDailyReminders, context: context,
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       NotificationWeekAndTime? pickedSchedule = await pickSchedule(context);
        //       if (pickedSchedule != null) {
        //         createReminderNotification(pickedSchedule);
        //       }
        //     },
        //     icon: Icon(Icons.add, color: primaryColor),
        //   ),
        // ]
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 100.height,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("Daily Reminder", style: boldTextStyle()),
            //     Transform.scale(
            //       scale: 0.8,
            //       child: CupertinoSwitch(
            //         activeColor: primaryColor,
            //         value: isSet!,
            //         onChanged: (v) async {
            //           NotificationDaily? pickedSchedule = await pickDailySchedule(context);
            //           if (pickedSchedule != null) {
            //             scheduleDailyNotification(pickedSchedule);
            //           }
            //         },
            //       ).withHeight(10),
            //     ),
            //   ],
            // ).paddingSymmetric(horizontal: 16, vertical: 8),
            // Divider().paddingSymmetric(horizontal: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hourMinute12H(),
                Divider(),
                8.height,
                Text(languages.lblRepeat, style: boldTextStyle(size: 20)),
                8.height,
                Text(languages.lblEveryday, style: primaryTextStyle(color: primaryColor)),
                8.height,
                HorizontalList(
                    padding: EdgeInsets.zero,
                    itemCount: weekdays.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(12),
                              color: selectedDay == index ? primaryOpacity : primaryColor,
                              child: Text(weekdays[index].substring(0, 1).toUpperCase(), style: boldTextStyle(color: selectedDay == index ? primaryColor : white)).center())
                          .cornerRadiusWithClipRRect(100)
                          .onTap(() {
                        selectedDay = index;
                        setState(() {});
                      });
                    }),
                8.height,
                Divider(),
                8.height,
                Text(languages.lblReminderName, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                8.height,
                AppTextField(
                  controller: mReminderNameCount,
                  textFieldType: TextFieldType.NAME,
                  isValidationRequired: true,
                  focus: mNameFocus,
                  nextFocus: mDescriptionFocus,
                  decoration: defaultInputDecoration(context, label: languages.lblEnterEmail),
                ),
                8.height,
                Text(languages.lblDescription, style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                8.height,
                AppTextField(
                  controller: mDescriptionCont,
                  textFieldType: TextFieldType.OTHER,
                  isValidationRequired: true,
                  focus: mDescriptionFocus,
                  decoration: defaultInputDecoration(context, label: languages.lblEnterEmail),
                ),
                16.height,
                AppButton(
                  text: languages.lblSave,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    ReminderModel reminderModel = ReminderModel();
                    reminderModel.id = notificationStore.mRemindList.length + 1;
                    reminderModel.status = 0;
                    reminderModel.duration = _dateTime.toString();
                    reminderModel.week = selectedDay.toString();
                    reminderModel.title = mReminderNameCount.text.trim();
                    reminderModel.subTitle = mDescriptionCont.text.trim();
                    notificationStore.addToReminder(reminderModel);
                    NotificationWeekAndTime(dayOfTheWeek: selectedDay!, timeOfDay: _dateTime, title: "Better We", subTitle: "Testing");
                    setState(() {});
                  },
                ),
                16.height,
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }

  Widget hourMinute12H() {
    return new TimePickerSpinner(
      spacing: 50,
      normalTextStyle: boldTextStyle(size: 24, color: textColor),
      highlightedTextStyle: boldTextStyle(size: 28),
      alignment: Alignment.center,
      is24HourMode: false,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
