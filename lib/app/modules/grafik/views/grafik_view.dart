import 'package:attendance/app/cores/core_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../cores/core_images.dart';
import '../controllers/grafik_controller.dart';

class GrafikView extends GetView<GrafikController> {
  const GrafikView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 10, Colors.red),
      ChartData('Steve', 20, Colors.purple),
      ChartData('Others', 70, Colors.deepPurple),
    ];

    final List<ChartData> data = [
      ChartData('Jan', 12),
      ChartData('Feb', 15),
      ChartData('Mar', 30),
      ChartData('Apr', 6.4),
      ChartData('Mei', 14),
      ChartData('Jun', 24),
      ChartData('Jul', 26),
      ChartData('Agu', 20),
      ChartData('Sep', 12),
      ChartData('Okt', 29),
      ChartData('Nop', 20),
      ChartData('Des', 19),
    ];
    final List<ChartData> data1 = [
      ChartData('Jan', 2),
      ChartData('Feb', 5),
      ChartData('Mar', 3),
      ChartData('Apr', 6),
      ChartData('Mei', 4),
      ChartData('Jun', 2),
      ChartData('Jul', 2),
      ChartData('Agu', 2),
      ChartData('Sep', 1),
      ChartData('Okt', 9),
      ChartData('Nop', 2),
      ChartData('Des', 9),
    ];
    final List<ChartData> data2 = [
      ChartData('Jan', 1),
      ChartData('Feb', 1),
      ChartData('Mar', 2),
      ChartData('Apr', 2),
      ChartData('Mei', 1),
      ChartData('Jun', 1),
      ChartData('Jul', 3),
      ChartData('Agu', 1),
      ChartData('Sep', 5),
      ChartData('Okt', 1),
      ChartData('Nop', 1),
      ChartData('Des', 3),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              CoreImages.backTopImages,
              width: 250,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              child: Image.asset(
                CoreImages.backBotImages,
                height: 130,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              children: [
                Expanded(
                    child: SfCircularChart(series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartData, String>(
                      dataSource: chartData,
                      // Segments will explode on tap
                      explode: true,
                      // First segment will be exploded on initial rendering
                      explodeIndex: 0,
                      dataLabelSettings: const DataLabelSettings(
                        // Renders the data label
                        isVisible: true,
                      ),
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ])),
                Expanded(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis:
                          NumericAxis(minimum: 0, maximum: 30, interval: 5),
                      series: <ChartSeries<ChartData, String>>[
                        ColumnSeries<ChartData, String>(
                            dataSource: data,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            name: 'Hadir',
                            color: Colors.deepPurple),
                        ColumnSeries<ChartData, String>(
                            dataSource: data1,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            name: 'Izin',
                            color: Colors.green),
                        ColumnSeries<ChartData, String>(
                            dataSource: data2,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            name: 'Alpa',
                            color: Colors.red),
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
