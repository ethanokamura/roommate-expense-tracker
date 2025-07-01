import 'package:app_ui/src/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:flutter/material.dart';

class LineChartView extends StatelessWidget {
  const LineChartView({
    required this.values,
    required this.showTitles,
    this.avg,
    super.key,
  });
  final List<double> values;
  final bool showTitles;
  final double? avg;
  @override
  Widget build(BuildContext context) {
    return PageLoader(
      duration: 150,
      child: (loaded) => CustomLineChart(
        hasLoaded: loaded,
        values: values,
        avg: avg,
        showTitles: showTitles,
      ),
    );
  }
}

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({
    required this.hasLoaded,
    required this.values,
    required this.showTitles,
    this.avg,
    super.key,
  });
  final bool hasLoaded;
  final List<double> values;
  final bool showTitles;
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
          curve: Curves.ease,
          hasLoaded && values.isNotEmpty
              ? _mainData(context, values, maxValue, avg, showTitles)
              : _dummyData(context, values, maxValue, showTitles),
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
    dates.add(DateTime.now().subtract(Duration(days: i)).day);
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

LineTouchData lineTouchData(BuildContext context) => LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => context.theme.surfaceColor,
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
  bool showTitles,
) =>
    LineChartData(
      maxX: (values.length - 1).toDouble(),
      maxY: maxValue * 1.1,
      minX: 0,
      minY: 0,
      lineTouchData: lineTouchData(context),
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(values),
          isCurved: true,
          barWidth: 6,
          curveSmoothness: 0.5,
          preventCurveOverShooting: true,
          color: context.theme.dangerLevelColors[
              values[values.length - 1] - values[0] < 0 ? 2 : 0],
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
                context.theme.colorScheme.surface,
                // chartColors[0],
                // chartColors[1],
                context.theme.dangerLevelColors[
                    values[values.length - 1] - values[0] < 0 ? 2 : 0],
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
            preventCurveOverShooting: true,
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
            showTitles: showTitles,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, values.length),
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
  bool showTitles,
) =>
    LineChartData(
      maxX: (values.length - 1).toDouble(),
      maxY: maxValue * 1.1,
      minY: 0,
      minX: 0,
      lineTouchData: lineTouchData(context),
      lineBarsData: [
        LineChartBarData(
          spots: _dummyValues(values.length),
          isCurved: true,
          barWidth: 6,
          curveSmoothness: 0.5,
          preventCurveOverShooting: true,
          color: context.theme.dangerLevelColors[
              values[values.length - 1] - values[0] < 0 ? 2 : 0],
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
                context.theme.surfaceColor,
                // chartColors[0],
                // chartColors[1],
                context.theme.dangerLevelColors[
                    values[values.length - 1] - values[0] < 0 ? 2 : 0],
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
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: showTitles,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, meta, values.length),
          ),
        ),
      ),
      gridData: const FlGridData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
    );

Widget bottomTitleWidgets(double value, TitleMeta meta, int len) {
  final dates = getDatesList(DateTime.now(), len);
  return SideTitleWidget(
    meta: meta,
    child: CustomText(
      text: dates[value.toInt()].toString(),
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
