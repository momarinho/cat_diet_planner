import 'dart:typed_data';

import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class WeeklyReportExportService {
  static Future<Uint8List> buildPdf({
    required CatProfile? cat,
    required List<WeightRecord> records,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM d, yyyy');
    final latest = records.isNotEmpty ? records.last : null;
    final first = records.isNotEmpty ? records.first : null;
    final delta = records.length > 1
        ? records.last.weight - records.first.weight
        : null;
    final catName = cat?.name ?? 'Active Cat';

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'CatDiet Planner Weekly Report',
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
                ? 'No period selected'
                : '${dateFormat.format(first.date)} - ${dateFormat.format(latest.date)}',
          ),
          pw.SizedBox(height: 24),
          pw.Row(
            children: [
              _metricCard(
                'Latest Weight',
                latest == null
                    ? '--'
                    : '${latest.weight.toStringAsFixed(1)} kg',
              ),
              pw.SizedBox(width: 12),
              _metricCard(
                'Recent Change',
                delta == null
                    ? '--'
                    : '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg',
              ),
              pw.SizedBox(width: 12),
              _metricCard(
                'Trend',
                delta == null
                    ? 'Not enough data'
                    : delta > 0
                    ? 'Up'
                    : delta < 0
                    ? 'Down'
                    : 'Stable',
              ),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'Weight Records',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.pink400),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const ['Date', 'Weight', 'Notes'],
            data: records.isEmpty
                ? [
                    ['--', '--', 'No weight data recorded this week'],
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
          pw.Text(
            latest == null
                ? 'No weight data was recorded this week.'
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
  }) async {
    final bytes = await buildPdf(cat: cat, records: records);
    final safeName = (cat?.name ?? 'cat').toLowerCase().replaceAll(' ', '_');
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${safeName}_weekly_report.pdf',
    );
  }

  static Future<void> shareReport({
    required CatProfile? cat,
    required List<WeightRecord> records,
  }) async {
    final bytes = await buildPdf(cat: cat, records: records);
    final safeName = (cat?.name ?? 'cat').toLowerCase().replaceAll(' ', '_');
    final file = XFile.fromData(
      bytes,
      mimeType: 'application/pdf',
      name: '${safeName}_weekly_report.pdf',
    );
    await Share.shareXFiles([
      file,
    ], text: 'Weekly diet report from CatDiet Planner');
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
