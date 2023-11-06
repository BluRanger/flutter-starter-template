import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

void FeatureComingSoonSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            FeatherIcons.lifeBuoy,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Feature coming soon !',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.deepPurpleAccent.shade200,
    ),
  );
}

class IssueForm extends StatefulWidget {
  IssueForm(
    this.navigatorKey,
    this.currentRoute,
  );

  final GlobalKey<NavigatorState> navigatorKey;
  final String currentRoute;

  @override
  _IssueFormState createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  XFile? selectedImage;
  String? uploadedImageUrl;
  late ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context, type: ProgressDialogType.normal);
    pr.style(
        message: 'Uploading File',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressWidgetAlignment: Alignment.center,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  }

  Future<String> uploadImage(XFile imageFile) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.imgur.com/3/image'),
        headers: {
          'Authorization': 'Client-ID aca6d2502f5bfd8',
        },
        body: <String, String>{
          'image': base64Encode(await imageFile.readAsBytes()),
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['data']['link'];
      } else {
        throw Exception(
            'Failed to upload to Imgur. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<XFile?> pickImage() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 300);
    return pickedImage;
  }

  Future<void> pickAndUploadImage() async {
    pr.show();
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });

      final imageUrl = await uploadImage(pickedImage);
      setState(() {
        uploadedImageUrl = imageUrl;
      });
      pr.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 16),
        TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Title'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: bodyController,
          decoration: InputDecoration(labelText: 'Description'),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Call the GitHub API with the provided data

                pickAndUploadImage();

                // Close the dialog
              },
              child: Text('Upload Image'),
            ),
            SizedBox(width: 10),
            if (uploadedImageUrl != null) ...{
              Icon(FeatherIcons.check),
            }
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            // Call the GitHub API with the provided data

            reportIssue(uploadedImageUrl, widget.currentRoute);

            context.router.pop(); // Close the dialog
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  void reportIssue(String? uploadedImageUrl, String currentRoute) async {
    final title = titleController.text;

    StringBuffer bodybuffer = StringBuffer();
    bodybuffer.write(bodyController.text);
    bodybuffer.write("\n ${currentRoute} \n");
    if (uploadedImageUrl != null) {
      //bodybuffer.write("\n![image](${uploadedImageUrl})");
      bodybuffer.write(
          '<p align=\"center\"> <img src="${uploadedImageUrl}" alt="bug image"/></p>');
    }

    final response = await http.post(
      Uri.parse('https://api.github.com/repos/Vahathi/resume/issues1'),
      headers: <String, String>{
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'body': bodybuffer.toString(),
        'labels': ["bug"]
      }),
    );

    //log("Shaker Service : ${response.body}||${response.headers}||${response.statusCode}");

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(widget.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.bug_report_outlined,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Bug Reported',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(widget.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                FeatherIcons.alertTriangle,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Something is wrong',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
