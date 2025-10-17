import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/mock/mock_data.dart';
import '../../widgets/custom_drawer.dart';

class DashboardFinanceiroScreen extends StatelessWidget {
  const DashboardFinanceiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.compactCurrency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 0,
    );

    final dashboard = MockData.dashboardFinanceiro;
    final graficoMensal = dashboard['grafico_mensal'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Financeiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Get.snackbar(
                'Em desenvolvimento',
                'Filtro por período',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: 'Período',
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards de Resumo
            Row(
              children: [
                Expanded(
                  child: _buildCardResumo(
                    'Receitas',
                    formatCurrency.format(dashboard['receitas_mes']),
                    AppColors.receita,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCardResumo(
                    'Despesas',
                    formatCurrency.format((dashboard['despesas_mes'] as double).abs()),
                    AppColors.despesa,
                    Icons.trending_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCardResumo(
              'Saldo do Mês',
              formatCurrency.format(dashboard['saldo_mes']),
              AppColors.primary,
              Icons.account_balance_wallet,
              fullWidth: true,
            ),

            const SizedBox(height: 24),

            // Gráfico de Receitas x Despesas
            const Text(
              'Receitas vs Despesas (últimos 6 meses)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 80000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < graficoMensal.length) {
                            return Text(
                              graficoMensal[value.toInt()]['mes'],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: graficoMensal.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (data['receitas'] as num).toDouble(),
                          color: AppColors.receita,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: (data['despesas'] as num).toDouble(),
                          color: AppColors.despesa,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Legenda
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Receitas', AppColors.receita),
                const SizedBox(width: 24),
                _buildLegendItem('Despesas', AppColors.despesa),
              ],
            ),

            const SizedBox(height: 24),

            // Comparação com mês anterior
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.insights, color: AppColors.info, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Comparação com Mês Anterior',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildComparacao(
                    'Receitas',
                    dashboard['receitas_mes_anterior'] as double,
                    dashboard['receitas_mes'] as double,
                  ),
                  const SizedBox(height: 8),
                  _buildComparacao(
                    'Despesas',
                    (dashboard['despesas_mes_anterior'] as double).abs(),
                    (dashboard['despesas_mes'] as double).abs(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardResumo(
    String titulo,
    String valor,
    Color cor,
    IconData icone, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment:
            fullWidth ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: fullWidth
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(icone, color: cor, size: 20),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 13,
                  color: cor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: fullWidth ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color cor) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildComparacao(String label, double anterior, double atual) {
    final diferenca = atual - anterior;
    final percentual = (diferenca / anterior * 100);
    final cresceu = diferenca > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13),
        ),
        Row(
          children: [
            Icon(
              cresceu ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: cresceu ? Colors.green : Colors.red,
            ),
            Text(
              '${percentual.abs().toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: cresceu ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}