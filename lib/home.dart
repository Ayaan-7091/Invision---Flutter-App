import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ShapeDetector extends StatefulWidget {
  const ShapeDetector({super.key});

  @override
  State<ShapeDetector> createState() => _ShapeDetectorState();
}

class _ShapeDetectorState extends State<ShapeDetector> {
  File? _selectedImage;
  File? _processedImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _processedImage = null;
      });
    }
  }

  Future<void> _sendToServer() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.134:5000/detect-shapes'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', _selectedImage!.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();

       // Delete old file if it exists
    if (_processedImage != null && await _processedImage!.exists()) {
      await _processedImage!.delete();
    }

    // Create a unique filename
    final uniqueName = 'processed_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = join(dir.path, uniqueName);
      final file = File(filePath);
      await file.writeAsBytes(await response.stream.toBytes());
      setState(() {
        _processedImage = file;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('Invision',style: TextStyle(fontWeight: FontWeight.w600),),
        centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Text('Upload your Image',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),
                // Upload Buttons 
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                // Button - 1 
                InkWell(
                   onTap: ()=>_pickImage(ImageSource.camera),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(36, 0, 0, 0),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text('Camera',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                  ),
                ),

                // Button - 2
                 InkWell(
                  onTap: ()=>_pickImage(ImageSource.gallery),
                   child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
    BoxShadow(
      color: const Color.fromARGB(36, 0, 0, 0),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.image_rounded),
                          Text('Gallery',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                       ),
                 ) 
               ],),
              SizedBox(height: 10,),

              Divider(),

              SizedBox(height: 10,),

               //Image Display
              // Replace your Image Display section with this:

SizedBox(height: 10),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // Label 1
    if (_selectedImage != null)
      Text(
        "Selected Image",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    if (_processedImage != null)
      Text(
        "Processed Output",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
  ],
),
SizedBox(height: 10),

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      // Selected Image
      if (_selectedImage != null)
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
                    boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ],
   
  
            borderRadius: BorderRadius.circular(12),
          ),
          child: AspectRatio(
            aspectRatio: 3 / 4, // You can tweak this
            child: Image.file(_selectedImage!, fit: BoxFit.cover),
          ),
        ),

      // Processed Image
      if (_processedImage != null)
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
             boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ],
   
            borderRadius: BorderRadius.circular(12),
          ),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.file(_processedImage!, fit: BoxFit.cover),
          ),
        ),
    ],
  ),
),

               SizedBox(height: 20,),

               _selectedImage!=null && _processedImage==null?     Padding(
                 padding: const EdgeInsets.all(8.0),
                 child:InkWell(
                    onTap: _sendToServer,
                     child: Container(
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(8),
                          boxShadow: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Upload',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),textAlign: TextAlign.center,)
                      ),
                         ),
                   ),
               )  : SizedBox(),
               SizedBox(height: 20,),

              ],
            ),
          ),
        ),
    );
  }
}
