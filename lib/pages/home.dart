import 'package:flutter/material.dart';
import 'package:travelapp/Services/database.dart';
import 'package:travelapp/Services/shared_pref.dart';
import 'package:travelapp/pages/add_pages.dart';
import 'package:travelapp/pages/comments.dart';
import 'package:travelapp/pages/top_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image, id;
  Stream? postStream;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId();
    postStream = await DatabaseMethods().getPosts();
    setState(() {});
  }

  Widget allPosts() {
    return StreamBuilder(
      stream: postStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _errorWidget(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return _noDataWidget();
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return PostTile(ds, id);
          },
        );
      },
    );
  }

  Widget _errorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("image/krishnajanmbhumi.avif", height: 250),
          const SizedBox(height: 10),

          // Location Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 5),
              const Text("Mathura, Uttar Pradesh, India",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 5),
          const Text(
            "It's a birth Place of Lord Shri Krishna.The city is also known for its rich history, culture, and spiritual experience. ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Like and Comment Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Like Button with Text
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      // Add Like Functionality Here
                    },
                  ),
                  Text(
                    "Like",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(width: 20), // Adjust spacing as needed

              // Comment Button with Text
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment,
                        color: Colors.black, size: 30),
                    onPressed: () {
                      // Add Comment Functionality Here
                    },
                  ),
                  const Text(
                    "Comment",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 25),
              Column(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.black, size: 30),
                    onPressed: () {
                      // Add Comment Functionality Here
                    },
                  ),
                  const Text(
                    "Share",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _noDataWidget() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "image/krishnajanmbhumi.avif",
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          const Text("No posts available",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            const SizedBox(height: 25),
            allPosts(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Stack(
      children: [
        Image.asset(
          "image/jake-blucker-tMzCrBkM99Y-unsplash.jpg",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35.0, right: 20.0),
          child: Row(
            children: [
              _iconButton("image/pin.webp", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlacesScreen()),
                );
              }),
              const Spacer(),
              _iconButton(Icons.add, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPages()),
                );
              }),
              const SizedBox(width: 10),
              _profileImage(),
            ],
          ),
        ),
        _appTitle(),
        _searchBar(),
      ],
    );
  }

  Widget _iconButton(dynamic icon, VoidCallback onTap) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: icon is String
              ? Image.asset(icon, height: 40, width: 40, fit: BoxFit.cover)
              : Icon(icon, color: Colors.blue, size: 25),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(60),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.asset(
          "image/profile.jpeg",
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _appTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 160.0, left: 20.0),
      child: Column(
        children: [
          const Text(
            "Travellers",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Lato",
              fontSize: 60.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            "Travel Community App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: MediaQuery.of(context).size.height / 2.7,
      ),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search your destination",
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  final DocumentSnapshot ds;
  final String? userId;

  const PostTile(this.ds, this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userInfo(),
              const SizedBox(height: 10),
              Text(ds["Caption"], style: const TextStyle(fontSize: 18)),
              _postActions(context),
              _commentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            ds["UserImage"] ?? "", // Default image
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        Text(ds["UserName"], style: const TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _postActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: ds["Like"].contains(userId)
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border),
          onPressed: () async {
            await DatabaseMethods().addLike(ds.id, userId!);
          },
        ),
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () {
            // Navigate to the Comments page and pass the post ID
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Comments(postId: ds.id), // Passing the post ID
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _commentSection() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(ds.id)
          .collection('comments')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("No comments yet"),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var commentData = snapshot.data!.docs[index];
            return ListTile(
              leading: const Icon(Icons.comment),
              title: Text(commentData["comment"] ?? "No comment content"),
            );
          },
        );
      },
    );
  }
}
