import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart' ;



class GraficoRepresentantePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('D\'Chart')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartBarO(
                vertical: false,
                groupList: [
                  OrdinalGroup(
                    id: '1',
                    data: [
                      OrdinalData(domain: 'Marcos', measure: 2),
                      OrdinalData(domain: 'Paulo', measure: 6),
                      OrdinalData(domain: 'Mario', measure: 3),
                      OrdinalData(domain: 'João', measure: 7),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}