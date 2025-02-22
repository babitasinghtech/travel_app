import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/pages/home.dart'; // Ensure this points to your Home page file

class Comments extends StatefulWidget {
  final String postId; // Accept postId to fetch related comments

  const Comments({required this.postId, super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addComment(String comment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User not logged in")));
      return;
    }

    String userName = user.displayName ?? "Anonymous"; // Get user name
    String profileImage = user.photoURL ?? ""; // Get user profile image

// Replace with actual user profile image URL

    try {
      await _firestore
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'comment': comment,
        'userName': userName,
        'profileImage': profileImage,
        'timestamp': FieldValue.serverTimestamp(), // Add timestamp for sorting
      });
      _commentController
          .clear(); // Clear the input field after adding the comment
    } catch (e) {
      // Handle any errors that occur during Firestore operation
      print("Error adding comment: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add comment")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false,
            );
          },
        ),
        title: Text("Comments"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Display Comments dynamically
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp',
                      descending: true) // Sort comments by timestamp
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No comments yet"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var commentData = snapshot.data!.docs[index];
                    return commentTile(
                      commentData['userName'],
                      commentData['comment'],
                      commentData['profileImage'],
                    );
                  },
                );
              },
            ),
          ),

          // Input field and send button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      addComment(_commentController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                    backgroundColor: Colors.blue,
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget commentTile(String userName, String userComment, String profileImage) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: Image.network(
                profileImage, // Default image
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    userComment,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
