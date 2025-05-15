import 'package:flutter/material.dart';
import 'package:litmedia/static/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartTwo extends StatelessWidget {
  const ChartTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 240,
        width: 240,
        child: SfCircularChart(
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
          ),
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: <ChartData>[
                ChartData('Category A', 35, 'Size A', AppColors.mediumPurple),
                ChartData('Category B', 30, 'Size B', AppColors.vibrantBlue),
                ChartData('Category C', 35, 'Size C', AppColors.gris),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              startAngle: 90,
              endAngle: 90,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.size, this.color);
  final String x;
  final double y;
  final String size;
  final Color color;
}
