import 'dart:math' as math;

import 'package:edemand_partner/data/model/statistics_model.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyEarningBarChart extends StatefulWidget {
  final List<MonthlySales> monthlySales;

  const MonthlyEarningBarChart({Key? key, required this.monthlySales}) : super(key: key);

  @override
  State<MonthlyEarningBarChart> createState() => _MonthlyEarningBarChartState();
}

class _MonthlyEarningBarChartState extends State<MonthlyEarningBarChart> {
  int maxAmount = 0;

  @override
  void initState() {
    if (widget.monthlySales.isNotEmpty) {
      List<int> list = widget.monthlySales.map((e) => int.parse(e.totalAmount!)).toList();

      maxAmount = list.reduce(math.max);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "monthlySales".translate(context: context),
          style: TextStyle(
            color: Theme.of(context).colorScheme.headingFontColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: BarChart(
            mainBarData(),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y,
      {bool isTouched = false,
      double width = 22,
      List<int>? showTooltips,
      LinearGradient? barChartRodGradient}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          gradient: barChartRodGradient ??
              LinearGradient(
                  colors: [Colors.green.shade300, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
          toY: isTouched ? y + 1 : y,
          width: width,
          /* color: isTouched
              ? Theme.of(context).colorScheme.headingFontColor.withOpacity(0.5)
              : Theme.of(context).colorScheme.headingFontColor,*/
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          borderSide: isTouched
              ? BorderSide(color: Theme.of(context).colorScheme.headingFontColor)
              : BorderSide(
                  color: Theme.of(context).colorScheme.headingFontColor.withOpacity(0.7), width: 0),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(widget.monthlySales.length, (index) {
      int? colorIndex;
      colorIndex = index >= gradientColorForBarChart.length ? findColorIndex(index: index) : index;
      return makeGroupData(index, double.parse(widget.monthlySales[index].totalAmount!),
          width: 50, barChartRodGradient: gradientColorForBarChart[colorIndex!]);
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      maxY: maxAmount + 200,
      alignment: BarChartAlignment.spaceEvenly,
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      barTouchData: BarTouchData(
        enabled: true,
        touchCallback: (e, f) {},
        touchTooltipData: BarTouchTooltipData(
          // tooltipBgColor: ColorsRes.appColor,
          tooltipBgColor: Theme.of(context).colorScheme.headingFontColor,

          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String selectedDate = widget.monthlySales[group.x].month ?? "";
            String salesCount = widget.monthlySales[group.x].totalAmount ?? "";
            return BarTooltipItem(
                "",
                TextStyle(
                  color: Theme.of(context).colorScheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: "$selectedDate\n",
                  ),
                  TextSpan(
                      text: UiUtils.getPriceFormat(context, double.parse(salesCount)),
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic))
                ]);
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getMonthTitle,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxAmount / 4,
            reservedSize: 38,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Theme.of(context).colorScheme.headingFontColor),
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
      ),
    );
  }

  Widget getMonthTitle(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text("${widget.monthlySales[value.toInt()].month}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          softWrap: true),
    );
  }

  findColorIndex({required int index}) {
    int difference = index - gradientColorForBarChart.length;
    if (difference < gradientColorForBarChart.length) {
      return difference;
    }
    return findColorIndex(index: index);
  }
}
