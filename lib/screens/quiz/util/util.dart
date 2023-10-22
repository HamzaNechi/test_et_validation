import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:psychoday/screens/quiz/util/category.dart';
import 'package:psychoday/screens/quiz/util/url_text.dart';

import '../screens/constants.dart';

var bodyText = "";
Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(
    title: 'Flutter School',
  );
  createPDFContent();
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('Assets/b.jpg')).buffer.asUint8List(),
  );
  final footerImage = pw.MemoryImage(
    (await rootBundle.load('Assets/r.jpg')).buffer.asUint8List(),
  );
  final font = await rootBundle.load('Assets/OpenSansRegular.ttf');
  final ttf = pw.Font.ttf(font);

  final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.Image(
        alignment: pw.Alignment.topLeft,
        logoImage,
        fit: pw.BoxFit.contain,
        width: 180,
      ),
      footer: (final context) => pw.Image(
        footerImage,
        fit: pw.BoxFit.scaleDown,
      ),
      build: (final context) => [
        pw.Container(
          padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Phone :'),
                      pw.Text('Email :'),
                      pw.Text('Website :'),
                    ],
                  ),
                  pw.SizedBox(width: 70),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('20295322'),
                      UrlText('Dear-Self', 'dhif.ghassen@esprit.tn'),
                      UrlText('flutter tutorial', 'QUiZ_TEST'),
                    ],
                  ),
                  pw.SizedBox(width: 70),
                  pw.BarcodeWidget(
                    data: 'Ghassen dhif',
                    width: 40,
                    height: 40,
                    barcode: pw.Barcode.qrCode(),
                    drawText: false,
                  ),
                  pw.Padding(padding: pw.EdgeInsets.zero),
                ],
              ),
            ],
          ),
        ),
        pw.Center(
          child: pw.Text(
            'In The Name of God',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: ttf,
              fontSize: 30,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: Category(
            'Dear ${username}',
            ttf,
          ),
        ),
        pw.Paragraph(
            margin: const pw.EdgeInsets.only(top: 10),
            text: bodyText,
            style: pw.TextStyle(
              font: ttf,
              lineSpacing: 8,
              fontSize: 16,
            ))
      ],
    ),
  );
  return doc.save();
}

void createPDFContent() {
  int i = 1;
  pdfQuiz.forEach((key, value) {
    bodyText += "${i++} - ${key.question} \t ${value} \n ";
  });
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('Assets/b.jpg')).buffer.asUint8List(),
  );
  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Watermark(
              angle: 20,
              child: pw.Opacity(
                opacity: 0.5,
                child: pw.Image(
                  alignment: pw.Alignment.center,
                  logoImage,
                  fit: pw.BoxFit.cover,
                ),
              ))));
}

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final byte = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('sace as File ${file.path}...');
  await file.writeAsBytes(byte);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document printed successfully')));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document shared successfully')));
}
