import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTtitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 2:
                    return const Text('MAR');
                  case 5:
                    return const Text('JUN');
                  case 8:
                    return const Text('SEP');
                }
                return const Text('');
              }),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toDouble()) {
                  case 1.0:
                    return const Text(
                      '10k',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    );
                  case 3.0:
                    return const Text(
                      '30k',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    );
                  case 5.0:
                    return const Text(
                      '50k',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    );
                }
                return const Text('');
              }),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );
}
