export 'small_line_chart.dart';
import 'package:app_ui/src/data/data_type.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/numbers.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/widgets.dart';

import '../data/line_chart.dart';
import 'package:flutter/material.dart';

class LargeCustomLineChart extends StatelessWidget {
  const LargeCustomLineChart({
    required this.title,
    required this.unit,
    required this.values,
    this.dataType = ChartDataType.isDouble,
    this.titles = const [],
    super.key,
  });
  final String title;
  final String unit;
  final List<String> titles;
  final List<double> values;
  final String dataType;
  @override
  Widget build(BuildContext context) {
    final current = values[values.length - 1];
    final previous = values[0];
    final diff = current - previous;
    final stat = calculatePercentChange(current, previous);
    return DefaultContainer(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                autoSize: true,
                text: title,
                style: AppTextStyles.primary,
                maxLines: 1,
              ),
              const HorizontalSpacer(),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: unit,
                      autoSize: true,
                      style: AppTextStyles.primary,
                      color: diff > 0
                          ? context.theme.accentColor
                          : context.theme.errorColor,
                    ),
                    CustomText(
                      autoSize: true,
                      text: current == 0
                          ? '(N/A)'
                          : '(${diff > 0 ? '+' : diff == 0 ? '' : '-'}${formatPercentChange(stat)})',
                      style: AppTextStyles.secondary,
                      color: diff > 0
                          ? context.theme.accentColor
                          : context.theme.errorColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomLineChart(
            values: values,
            titles: titles,
            dataType: dataType,
          ),
        ],
      ),
    );
  }
}
