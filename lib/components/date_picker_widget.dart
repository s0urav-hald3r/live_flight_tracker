import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final controller = HomeController.instance;
  List<DateTime> selectedDates = [];

  @override
  void initState() {
    super.initState();
    controller.selectedDates = selectedDates;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        color: bgColor,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                child: const Text(
                  'Select date',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: whiteColor,
                  ),
                ),
              ),
              CleanCalendar(
                // Enabling selecting single or multiple dates. Defaults to disable selection.
                dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
                // Setting custom weekday symbols
                weekdaysSymbol: const Weekdays(
                  sunday: "Sun",
                  monday: "Mon",
                  tuesday: "Tue",
                  wednesday: "Wed",
                  thursday: "Thu",
                  friday: "Fri",
                  saturday: "Sat",
                ),
                // Setting current date of calendar.
                currentDateOfCalendar: DateTime.now(),
                headerProperties: HeaderProperties(
                  monthYearDecoration: MonthYearDecoration(
                    monthYearTextColor: primaryColor,
                    monthYearTextStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  navigatorDecoration: NavigatorDecoration(
                    navigatorResetButtonIcon: const Icon(
                      Icons.restart_alt,
                      color: primaryColor,
                    ),
                    navigateLeftButtonIcon: const Icon(
                      Icons.arrow_circle_left,
                      color: primaryColor,
                    ),
                    navigateRightButtonIcon: const Icon(
                      Icons.arrow_circle_right,
                      color: primaryColor,
                    ),
                  ),
                ),
                weekdaysProperties: WeekdaysProperties(
                  generalWeekdaysDecoration: WeekdaysDecoration(
                    weekdayTextColor: whiteColor,
                  ),
                ),
                leadingTrailingDatesProperties: DatesProperties(
                  datesDecoration: DatesDecoration(
                    datesBackgroundColor: Colors.transparent,
                    datesBorderColor: Colors.transparent,
                    datesTextColor: textColor,
                  ),
                ),
                generalDatesProperties: DatesProperties(
                  datesDecoration: DatesDecoration(
                    datesBackgroundColor: Colors.transparent,
                    datesBorderColor: Colors.transparent,
                    datesTextColor: Colors.white,
                  ),
                ),
                currentDateProperties: DatesProperties(
                  datesDecoration: DatesDecoration(
                    datesBackgroundColor: Colors.transparent,
                    datesBorderColor: primaryColor,
                    datesTextColor: Colors.white,
                  ),
                ),
                selectedDatesProperties: DatesProperties(
                  datesDecoration: DatesDecoration(
                    datesBackgroundColor: primaryColor,
                    datesBorderColor: primaryColor,
                    datesTextColor: Colors.white,
                  ),
                ),
                onSelectedDates: (List<DateTime> value) {
                  debugPrint('Selected date: $value');
                  controller.selectedDates = value;
                  setState(() {
                    selectedDates = value;
                  });
                },
                // Providing calendar the dates to select in ui.
                selectedDates: selectedDates,
              ),
              Divider(
                height: 48.h,
                color: textColor,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: 160.w,
                  height: 48.h,
                  margin: EdgeInsets.only(left: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: whiteColor,
                  ),
                  child: ElevatedButton(
                    child: const Text(
                      'Cancle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: bgColor,
                      ),
                    ),
                    onPressed: () {
                      NavigatorKey.pop();
                    },
                  ),
                ),
                Container(
                  width: 160.w,
                  height: 48.h,
                  margin: EdgeInsets.only(right: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: primaryColor,
                  ),
                  child: ElevatedButton(
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                    ),
                    onPressed: () {
                      controller.setSelectedDate();
                      NavigatorKey.pop();
                    },
                  ),
                ),
              ])
            ]),
      );
    });
  }
}
