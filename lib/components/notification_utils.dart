import 'package:flutter/material.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../models/reminder_model.dart';
import '../extensions/constants.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../extensions/widgets.dart';
import '../main.dart';
import '../utils/app_colors.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final DateTime timeOfDay;
  final String title;
  final String subTitle;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
    required this.title,
    required this.subTitle,
  });
}

class NotificationDaily {
  final int hour;
  final int min;

  NotificationDaily({
    required this.hour,
    required this.min,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(
  BuildContext context,
) async {
  List<String> weekdays = [
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
    'Every Sunday',
  ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;
  int? currentIndex = -1;
  await showInDialog(context,
      shape: RoundedRectangleBorder(borderRadius: radius()),
      builder: (_) => Container(
            width: context.width(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  decoration: boxDecorationWithShadow(backgroundColor: primaryColor, borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages.lblRepeat, style: boldTextStyle(size: 20, color: Colors.white)).paddingLeft(12),
                      CloseButton(color: Colors.white),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 8),
                  itemCount: weekdays.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile(
                      value: index,
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      groupValue: currentIndex,
                      activeColor: primaryColor,
                      title: Text(weekdays[index], style: primaryTextStyle()),
                      onChanged: (dynamic val) {
                        currentIndex = val;

                        selectedDay = index + 1;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
      contentPadding: EdgeInsets.zero);

  if (selectedDay != null) {
    timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          now.add(
            Duration(minutes: 1),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(primary: primaryColor),
            ),
            child: child!,
          );
        });

    if (timeOfDay != null) {
      String mTime = timeOfDay.format(context);
      ReminderModel reminderModel = ReminderModel();
      reminderModel.id = notificationStore.mRemindList.length + 1;
      reminderModel.status = 0;
      reminderModel.duration = mTime;
      reminderModel.week = weekdays[currentIndex!];
      reminderModel.title = "Better We";
      reminderModel.subTitle = "Testing";
      notificationStore.addToReminder(reminderModel);
      // return NotificationWeekAndTime(dayOfTheWeek: selectedDay!, timeOfDay: timeOfDay, title: "Better We", subTitle: "Testing");
    }
  }
  return null;
}
