import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/numbers.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/widgets.dart';
import 'dart:math';

import '../data/data.dart';
import 'package:flutter/material.dart';

class SmallCustomLineChart extends StatelessWidget {
  const SmallCustomLineChart({
    required this.title,
    required this.unit,
    required this.current,
    required this.previous,
    this.dataType = ChartDataType.isDouble,
    this.steps = 5,
    super.key,
  });
  final String title;
  final String unit;
  final int steps;
  final double current;
  final double previous;
  final String dataType;
  @override
  Widget build(BuildContext context) {
    final diff = current - previous;
    final stat = calculatePercentChange(current, previous);
    return DefaultContainer(
      child: Column(
        children: [
          CustomText(
            autoSize: true,
            text: title,
            style: AppTextStyles.primary,
            maxLines: 1,
          ),
          CustomLineChart(
            values: generateContinuousRandomGraphData(
              initialValue: previous,
              finalValue: current,
              numberOfPoints: steps,
              randomnessFactor: current / 2,
            ),
            dataType: dataType,
          ),
          CustomText(
            text: unit,
            autoSize: true,
            style: AppTextStyles.primary,
            color: diff > 0
                ? context.theme.successColor
                : context.theme.errorColor,
          ),
          CustomText(
            text:
                '${diff > 0 ? '+' : diff == 0 ? '' : '-'}${formatPercentChange(stat)}',
            style: AppTextStyles.primary,
            color: diff > 0
                ? context.theme.successColor
                : context.theme.errorColor,
          ),
        ],
      ),
    );
  }
}

List<double> generateContinuousRandomGraphData({
  required double initialValue,
  required double finalValue,
  required int numberOfPoints,
  double randomnessFactor = 1,
}) {
  if (numberOfPoints <= 1) {
    return [initialValue, finalValue];
  }

  List<double> data = [];
  double currentValue = initialValue;
  final double totalDifference = finalValue - initialValue;
  final double averageStep = totalDifference / (numberOfPoints - 1);

  Random random = Random();

  data.add(initialValue);

  for (int i = 1; i < numberOfPoints - 1; i++) {
    // Calculate a dynamic randomness factor that decreases as we approach the end
    // This helps the line converge smoothly to the finalValue
    double currentRandomness =
        randomnessFactor * (1 - (i / (numberOfPoints - 1)));

    // Generate a random deviation
    double deviation = (random.nextDouble() * 2 - 1) * currentRandomness;

    // Calculate the next value, biasing it towards the average step
    double nextValue = currentValue + averageStep + deviation;

    if (totalDifference > 0) {
      // Increasing trend
      if (nextValue > finalValue) {
        nextValue = finalValue -
            (currentRandomness * 0.1); // Small push back if overshoots
      }
      if (nextValue < initialValue && i < numberOfPoints / 2) {
        nextValue = initialValue +
            (currentRandomness * 0.1); // Small push up if undershoots early
      }
    } else {
      // Decreasing trend
      if (nextValue < finalValue) {
        nextValue = finalValue +
            (currentRandomness * 0.1); // Small push back if overshoots
      }
      if (nextValue > initialValue && i < numberOfPoints / 2) {
        nextValue = initialValue -
            (currentRandomness * 0.1); // Small push down if undershoots early
      }
    }

    currentValue = nextValue;
    data.add(currentValue);
  }

  data.add(finalValue); // Ensure the last value is exactly the final value

  return data;
}
