import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:ui' as ui;

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../utils/constants.dart';





class MyHomePage extends StatefulWidget {
  final String id_patient;
  const MyHomePage({super.key,required this.id_patient});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();
  int scode=0;
  List<dynamic> symptoms = [];
  var secondary_sympyoms;
  var angrydata;
  var saddata;
  var happydata;
  var feardata;
  var disgustdata;
  var surprisedata;
  var neutraldata;
  var questions;

  Future<void> getSymptomsByUser() async {
    final String url = "$BASE_URL/symptoms/getbyuser";
    final String idUser = widget.id_patient;

    try {
      final response = await http.get(Uri.parse('$url/$idUser'));
      if (response.statusCode == 200) {
        // Prints the list of symptoms retrieved
        setState(() {
          scode=200;
          symptoms = json.decode(response.body);

          secondary_sympyoms = symptoms[0]['inflated_self_esteem'] +
          symptoms[0]['decreased_sleep'] +
          symptoms[0]['talkative_or_pressure_to_talk'] +
          symptoms[0]['racing_thoughts'] +
          symptoms[0]['distractibility'] +
          symptoms[0]['increased_activity'] +
          symptoms[0]['risky_behavior'];
      angrydata = symptoms[0]['angrypercentage'];
      saddata = symptoms[0]['sadpercentage'];
      happydata = symptoms[0]['happypercentage'];
      feardata = symptoms[0]['fearpercentage'];
      disgustdata = symptoms[0]['disgustpercentage'];
      surprisedata = symptoms[0]['surprisepercentage'];
      neutraldata = symptoms[0]['neutralpercentage'];
      questions = symptoms[0]['questions'];
        });
      } else {
        setState(() {
          scode=0;
        });
      }
    } catch (e) {}

  }

  @override
  void initState() {
    super.initState();
    getSymptomsByUser();
    /*
    setState(() {
      secondary_sympyoms = symptoms[0]['inflated_self_esteem'];
    });*/
    /* print("here");
    print(secondary_sympyoms);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: scode == 200 ? SingleChildScrollView(
            child: RepaintBoundary(
          key: _globalKey,
          child: Column(
            // ignore: avoid_print

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 13.0, 16.0, 16),
                child: Text(
                  'We conducted a test that involved using AI and voice recognition technology to gather data. The test results revealed the following information: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              buildSymptom(
                  'A distinct period of abnormally and persistently elevated, expansive, or irritable mood and abnormally and persistently goal-directed behavior or energy, present most of the day, nearly every day (or any duration if hospitalization is necessary).',
                  symptoms[0]['elevated_mood_day'].toString()),
              buildSymptom(
                  'A distinct period of abnormally and persistently elevated, expansive, or irritable mood and abnormally and persistently goal-directed behavior or energy, lasting at least 1 week .',
                  symptoms[0]['elevated_mood_week'].toString()),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 13.0, 16.0, 0),
                child: Text(
                  'During the period of mood disturbance and increased energy or activity, three (or more) of the following symptoms have persisted (four if the mood is only irritable) are present to a significant degree and represent a noticeable change from usual behavior:',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    buildSymptom('Inflated self-esteem or grandiosity',
                        symptoms[0]['inflated_self_esteem'].toString()),
                    buildSymptom(
                        'Decreased need for sleep (e.g., feels rested after only 3 hours of sleep)',
                        symptoms[0]['decreased_sleep'].toString()),
                    buildSymptom(
                        'More talkative than usual or pressure to keep talking',
                        symptoms[0]['talkative_or_pressure_to_talk']
                            .toString()),
                    buildSymptom(
                        'Flight of ideas or subjective experience that thoughts are racing',
                        symptoms[0]['racing_thoughts'].toString()),
                    buildSymptom(
                        'Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli), as reported or observed',
                        symptoms[0]['distractibility'].toString()),
                    buildSymptom(
                        'Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation',
                        symptoms[0]['increased_activity'].toString()),
                    buildSymptom(
                        'Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments).',
                        symptoms[0]['risky_behavior'].toString())
                  ],
                ),
              ),
              buildSymptom(
                  'The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features.',
                  symptoms[0]['severe_mood_disturbance'].toString()),
              buildSymptom(
                  'The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition.',
                  symptoms[0]['not_due_to_substance_or_medical_condition']
                      .toString()),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Text(
                  "Result :",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.green,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  "DSM-5 diagnostic criteria " +
                      (symptoms[0]['elevated_mood_day'].toString() == "1" &&
                              symptoms[0]['elevated_mood_week'].toString() ==
                                  "1" &&
                              symptoms[0]['not_due_to_substance_or_medical_condition']
                                      .toString() ==
                                  "1" &&
                              symptoms[0]["severe_mood_disturbance"]
                                      .toString() ==
                                  "1" &&
                              secondary_sympyoms >= 3
                          ? "met"
                          : "not met") +
                      ".",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 13.0, 16.0, 16),
                child: Text(
                  'Please note that the accuracy of the data collected may be affected by various factors such as environmental noise, accent or speech impediments. We have made every effort to ensure the accuracy of the data but cannot guarantee its complete reliability. ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 13.0, 16.0, 16),
                child: Text(
                  "Data visualization of the patient's emotions :",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 250.0,
                child: charts.LineChart(
                  [
                    charts.Series<dynamic, int>(
                      id: 'Values',
                      data: angrydata,
                      domainFn: (value, index) => index!,
                      measureFn: (value, index) => value,
                      colorFn: (_, __) =>
                          charts.MaterialPalette.red.shadeDefault,
                    ),
                    charts.Series<dynamic, int>(
                      id: 'Values',
                      data: saddata,
                      domainFn: (value, index) => index!,
                      measureFn: (value, index) => value,
                      colorFn: (_, __) => charts.MaterialPalette.black,
                    ),
                    charts.Series<dynamic, int>(
                      id: 'Values',
                      data: happydata,
                      domainFn: (value, index) => index!,
                      measureFn: (value, index) => value,
                      colorFn: (_, __) =>
                          charts.MaterialPalette.pink.shadeDefault,
                    ),
                    charts.Series<dynamic, int>(
                      id: 'Values',
                      data: feardata,
                      domainFn: (value, index) => index!,
                      measureFn: (value, index) => value,
                    ),
                    charts.Series<dynamic, int>(
                      id: 'Values',
                      data: disgustdata,
                      domainFn: (value, index) => index!,
                      measureFn: (value, index) => value,
                    ),
                    charts.Series<dynamic, int>(
                      id: 'Values',
                      data: neutraldata,
                      domainFn: (value, index) => index!,
                      measureFn: (value, index) => value,
                      colorFn: (_, __) =>
                          charts.MaterialPalette.green.shadeDefault,
                    ),
                  ],
                  animate: true,
                  defaultRenderer:
                      charts.LineRendererConfig(includePoints: true),
                  domainAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      desiredTickCount: angrydata.length,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pdfDoc = pw.Document();
                  final image = await _captureScreenshot();
                  final pdfImage = pw.MemoryImage(image);
                  pdfDoc.addPage(pw.Page(
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Image(pdfImage),
                      );
                    },
                  ));

                  final Uint8List bytes = await pdfDoc.save();
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => bytes,
                  );
                },
                child: Text('Download PDF'),
              ),
            ],
          ),
        )): const Center(child: Text("No result test found"),));
  }

  Future<Uint8List> _captureScreenshot() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Widget buildSymptom(String symptomName, dynamic symptomValue) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: symptomValue == "1",
          onChanged: (bool? value) {
            // Update the symptom data in the backend
            // You can send a request to your API endpoint here
          },
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: EdgeInsets.only(bottom: 0.0, top: 8.0),
            child: Text(
              symptomName,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}