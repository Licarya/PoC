
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? imageFile;

  Future _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future _pickImageCamera() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }


  Future<void> cropImage() async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 500,
        maxWidth: 500,
        uiSettings: [AndroidUiSettings(
          toolbarTitle: 'Crop',
          cropGridColor: Colors.black,
          lockAspectRatio: true
        ),
          IOSUiSettings(title: 'Crop', aspectRatioPickerButtonHidden: true, aspectRatioLockEnabled: true, rotateButtonsHidden: true, aspectRatioLockDimensionSwapEnabled: true),
        ]
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _clearImage() {
    setState(() {
      imageFile = null;
    });
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                imageFile != null
                    ? Image.file(imageFile!)
                    : Text('Aucune image sélectionnée'),

                SizedBox(height: 10,),

                Row(
                  children: [
                    Spacer(),
                    FloatingActionButton(
                      onPressed: () {
                        _pickImage();
                      }, child: Icon(Icons.image),),
                    Spacer(),

                    FloatingActionButton(
                      onPressed: () {
                        _pickImageCamera();
                      }, child: Icon(Icons.image_outlined),),
                    Spacer(),

                    imageFile != null ?
                    FloatingActionButton(
                      onPressed: () {
                        cropImage();
                      }, child: Icon(Icons.fit_screen),) : Container(),
                    Spacer(),

                    imageFile != null ?
                    FloatingActionButton(
                      onPressed: () {
                        _clearImage();
                      }, child: Icon(Icons.cancel),) : Container(),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

