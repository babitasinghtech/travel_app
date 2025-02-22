// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  String? get id => null;

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

 Future<void> addPost(Map<String, dynamic> postData, String postId) async {
  await FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .set(postData);
}


  Future<Stream<QuerySnapshot>> getPosts() async {
    return FirebaseFirestore.instance
        .collection('posts') // Specify your Firestore collection
        .orderBy('timestamp',
            descending: true) // Order by timestamp if required
        .snapshots(); // Listen for real-time updates
  }

  Future<void> addLike(String postId, String userId) async {
    // Add a like to the Firestore document
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);

    await postRef.update({
      "Like": FieldValue.arrayUnion([userId]) // Add userId to the Like array
    });
  }

  Future<Stream<QuerySnapshot>> getComments() async {
    // ignore: await_only_futures
    return await FirebaseFirestore.instance
        .collection("Post")
        .doc(id)
        .collection("Comments")
        .snapshots();
  }
}
