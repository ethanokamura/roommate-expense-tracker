import 'package:app_ui/src/numbers.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:flutter/material.dart';

class BarChartView extends StatelessWidget {
  const BarChartView({
    required this.values,
    required this.showTitles,
    this.avg,
    super.key,
  });
  final Map<String, double> values;
  final bool showTitles;
  final double? avg;

  @override
  Widget build(BuildContext context) {
    return PageLoader(
      duration: 150,
      child: (loaded) => CustomBarChart(
        hasLoaded: loaded,
        values: values,
        showTitles: showTitles,
      ),
    );
  }
}

Map<String, dynamic> _buildData(Map<String, double> valuePairs) {
  List<String> titles = valuePairs.keys.toList();
  List<double> values = valuePairs.values.toList();
  final max = values.isNotEmpty
      ? values.reduce((curr, next) => curr > next ? curr : next)
      : 0;
  Map<String, dynamic> data = {
    'titles': titles,
    'values': values,
    'max': max,
  };
  return data;
}

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({
    required this.hasLoaded,
    required this.values,
    required this.showTitles,
    this.avg,
    super.key,
  });
  final bool hasLoaded;
  final Map<String, double> values;
  final bool showTitles;
  final double? avg;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = _buildData(values);
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: defaultPadding,
          right: defaultPadding,
          bottom: defaultPadding,
          top: defaultPadding * 4,
        ),
        child: BarChart(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.ease,
          hasLoaded && values.isNotEmpty
              ? _mainData(
                  context,
                  data['titles']!,
                  data['values']!,
                  data['max']!,
                )
              : _dummyData(
                  context,
                  data['titles']!,
                  data['values']!,
                  data['max']!,
                ),
        ),
      ),
    );
  }
}

Widget getTitles(String title, double value, TitleMeta meta) {
  return SideTitleWidget(
    meta: meta,
    space: 4,
    child: CustomText(
      text: title,
      style: AppTextStyles.secondary,
      fontSize: 10,
    ),
  );
}

List<BarChartGroupData> _getData(BuildContext context, List<double> values) =>
    values
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                gradient: LinearGradient(
                  colors: [
                    context.theme.accentColor,
                    context.theme.dangerLevelColors[0],
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        )
        .toList();

List<BarChartGroupData> _getDummyData(
        BuildContext context, List<double> values) =>
    values
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: 0,
                gradient: LinearGradient(
                  colors: [
                    context.theme.dangerLevelColors[0],
                    context.theme.accentColor,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        )
        .toList();

BarChartData _mainData(
  BuildContext context,
  List<String>? titles,
  List<double> values,
  double maxValue,
) =>
    BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              formatNumber(rod.toY),
              TextStyle(
                color: context.theme.dangerLevelColors[0],
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: titles != null
              ? SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) =>
                      getTitles(titles[value.toInt()], value, meta),
                )
              : const SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _getData(context, values),
      gridData: const FlGridData(show: false),
      alignment: BarChartAlignment.spaceAround,
      maxY: maxValue,
    );

BarChartData _dummyData(
  BuildContext context,
  List<String>? titles,
  List<double> values,
  double maxValue,
) =>
    BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: context.theme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: titles != null
              ? SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) =>
                      getTitles(titles[value.toInt()], value, meta),
                )
              : const SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _getDummyData(context, values),
      gridData: const FlGridData(show: false),
      alignment: BarChartAlignment.spaceAround,
      maxY: maxValue,
    );
