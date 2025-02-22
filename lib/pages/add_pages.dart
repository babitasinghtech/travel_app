import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';

class AddPages extends StatefulWidget {
  const AddPages({super.key});

  @override
  State<AddPages> createState() => _AddPagesState();
}

class _AddPagesState extends State<AddPages> {
  String? name, image;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false; // Track upload progress

  // Text Controllers
  final TextEditingController placenameController = TextEditingController();
  final TextEditingController citynameController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  // Request storage permission
  Future<void> requestPermission() async {
    if (await Permission.storage.request().isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Storage permission is required to select an image.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // Pick image from gallery
  Future<void> getImage() async {
    await requestPermission();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  // Compress Image
  Future<File?> compressImage(File imageFile) async {
    final filePath = imageFile.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    // ignore: prefer_interpolation_to_compose_strings
    final outPath = filePath.substring(0, lastIndex) + "_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path, outPath,
      quality: 70, // Compression quality
    );

    return result != null ? File(result.path) : null;
  }

  // Upload Post
  Future<void> uploadPost() async {
    if (selectedImage != null &&
        placenameController.text.isNotEmpty &&
        citynameController.text.isNotEmpty &&
        captionController.text.isNotEmpty) {
      try {
        setState(() {
          isUploading = true;
        });

        // Compress Image
        File? compressedImage = await compressImage(selectedImage!);
        String fileName = "post_${randomAlphaNumeric(10)}.jpg";
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("blogImage/$fileName");

        // Upload image
        UploadTask uploadTask =
            firebaseStorageRef.putFile(compressedImage ?? selectedImage!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        // Get Image URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Save to Firestore
        Map<String, dynamic> postData = {
          "image": downloadUrl,
          "placeName": placenameController.text.trim(),
          "cityName": citynameController.text.trim(),
          "caption": captionController.text.trim(),
          "userName": name ?? "Unknown User",
          "userImage": image ?? "",
          "timestamp": FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection('posts').add(postData);

        // Clear input fields after upload
        setState(() {
          selectedImage = null;
          placenameController.clear();
          citynameController.clear();
          captionController.clear();
          isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Post uploaded successfully!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } catch (e) {
        setState(() {
          isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Failed to upload post: $e",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please fill all fields and select an image.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  // Helper method to build input fields
  Widget buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: const Color(0xFFececf8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Add Post",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Image Selector
              selectedImage != null
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          selectedImage!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: getImage,
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),

              // Input Fields
              buildField("Place Name", placenameController),
              buildField("City Name", citynameController),
              buildField("Caption", captionController),

              // Post Button
              Center(
                child: isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: uploadPost,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Add Post",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
