import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../utils/Global Folder/glaobal_vars.dart';

var birthDayDate = ValueNotifier(DateTime(2000));

class DateBirthDaySelector extends StatefulWidget {
  const DateBirthDaySelector({super.key});

  @override
  State<DateBirthDaySelector> createState() => _DateBirthDaySelectorState();
}

class _DateBirthDaySelectorState extends State<DateBirthDaySelector> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentFallBackFile,
        builder: (context, value, _) {
          return Column(
            children: [
              inputHint(context),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 50,
                decoration: getBoxDeco(10, optionConColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    dateChequeTextWidget_(),
                    selectDateChequeWidget_(),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget dateChequeTextWidget_() {
    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
            horizontal: 10), // Optional: Add padding for better alignment
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            dateChequeFormat(birthDayDate.value),
            style: getTextStyleWhiteFjallone(15),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Widget selectDateChequeWidget_() {
    return InkWell(
      onTap: () {
        dateChequeSelectWidget();
      },
      child: Container(
        height: 30,
        decoration: getBoxDeco(5, blueColor),
        width: 30,
        child: const Icon(
          Icons.edit_calendar_outlined,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  dateChequeSelectWidget() async {
    final DateTime? picked = await showDatePicker(
      keyboardType: TextInputType.text,
      locale: Locale(currentFallBackFile.value),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: optionConColor,
            colorScheme: const ColorScheme.light(primary: bgColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: birthDayDate.value, // Refer step 1
      firstDate: birthDayDate.value,
      lastDate: DateTime(DateTime.now().year - 18),
    );
    if (picked != null) {
      setState(() {
        birthDayDate.value = picked;
      });
    }
  }

  Widget inputHint(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2 - 10,
      child: Text(
        FlutterI18n.translate(context, "dateOfBirth"),
        style: getTextStyleWhiteFjallone(15),
      ),
    );
  }

  //--- Useful Function ----
  String dateChequeFormat(DateTime selectedDateCHeque) {
    String day;
    String month;
    if (selectedDateCHeque.day < 10) {
      day = "0${selectedDateCHeque.day}";
    } else {
      day = selectedDateCHeque.day.toString();
    }

    if (selectedDateCHeque.month < 10) {
      month = "0${selectedDateCHeque.month}";
    } else {
      month = selectedDateCHeque.month.toString();
    }
    return "$day.$month.${selectedDateCHeque.year}";
  }
}
