import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

import '../views/client/Fix Bicycle/fix_bike_func.dart';

ValueNotifier<DateTime> dateTimeAppoitmentNotifier =
    ValueNotifier<DateTime>(DateTime.now());

ValueNotifier? dateAppointmentController = ValueNotifier<dynamic>("");

ValueNotifier? timeAppointmentController = ValueNotifier<dynamic>("");

ValueNotifier<DateTime> dateTimeTaskNotifier =
    ValueNotifier<DateTime>(DateTime.now());

BoardDateTimeTextController dateTextController = BoardDateTimeTextController();

BoardDateTimeTextController timeTextController = BoardDateTimeTextController();

class AppointmentPicker extends StatefulWidget {
  final DateTime initialDate;
  final bool isReadOnly;
  const AppointmentPicker(
      {super.key, required this.initialDate, required this.isReadOnly});

  @override
  State<AppointmentPicker> createState() => _AppointmentPickerState();
}

class _AppointmentPickerState extends State<AppointmentPicker> {
  @override
  void initState() {
    super.initState();
    initialeDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.1, child: datePicker());
  }

  //--------------Date Picker

  Widget datePicker() {
    return Row(
      children: [datePickedWidget(), chooseDateButton()],
    );
  }

  Widget datePickedWidget() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.3,
      // decoration: textFieldTaskDeco,
      child: Row(
        children: [
          dateTextField(),
          const SizedBox(
            width: 20,
          ),
          timeTextField()
        ],
      ),
    );
  }

  Widget dateTextField() {
    return Container(
      decoration: getBoxDeco(12, greyColor),
      width: MediaQuery.of(context).size.width / 3,
      child: ValueListenableBuilder<DateTime>(
          valueListenable: dateTimeAppoitmentNotifier,
          builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BoardDateTimeInputField(
                delimiter: currentFallBackFile.value == "de" ? '.' : '/',
                enabled: !widget.isReadOnly,
                initialDate: dateTimeTaskNotifier.value,
                cursorColor: bgColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: dateTextController,
                pickerType: DateTimePickerType.date,
                options: BoardDateTimeOptions(
                  weekend: const BoardPickerWeekendOptions(
                    sundayColor: greyColor,
                    saturdayColor: greyColor,
                  ),
                  pickerFormat: PickerFormat.dmy,
                  pickerSubTitles: BoardDateTimeItemTitles(
                      year: getText(context, "year"),
                      day: getText(context, "day"),
                      month: getText(context, "month"),
                      minute: getText(context, "minute"),
                      hour: getText(context, "hour")),
                  foregroundColor: blueColor1,
                  backgroundColor: blueColor,
                  activeTextColor: blueColor,
                  textColor: greyColor,
                  activeColor: greyColor,
                  languages: BoardPickerLanguages(
                    locale: currentFallBackFile.value,
                    today: getText(context, "today"),
                    tomorrow: getText(context, "tomorrow"),
                    now: getText(context, "now"),
                  ),
                ),
                textStyle: getTextStyleAbel(16, bgColor),
                onChanged: (date) {
                  setState(() {
                    dateAppointmentController!.value =
                        setupDateFromInputWithoutTimeWithSlach(date);
                  });
                },
                onFocusChange: (val, date, text) {
                  print('on focus changed date: $val, $date, $text');
                  setState(() {
                    dateAppointmentController!.value = text;
                  });
                  print(
                      "New Date Without Time From Field : ${dateAppointmentController!.value}");
                },
              ),
            );
          }),
    );
  }

  Widget timeTextField() {
    return Container(
      decoration: getBoxDeco(12, greyColor),
      width: MediaQuery.of(context).size.width / 5,
      child: ValueListenableBuilder(
          valueListenable: dateTimeTaskNotifier,
          builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: BoardDateTimeInputField(
                enabled: !widget.isReadOnly,
                keyboardType: TextInputType.datetime,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                controller: timeTextController,
                initialDate: dateTimeTaskNotifier.value,
                pickerType: DateTimePickerType.time,
                options: BoardDateTimeOptions(
                  weekend: const BoardPickerWeekendOptions(
                    sundayColor: greyColor,
                    saturdayColor: greyColor,
                  ),
                  pickerFormat: PickerFormat.dmy,
                  pickerSubTitles: BoardDateTimeItemTitles(
                      year: getText(context, "year"),
                      day: getText(context, "day"),
                      month: getText(context, "month"),
                      minute: getText(context, "minute"),
                      hour: getText(context, "hour")),
                  foregroundColor: blueColor1,
                  backgroundColor: blueColor,
                  activeTextColor: blueColor,
                  textColor: greyColor,
                  activeColor: greyColor,
                  languages: BoardPickerLanguages(
                    locale: currentFallBackFile.value,
                    today: getText(context, "today"),
                    tomorrow: getText(context, "tomorrow"),
                    now: getText(context, "now"),
                  ),
                ),
                textStyle: getTextStyleAbel(16, bgColor),
                onChanged: (date) {
                  print('onchanged: $date');
                  setState(() {
                    timeAppointmentController!.value =
                        setupTimeFromInputWithoutDate(date);
                  });
                },
                onFocusChange: (val, date, text) {
                  print('on focus changed date: $val, $date, $text');
                  setState(() {
                    timeAppointmentController!.value = text;
                  });
                  print(
                      "New TIME Without DATE From Field : ${timeAppointmentController!.value}");
                },
              ),
            );
          }),
    );
  }

  Widget chooseDateButton() {
    return InkWell(
      onTap: () {
        showDateTimePickerFn();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: getBoxDeco(12, greyColor),
        child: const Center(
          child: Icon(
            Icons.calendar_month_outlined,
            color: bgColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  void showDateTimePickerFn() async {
    final result = await showBoardDateTimePicker(
      minimumDate: DateTime.now(),
      initialDate: DateTime.now(),
      valueNotifier: dateTimeTaskNotifier,
      options: BoardDateTimeOptions(
        weekend: const BoardPickerWeekendOptions(
          sundayColor: greyColor,
          saturdayColor: greyColor,
        ),
        pickerFormat: PickerFormat.dmy,
        pickerSubTitles: BoardDateTimeItemTitles(
            year: getText(context, "year"),
            day: getText(context, "day"),
            month: getText(context, "month"),
            minute: getText(context, "minute"),
            hour: getText(context, "hour")),
        foregroundColor: blueColor1,
        backgroundColor: blueColor,
        activeTextColor: blueColor,
        textColor: greyColor,
        activeColor: greyColor,
        languages: BoardPickerLanguages(
          locale: currentFallBackFile.value,
          today: getText(context, "today"),
          tomorrow: getText(context, "tomorrow"),
          now: getText(context, "now"),
        ),
      ),
      context: context,
      pickerType: DateTimePickerType.datetime,
    );
    if (result != null) {
      DateFormat format = currentFallBackFile.value == "de"
          ? DateFormat.yMd('de_DE')
          : DateFormat('dd/M/yyyy');
      setState(() {
        dateTimeTaskNotifier.value = result;
        dateTimeAppoitmentNotifier.value = dateTimeTaskNotifier.value;
        dateAppointmentController!.value =
            setupDateFromInputWithoutTimeWithSlach(dateTimeTaskNotifier.value);
        timeAppointmentController!.value =
            "${dateTimeTaskNotifier.value.hour}:${dateTimeTaskNotifier.value.minute}";
    
        dateTextController.setText(dateAppointmentController!.value);
        timeTextController.setText(timeAppointmentController!.value);
        dateTextController
            .setDate(format.parse(dateAppointmentController!.value));
      });
      updateAppointementDay();
    }
  }

  void initialeDateTime() {
    setState(() {
      dateTimeAppoitmentNotifier.value = widget.initialDate;
      dateTimeTaskNotifier.value = widget.initialDate;
    });
    print("Notifier value: ${dateTimeTaskNotifier.value}");
  }
}
