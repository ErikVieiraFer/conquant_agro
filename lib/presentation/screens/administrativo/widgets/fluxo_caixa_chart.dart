import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

class FluxoCaixaData {
  String mes;
  double entradasProg;
  double entradasPrev;
  double saidasProg;
  double saidasPrev;
  double saldoPrev;

  FluxoCaixaData({
    required this.mes,
    required this.entradasProg,
    required this.entradasPrev,
    required this.saidasProg,
    required this.saidasPrev,
    required this.saldoPrev,
  });
}

class FluxoCaixaChart extends StatelessWidget {
  final List<FluxoCaixaData> data;

  const FluxoCaixaChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    groupsSpace: 20, // Espaço entre os grupos de meses
                    barTouchData: _buildBarTouchData(formatCurrency),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final month = data[value.toInt()].mes.split('-')[1];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 4, // Adicionado padding
                              child: Text(month, style: const TextStyle(fontSize: 10)),
                            );
                          },
                          interval: 1,
                          reservedSize: 20, // Adicionado reservedSize
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Usar formato compacto para economizar espaço
                            final text = NumberFormat.compactCurrency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 0).format(value);
                            // Adiciona um padding para ajustar a posição de um valor específico
                            if (text == 'R\$ 48 mil') {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0), // Move o texto para baixo
                                child: Text(text, style: const TextStyle(fontSize: 10)),
                              );
                            }
                            return Text(text, style: const TextStyle(fontSize: 10));
                          },
                          reservedSize: 45, // Ajustado para o novo formato
                          interval: _getInterval(_getMaxY(data)), // Intervalo dinâmico
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true, // Habilita as linhas verticais
                      verticalInterval: 1, // Uma linha por mês
                      getDrawingHorizontalLine: (value) {
                        // Linhas horizontais pontilhadas
                        return const FlLine(
                          color: Color(0xffe7e7e7),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        // Linhas verticais pontilhadas
                        return const FlLine(
                          color: Color(0xffe7e7e7),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true, // Mostra a borda ao redor do gráfico
                      border: Border.all(color: const Color(0xffe7e7e7), width: 1),
                    ),
                    barGroups: _buildBarGroups(data),
                  ),
                ),
                LineChart(
                  LineChartData(
                    lineTouchData: _buildLineTouchData(formatCurrency),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: data.length.toDouble() - 1,
                    minY: _getMinY(data),
                    maxY: _getMaxY(data),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.saldoPrev);
                        }).toList(),
                        isCurved: true,
                        color: AppColors.textPrimary, // Cor da linha do saldo
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  BarTouchData _buildBarTouchData(NumberFormat formatCurrency) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String label = rodIndex == 0 ? 'Entradas' : 'Saídas';
          return BarTooltipItem(
            '$label\n',
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: formatCurrency.format(rod.toY),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  LineTouchData _buildLineTouchData(NumberFormat formatCurrency) {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: AppColors.textPrimary.withOpacity(0.8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            return LineTooltipItem(
              'Saldo: ${formatCurrency.format(spot.y)}',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<FluxoCaixaData> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      FluxoCaixaData item = entry.value;

      final double entradasTotal = item.entradasProg + item.entradasPrev;
      final double saidasTotal = item.saidasProg + item.saidasPrev;

      return BarChartGroupData(
        x: index, // Mês
        barRods: [
          BarChartRodData( // Barra de Entradas
            toY: entradasTotal,
            width: 12,
            borderRadius: BorderRadius.zero,
            rodStackItems: [
              BarChartRodStackItem(0, item.entradasProg, AppColors.primary),
              BarChartRodStackItem(item.entradasProg, entradasTotal, AppColors.primary.withOpacity(0.3)),
            ],
          ),
          BarChartRodData( // Barra de Saídas
            toY: saidasTotal,
            width: 12,
            borderRadius: BorderRadius.zero,
            rodStackItems: [
              BarChartRodStackItem(0, item.saidasProg, AppColors.despesa),
              BarChartRodStackItem(item.saidasProg, saidasTotal, AppColors.despesa.withOpacity(0.3)),
            ],
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _LegendItem(color: AppColors.primary, text: 'Entrada Realizada'),
        _LegendItem(color: AppColors.primary.withOpacity(0.3), text: 'Entrada Prevista'),
        _LegendItem(color: AppColors.despesa, text: 'Saída Realizada'),
        _LegendItem(color: AppColors.despesa.withOpacity(0.3), text: 'Saída Prevista'),
        _LegendItem(color: AppColors.textPrimary, text: 'Saldo Previsto', isLine: true),
      ],
    );
  }

  double _getMinY(List<FluxoCaixaData> data) {
    if (data.isEmpty) return 0;
    final minSaldo = data.map((e) => e.saldoPrev).reduce((a, b) => a < b ? a : b);
    // O eixo Y não deve ser menor que 0 para as barras não flutuarem
    return minSaldo < 0 ? minSaldo * 1.2 : 0;
  }

  double _getMaxY(List<FluxoCaixaData> data) {
    if (data.isEmpty) return 1000;
    final maxEntrada = data.map((e) => e.entradasProg + e.entradasPrev).reduce((a, b) => a > b ? a : b);
    final maxSaida = data.map((e) => e.saidasProg + e.saidasPrev).reduce((a, b) => a > b ? a : b);
    final maxSaldo = data.map((e) => e.saldoPrev).reduce((a, b) => a > b ? a : b);

    // Pega o maior valor entre entradas, saídas e saldo para definir o topo do gráfico
    double max = [maxEntrada, maxSaida, maxSaldo].reduce((a, b) => a > b ? a : b);
    return max * 1.2; // Adiciona uma margem de 20%
  }

  // Calcula um intervalo razoável para as legendas do eixo Y
  double _getInterval(double maxY) {
    if (maxY <= 0) return 1000;
    // Tenta dividir o eixo em cerca de 4-5 intervalos
    return (maxY / 4).ceilToDouble();
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final bool isLine;

  const _LegendItem({
    required this.color,
    required this.text,
    this.isLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLine)
          Container(
            width: 16,
            height: 2,
            color: color,
          )
        else
          Container(
            width: 12,
            height: 12,
            color: color,
          ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}