import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> gerarRelatorio({
    required String titulo,
    required List<String> colunas,
    required List<List<String>> dados,
    String? subtitulo,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Text(
              titulo,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          if (subtitulo != null)
            pw.Text(
              subtitulo,
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
          pw.SizedBox(height: 20),

          // Tabela
          pw.TableHelper.fromTextArray(
            headers: colunas,
            data: dados,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.green,
            ),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(8),
          ),

          // Footer
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Text(
            'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
