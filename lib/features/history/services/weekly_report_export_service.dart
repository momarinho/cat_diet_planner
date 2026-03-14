import 'dart:typed_data';

import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class WeeklyReportExportService {
  static Future<Uint8List> buildPdf({
    required CatProfile? cat,
    required List<WeightRecord> records,
    required AppSettings settings,
  }) async {
    final pdf = pw.Document();
    final languageCode = settings.languageCode;
    final isPt = languageCode == 'pt';
    final isTl = languageCode == 'tl';
    final dateFormat = DateFormat('MMM d, yyyy');
    final latest = records.isNotEmpty ? records.last : null;
    final first = records.isNotEmpty ? records.first : null;
    final delta = records.length > 1
        ? records.last.weight - records.first.weight
        : null;
    final catName = cat?.name ?? 'Active Cat';

    pdf.addPage(
      pw.MultiPage(
        margin: settings.pdfLayout == 'compact'
            ? const pw.EdgeInsets.all(18)
            : const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            isPt
                ? 'Relatorio Semanal CatDiet Planner'
                : isTl
                ? 'Lingguhang Ulat ng CatDiet Planner'
                : 'CatDiet Planner Weekly Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.pink700,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            catName,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            first == null || latest == null
                ? isPt
                      ? 'Nenhum periodo selecionado'
                      : isTl
                      ? 'Walang napiling panahon'
                      : 'No period selected'
                : '${dateFormat.format(first.date)} - ${dateFormat.format(latest.date)}',
          ),
          pw.SizedBox(height: 24),
          if (settings.pdfIncludeWeightTrend) ...[
            pw.Row(
              children: [
                _metricCard(
                  isPt
                      ? 'Peso atual'
                      : isTl
                      ? 'Pinakabagong timbang'
                      : 'Latest Weight',
                  latest == null
                      ? '--'
                      : '${latest.weight.toStringAsFixed(1)} kg',
                ),
                pw.SizedBox(width: 12),
                _metricCard(
                  isPt
                      ? 'Mudanca recente'
                      : isTl
                      ? 'Kamakailang pagbabago'
                      : 'Recent Change',
                  delta == null
                      ? '--'
                      : '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg',
                ),
                pw.SizedBox(width: 12),
                _metricCard(
                  isPt
                      ? 'Tendencia'
                      : isTl
                      ? 'Trend'
                      : 'Trend',
                  delta == null
                      ? isPt
                            ? 'Dados insuficientes'
                            : isTl
                            ? 'Kulang ang datos'
                            : 'Not enough data'
                      : delta > 0
                      ? isPt
                            ? 'Subindo'
                            : isTl
                            ? 'Tumataas'
                            : 'Up'
                      : delta < 0
                      ? isPt
                            ? 'Descendo'
                            : isTl
                            ? 'Bumababa'
                            : 'Down'
                      : isPt
                      ? 'Estavel'
                      : isTl
                      ? 'Matatag'
                      : 'Stable',
                ),
              ],
            ),
            pw.SizedBox(height: 24),
          ],
          if (settings.pdfIncludeCalorieTable) ...[
            pw.Text(
              isPt
                  ? 'Registros de peso'
                  : isTl
                  ? 'Mga tala ng timbang'
                  : 'Weight Records',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.pink400,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headers: isPt
                  ? const ['Data', 'Peso', 'Observacoes']
                  : isTl
                  ? const ['Petsa', 'Timbang', 'Tala']
                  : const ['Date', 'Weight', 'Notes'],
              data: records.isEmpty
                  ? [
                      [
                        '--',
                        '--',
                        isPt
                            ? 'Sem dados de peso no periodo'
                            : isTl
                            ? 'Walang datos ng timbang sa napiling panahon'
                            : 'No weight data in selected range',
                      ],
                    ]
                  : records.map((record) {
                      return [
                        dateFormat.format(record.date),
                        '${record.weight.toStringAsFixed(1)} kg',
                        record.notes ?? '--',
                      ];
                    }).toList(),
            ),
            pw.SizedBox(height: 24),
          ],
          if (settings.pdfIncludeVetNotes)
            pw.Text(
              latest == null
                  ? isPt
                        ? 'Nao houve registro de peso neste periodo.'
                        : isTl
                        ? 'Walang naitalang timbang sa panahong ito.'
                        : 'No weight data was recorded in this range.'
                  : isPt
                  ? '$catName apresenta progresso. Peso atual: ${latest.weight.toStringAsFixed(1)} kg. Mantenha o plano alimentar e monitore a atividade diariamente.'
                  : isTl
                  ? 'May progreso si $catName. Kasalukuyang timbang: ${latest.weight.toStringAsFixed(1)} kg. Ipagpatuloy ang kasalukuyang feeding plan at bantayan ang aktibidad araw-araw.'
                  : '$catName is making progress. Current weight is ${latest.weight.toStringAsFixed(1)} kg. Continue the current feeding plan and monitor activity daily.',
            ),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<void> downloadPdf({
    required CatProfile? cat,
    required List<WeightRecord> records,
    required AppSettings settings,
  }) async {
    final bytes = await buildPdf(
      cat: cat,
      records: records,
      settings: settings,
    );
    final safeName = (cat?.name ?? 'cat').toLowerCase().replaceAll(' ', '_');
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${safeName}_weekly_report.pdf',
    );
  }

  static Future<void> shareReport({
    required CatProfile? cat,
    required List<WeightRecord> records,
    required AppSettings settings,
  }) async {
    final bytes = await buildPdf(
      cat: cat,
      records: records,
      settings: settings,
    );
    final safeName = (cat?.name ?? 'cat').toLowerCase().replaceAll(' ', '_');
    final file = XFile.fromData(
      bytes,
      mimeType: 'application/pdf',
      name: '${safeName}_weekly_report.pdf',
    );
    final defaultMessage = _defaultShareMessage(settings.languageCode);
    final shareMessage = settings.shareMessageTemplate.trim().isEmpty
        ? defaultMessage
        : settings.shareMessageTemplate.trim();
    await Share.shareXFiles([file], text: shareMessage);
  }

  static String _defaultShareMessage(String languageCode) {
    if (languageCode == 'pt') {
      return 'Relatorio semanal de dieta do CatDiet Planner';
    }
    if (languageCode == 'tl') {
      return 'Lingguhang ulat ng diet mula sa CatDiet Planner';
    }
    return 'Weekly diet report from CatDiet Planner';
  }

  static pw.Widget _metricCard(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
