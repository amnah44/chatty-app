import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffs/util/extension/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../util/constants.dart';

class FirebaseApi {
  static final firebaseStore =
      FirebaseFirestore.instance.collection(Constants.chatty);
  File? imageFile;

  static addMessage(String message) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await firebaseStore.add({
        Constants.auth: user.displayName ?? "",
        Constants.id: user.uid,
        Constants.phoneNumber: user.phoneNumber ?? "",
        Constants.type: Constants.text,
        Constants.timestamp: Timestamp.now().millisecondsSinceEpoch,
        Constants.profileImage: user.photoURL ?? Constants.defaultImage,
        Constants.message: message,
        Constants.isTyping: 'false',
      });
    }
  }

  Future getImage() async {
    ImagePicker _image = ImagePicker();

    await _image.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    var user = FirebaseAuth.instance.currentUser;
    String fileName = Uuid().v1();
    int status = 1;

    if (user != null) {
      await firebaseStore.doc(fileName).set({
        Constants.auth: user.displayName ?? "",
        Constants.id: user.uid,
        Constants.phoneNumber: user.phoneNumber ?? "",
        Constants.type: Constants.image,
        Constants.timestamp: Timestamp.now().millisecondsSinceEpoch,
        Constants.profileImage: user.photoURL ?? Constants.defaultImage,
        Constants.message: fileName,
        Constants.isTyping: 'false',
      });
    }
    var ref = FirebaseStorage.instance
        .ref()
        .child(Constants.image)
        .child("$fileName.jpg");

    var upload = await ref.putFile(imageFile!).catchError((error) async {
      await firebaseStore.doc(fileName).delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await upload.ref.getDownloadURL();
      await firebaseStore.doc(fileName).update({Constants.message: imageUrl});
    }
  }

  static void onDeleteMessage(String docId) async {
    await FirebaseApi.firebaseStore.doc(docId).delete();
    Constants.deleteMessage.toToast();
  }

  static void signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.back();
    Constants.signOutMessage.toToast();
  }
}
