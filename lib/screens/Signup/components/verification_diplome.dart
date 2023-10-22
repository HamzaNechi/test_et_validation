import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psychoday/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diplome extends StatefulWidget {

  final Function(String) updateisDocVerif;
  final Function(String) updateSpeciality;
  final Function(String) pathDiplome;
  final String nameDoctor;
  Diplome(this.updateisDocVerif,this.updateSpeciality,this.pathDiplome,this.nameDoctor);
  @override
  State<Diplome> createState() => _DiplomeState();
}

class _DiplomeState extends State<Diplome> {
  String isDoctor='';
  bool isScanning=false;
  String scannedText='';
  XFile? imageFile;
  bool textSanning = false;
  ImagePicker? imagePicker;
  late String spec;
  late Icon check;
  String pathImage='';

  



 
 void getImage() async{
  try{
    final pickedImage=await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedImage != null){
      print('is doctor dans if : ${isDoctor}');
      textSanning=true;
      imageFile=pickedImage;

      setState(() {
        pathImage=imageFile!.path;
      });

      getRecognition(pickedImage);  
    }

    
  }catch(e){
      textSanning=false;
      imageFile=null;

      setState(() {
        isDoctor="Error occured while scanning";
      });

      scannedText="Error occured while scanning";

      
      
  }
 }


 void getRecognition(XFile image)async {
  final inputImage=InputImage.fromFilePath(image.path);
  final textDetector = GoogleMlKit.vision.textRecognizer();
  RecognizedText recognizedText=await textDetector.processImage(inputImage);
  await textDetector.close();

  for(TextBlock block in recognizedText.blocks){
    for(TextLine line in block.lines){
      scannedText=scannedText+line.text+"\n";
    }
  }



  textSanning=false;

  if(VerifIsDoctor(scannedText)){
    print(isScanning);
    setState(() {
      isScanning=true;
      isDoctor="Doctor";
      widget.updateisDocVerif('oui');
      widget.pathDiplome(pathImage);
      check=const Icon(Icons.check_circle,color: Colors.green,);
    });
  }else{
    setState(() {
      isScanning=true;
      check=const Icon(Icons.error,color: Colors.red,);
      widget.updateisDocVerif('non');
      isDoctor="mehouuuch dooctoor";
      widget.pathDiplome('');
    });
  }

  print("2 $isScanning");

 }


 bool VerifIsDoctor(String txtDip){
  var name=widget.nameDoctor.toUpperCase();
  var indexName=txtDip.toUpperCase().indexOf(name);
  var index=txtDip.toUpperCase().indexOf('ÉCOLE DE PSYCHOTHÉRAPIE'.toUpperCase());
  return index > 0 && indexName > 0;
 }

  


  @override
  Widget build(BuildContext context) {
    //return Text(result);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          TextFormField(
              textInputAction: TextInputAction.next,
              cursorColor: Style.clair,
              onChanged: (String? value) {
                setState(() {
                  spec = value!;
                  widget.updateSpeciality(value);
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "la spécialité ne doit pas etre vide";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your speciality",
                prefixIcon: Padding(
                  padding:EdgeInsets.all(10),
                  child: Icon(Icons.arrow_circle_right_sharp),
                ),
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                TextButton(
                  onPressed: () {
                  getImage();
                }, 
                child:const Text("upload your diploma")),

                isScanning ? check  :CircularProgressIndicator() ,
            ],
          )
          
        ],
      );
  
  }
}