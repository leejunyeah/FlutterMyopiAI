import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_myopia_ai/chart/activity_chart.dart';

class ChartWidget extends StatelessWidget {

  final List<charts.Series<ActivityData, String>> seriesList;
  final List<charts.TickSpec<String>> ticks;

  ChartWidget({this.seriesList, this.ticks});

  @override
  Widget build(BuildContext context) {
    return _buildBarChart();
  }

  Widget _buildBarChart() {
    return new charts.BarChart(
      seriesList,
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        tickProviderSpec: charts.StaticOrdinalTickProviderSpec(ticks),
      ),
      defaultRenderer: charts.BarRendererConfig<String>(
        cornerStrategy: const charts.ConstCornerStrategy(6),
      ),
      behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
    );
  }
}

