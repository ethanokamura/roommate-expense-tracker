import 'package:fl_chart/fl_chart.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:app_ui/src/text.dart';
import 'package:flutter/material.dart';

class PieChartView extends StatelessWidget {
  const PieChartView({
    required this.title,
    required this.data,
    this.size = 150,
    super.key,
  });
  final String title;
  final double size;
  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    return PageLoader(
      duration: 150,
      child: (loaded) => SizedBox(
        height: size,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomPieChart(
                hasLoaded: loaded,
                values: getInventoryValues(data),
              ),
            ),
            const HorizontalSpacer(multiple: 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: keys(context, data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> getInventoryKeys(Map<String, double> items) {
  List<String> keys = [];
  items.keys.forEach(keys.add);

  return keys;
}

List<double> getInventoryValues(Map<String, double> items) {
  List<double> values = [];
  items.values.forEach(values.add);
  double sum = values.reduce((value, element) => value + element);
  List<double> fractions = [];
  for (final value in values) {
    fractions.add((value / sum).toDouble() * 100);
  }
  return fractions;
}

List<Widget> keys(BuildContext context, Map<String, double> data) {
  List<Widget> children = [];
  int i = 0;
  for (var key in data.keys) {
    children.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          colorIndicator(context, i),
          const HorizontalSpacer(),
          Flexible(
            child: CustomText(text: key, style: AppTextStyles.secondary),
          ),
        ],
      ),
    );
    i++;
  }
  return children;
}

Widget colorIndicator(BuildContext context, int value) => SizedBox(
      width: 10,
      height: 10,
      child: Material(
        color: context.theme.chartColors[value],
      ),
    );

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({
    required this.hasLoaded,
    required this.values,
    super.key,
  });
  final bool hasLoaded;
  final List<double> values;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: PieChart(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.ease,
        hasLoaded && values.isNotEmpty
            ? _mainData(context, values)
            : _dummyData(context, _dummyValues),
      ),
    );
  }
}

const List<double> _dummyValues = [10, 10, 10];

PieChartData _mainData(BuildContext context, List<double> values) =>
    PieChartData(
      sections: getPieChartSections(context, values),
      borderData: FlBorderData(show: false),
    );

PieChartData _dummyData(BuildContext context, List<double> values) =>
    PieChartData(
      sections: getPieChartSections(context, values),
      borderData: FlBorderData(show: false),
    );

List<PieChartSectionData> getPieChartSections(
  BuildContext context,
  List<double> values,
) {
  List<PieChartSectionData> sectionData = [];
  for (int i = 0; i < values.length; i++) {
    sectionData.add(PieChartSectionData(
      value: values[i],
      color: context.theme.chartColors[i],
      showTitle: true,
      title: '${values[i].floor()}%',
    ));
  }
  return sectionData;
}
