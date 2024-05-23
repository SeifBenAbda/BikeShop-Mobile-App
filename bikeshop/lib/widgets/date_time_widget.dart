import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndTimeWidget extends StatefulWidget {
  final String myLang;

  const DateAndTimeWidget({Key? key, required this.myLang}) : super(key: key);

  @override
  _DateAndTimeWidgetState createState() => _DateAndTimeWidgetState();
}

class _DateAndTimeWidgetState extends State<DateAndTimeWidget> {
  late String _formattedDateTime;
  late DateFormat dateFormat;
  late DateFormat timeFormat;
  late DateFormat _dateTimeFormat;
  late String _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.myLang == 'de' ? 'de_DE' : 'en_US';
    dateFormat = DateFormat('dd.MM.yyyy', _locale);
    timeFormat = DateFormat('HH:mm:ss', _locale);
    _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm:ss', _locale);
    _updateDateTime();
  }

  void _updateDateTime() {
    if (mounted) {
      setState(() {
        _formattedDateTime = _dateTimeFormat.format(DateTime.now());
      });
    }
    Future.delayed(const Duration(seconds: 1), _updateDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width / 1.1,
      child: Text(
        _formattedDateTime,
        style: getTextStyleAbel(20, greyColor),
        textAlign: TextAlign.left,
      ),
    );
  }
}
