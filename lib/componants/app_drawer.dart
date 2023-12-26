// import 'package:egalee_app/common/utils/url_launcher.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbpi_iq/componants/colors.dart';
import 'package:mbpi_iq/componants/url_launcher.dart';
import 'package:mbpi_iq/models/user.dart';
import 'package:mbpi_iq/screens/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _imageFile;
  bool isUploading = false;
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Navigate to the login page or any other screen you want after logout.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile != null) {
      try {
        setState(() {
          isUploading = true;
        });
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('${_auth.currentUser!.uid}.jpg');
        UploadTask uploadTask = ref.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await _auth.currentUser!.updatePhotoURL(downloadUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo updated successfully.'),
          ),
        );
      } catch (e) {
        print('Error uploading image to Firebase: $e');
        // Handle error messages here
      }
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userData = context.read<UserDataProvider>().userData;
    return Drawer(
      // backgroundColor: Color.fromARGB(255, 204, 204, 204),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isUploading
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        child: Stack(
                          children: [
                            Positioned(
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: _auth.currentUser!.photoURL !=
                                        null
                                    ? NetworkImage(_auth.currentUser!.photoURL!)
                                    : null,
                              ),
                            ),
                            const Positioned(
                                top: 50,
                                left: 55,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        onTap: () {
                          _pickProfilePhoto();
                        },
                      ),
                const SizedBox(height: 8),
                Text(
                  userData!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userData.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            tileColor: Colors.transparent,
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
            ),
            onTap: () async {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            tileColor: Colors.transparent,
            leading: const Icon(Icons.support_agent),
            title: const Text(
              'Contact us',
            ),
            onTap: () async {
              mail("mbpi@gmail.com",context);
            },
          ),

          ListTile(
              tileColor: Colors.transparent,
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
              ),
              onTap: _logout),
          const Spacer(),
          // Container(
          //   height: 220,
          //   decoration:  BoxDecoration(
          //     // color: Color.fromARGB(255, 137, 153, 177),
          //     // color: Color.fromARGB(255, 172, 172, 172),
          //     border: Border.fromBorderSide(BorderSide(color: AppColors.primaryColor)),
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          //   ),
          //   padding: const EdgeInsets.all(10.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           const CircleAvatar(
          //             // borderRadius: BorderRadius.circular(150),
          //             radius: 50,
          //             backgroundImage:
          //                 // child:
          //                 AssetImage(
          //               'assets/ceo.jpg',
          //             ),
          //           ),
          //           Column(
          //             children: [
          //               const Text(
          //                 'Wasik Billah Asif',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 17.0,
          //                 ),
          //               ),
          //               Row(
          //                 children: [
          //                   const Icon(Icons.school),
          //                   const SizedBox(
          //                     width: 4,
          //                   ),
          //                   Text(
          //                     'Dhaka University',
          //                     style: TextStyle(
          //                       fontSize: 12.0,
          //                       color:AppColors.primaryColor,
          //                       fontWeight: FontWeight.w700,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               const SizedBox(
          //                 height: 5,
          //               ),
          //               Text(
          //                 'Teacher',
          //                 style: TextStyle(
          //                     fontSize: 12.0,
          //                     color: AppColors.primaryColor,
          //                     fontWeight: FontWeight.w700),
          //               ),
          //               Row(
          //                 children: [
          //                   const Icon(
          //                     Icons.work_outlined,
          //                   ),
          //                   const SizedBox(
          //                     width: 4,
          //                   ),
          //                   Text(
          //                     'Rajshahi Cantonment\nBoard School & College',
          //                     style: TextStyle(
          //                         fontSize: 12.0,
          //                         color: AppColors.primaryColor,
          //                         fontWeight: FontWeight.w700),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Padding(
          //             padding: EdgeInsets.only(left: 7),
          //             child: Text("Founder & CEO",
          //                 style: TextStyle(
          //                     fontSize: 14.0, fontWeight: FontWeight.bold)),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(
          //               left: 7,
          //             ),
          //             child: Text("Egalee App",
          //                 style: TextStyle(
          //                     fontSize: 12.0,
          //                     color: AppColors.primaryColor,
          //                     fontWeight: FontWeight.w700)),
          //           ),
          //           Row(
          //             children: [
          //               IconButton(
          //                   onPressed: () {

          //                     launchurl(Uri.parse('https://wa.me/+8801798155062'));

          //                   },
          //                   icon: const Icon(Icons.chat_outlined)),
          //               // SizedBox(width: 5.0),
          //               IconButton(
          //                   onPressed: () {
          //                     mail('Egalee.bd@gmail.com', context);
          //                   },
          //                   icon: const Icon(Icons.email)),
          //             ],
          //           ),
          //         ],
          //       )
          //       // Row(
          //       //   children: [

          //       //     SizedBox(width: 5.0),
          //       //     Text('Egalee.bd@gmail.com',
          //       //         style: TextStyle(fontSize: 12.0)),
          //       //   ],
          //       // ),
          //     ],
          //   ),
          // ),

         
        ],
      ),
    );
  }
}