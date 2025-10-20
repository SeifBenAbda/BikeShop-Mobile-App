import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GridData {
  String? orderType;
  ValueNotifier? numberOders;
  Color? gridColor;
  Color? textColor;

  GridData(
      {required this.orderType,
      required this.numberOders,
      required this.gridColor,
      required this.textColor});
}

class GlobalStatsWidget extends StatefulWidget {
  final List<GridData> listData;
  const GlobalStatsWidget({super.key, required this.listData});

  @override
  State<GlobalStatsWidget> createState() => _GlobalStatsWidgetState();
}

class _GlobalStatsWidgetState extends State<GlobalStatsWidget> {
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: SfCircularChart(
        borderWidth: 1,
        legend: Legend(
            width: "90%",
            height: "50%",
            position: LegendPosition.bottom,
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: getTextStyleAbel(15, greyColor)),
        series: <CircularSeries>[
          PieSeries<GridData, String>(
              pointColorMapper: (GridData data, _) => data.gridColor,
              dataSource: widget.listData,
              xValueMapper: (GridData data, _) =>
                  getText(context, data.orderType!),
              yValueMapper: (GridData data, _) =>
                  int.parse(data.numberOders!.value.toString()),
              dataLabelMapper: (GridData data, _) =>
                  data.numberOders!.value.toString(),
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle:
                      getTextStyleAbel(17, bgColor)))
        ],
      ),
    );
  }
}
