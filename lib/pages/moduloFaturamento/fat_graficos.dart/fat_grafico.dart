import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pedidocompra/pages/moduloFaturamento/fat_graficos.dart/linhas_titulos.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

   final List<Color> gradientColors2 = [
    const Color.fromARGB(115, 35, 181, 230),
    const Color.fromARGB(118, 2, 211, 155),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Gráfico",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),      
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: LineChart(          
              LineChartData(                 
                backgroundColor: const Color.fromARGB(255, 3, 41, 71),          
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                titlesData: LineTtitles.getTitleData(),
                gridData: FlGridData(            
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xff37434d),
                      strokeWidth: 1,
                    );
                  },
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color(0xff37434d),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(                
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    )),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(2.6, 2),
                      const FlSpot(4.9, 5),
                      const FlSpot(6.8, 2.5),
                      
                    ],
                    isCurved: true,
                    gradient: LinearGradient(colors: gradientColors),
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(colors: gradientColors2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
