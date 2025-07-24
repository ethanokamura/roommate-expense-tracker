import 'package:app_ui/src/data/data_type.dart';
import 'package:app_ui/src/numbers.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({
    required this.values,
    this.titles = const [],
    this.dataType = ChartDataType.isDouble,
    this.avg,
    super.key,
  });
  final List<double> values;
  final List<String> titles;
  final String dataType;
  final double? avg;
  @override
  Widget build(BuildContext context) {
    return PageLoader(
      duration: 150,
      child: (loaded) => CustomLineChartView(
        hasLoaded: loaded,
        values: values,
        titles: titles,
        dataType: dataType,
        avg: avg,
      ),
    );
  }
}

class CustomLineChartView extends StatelessWidget {
  const CustomLineChartView({
    required this.hasLoaded,
    required this.values,
    required this.titles,
    required this.dataType,
    this.avg,
    super.key,
  });
  final bool hasLoaded;
  final List<double> values;
  final List<String> titles;
  final String dataType;
  final double? avg;
  @override
  Widget build(BuildContext context) {
    final double maxValue = values.isNotEmpty
        ? values.reduce((curr, next) => curr > next ? curr : next)
        : 0;
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: LineChart(
          duration: const Duration(milliseconds: 1000),
          // curve: Curves.ease,
          hasLoaded && values.isNotEmpty
              ? _mainData(
                  context,
                  values,
                  maxValue,
                  avg,
                  titles,
                  dataType,
                )
              : _dummyData(
                  context,
                  values,
                  maxValue,
                  dataType,
                ),
        ),
      ),
    );
  }
}

List<FlSpot> getSpots(List<double> values) {
  List<FlSpot> data = [];
  for (int i = 0; i < values.length; i++) {
    data.add(FlSpot(i.toDouble(), values[i]));
  }
  return data;
}

List<int> getDatesList(DateTime startDate, int len) {
  List<int> dates = [];
  for (int i = len; i >= 0; i--) {
    dates.add(DateTime.now().subtract(Duration(days: i)).weekday - 1);
  }
  return dates;
}

List<FlSpot> _dummyValues(int len) {
  List<FlSpot> values = [];
  for (int i = 0; i < len; i++) {
    values.add(FlSpot(i.toDouble(), 0));
  }
  return values;
}

LineTouchData lineTouchData(
  BuildContext context,
  String dataType,
) =>
    LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => context.theme.backgroundColor,
        getTooltipItems: (touchedSpots) => touchedSpots.map((barSpot) {
          String toolTipText = '';
          switch (dataType) {
            case ChartDataType.isDouble:
              toolTipText = barSpot.y.toString();
            case ChartDataType.isCurrency:
              toolTipText = formatCurrency(barSpot.y);
            case ChartDataType.isInt:
              toolTipText = barSpot.y.toInt().toString();
          }

          return LineTooltipItem(toolTipText, AppTextStyles.secondary);
        }).toList(),
      ),
    );

List<FlSpot> avgLine(double avg, int len) {
  List<FlSpot> values = [];
  for (int i = 0; i < len; i++) {
    values.add(FlSpot(i.toDouble(), avg));
  }
  return values;
}

LineChartData _mainData(
  BuildContext context,
  List<double> values,
  double maxValue,
  double? avg,
  List<String> titles,
  String dataType,
) =>
    LineChartData(
      maxX: (values.length - 1).toDouble(),
      maxY: maxValue * 1.1,
      minX: 0,
      minY: 0,
      lineTouchData: lineTouchData(context, dataType),
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(values),
          isCurved: true,
          barWidth: 3,
          curveSmoothness: 0.15,
          preventCurveOverShooting: true,
          color: values[values.length - 1] - values[0] < 0
              ? context.theme.errorColor
              : context.theme.accentColor,
          // gradient: LinearGradient(
          //   colors: [
          //     chartColors[0],
          //     chartColors[1],
          //     chartColors[2],
          //   ],
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          // ),
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                context.theme.primaryColor,
                // chartColors[0],
                // chartColors[1],
                values[values.length - 1] - values[0] < 0
                    ? context.theme.errorColor
                    : context.theme.accentColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            // color: chartColors[0].withAlpha(150),
          ),
          dotData: const FlDotData(
            show: false,
          ),
          // shadow: Shadow(
          //   color: context.theme.accentColor,
          //   blurRadius: 4,
          // ),
        ),
        if (avg != null)
          LineChartBarData(
            spots: avgLine(avg, values.length),
            barWidth: 3,
            preventCurveOverShooting: false,
            color: context.theme.accentColor.withAlpha(150),
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
      ],
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, values.length, titles),
          ),
        ),
      ),
      gridData: const FlGridData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
    );

LineChartData _dummyData(
  BuildContext context,
  List<double> values,
  double maxValue,
  String dataType,
) =>
    LineChartData(
      maxX: (values.length).toDouble(),
      maxY: maxValue * 1.1,
      minY: 0,
      minX: 0,
      lineTouchData: lineTouchData(context, dataType),
      lineBarsData: [
        LineChartBarData(
          spots: _dummyValues(values.length),
          isCurved: true,
          barWidth: 6,
          curveSmoothness: 0.15,
          preventCurveOverShooting: true,
          color: values[values.length - 1] - values[0] < 0
              ? context.theme.errorColor
              : context.theme.accentColor,
          // gradient: LinearGradient(
          //   colors: [
          //     chartColors[0],
          //     chartColors[1],
          //     chartColors[2],
          //   ],
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          // ),
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                context.theme.primaryColor,
                // chartColors[0],
                // chartColors[1],
                values[values.length - 1] - values[0] < 0
                    ? context.theme.errorColor
                    : context.theme.accentColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            // color: chartColors[0].withAlpha(150),
          ),
          dotData: const FlDotData(
            show: false,
          ),
          // shadow: Shadow(
          //   color: context.theme.accentColor,
          //   blurRadius: 4,
          // ),
        ),
      ],
      titlesData: const FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
    );

Widget bottomTitleWidgets(
  double value,
  TitleMeta meta,
  int len,
  List<String> titles,
) {
  final dates = getDatesList(DateTime.now(), len);
  final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  return SideTitleWidget(
    meta: meta,
    child: CustomText(
      text: titles.isEmpty
          ? weekDays[dates[value.toInt()]]
          : titles[value.toInt()],
      style: AppTextStyles.secondary,
      fontSize: 12,
    ),
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  return SideTitleWidget(
    meta: meta,
    child: CustomText(
      text: value.toString(),
      style: AppTextStyles.secondary,
      fontSize: 12,
    ),
  );
}
