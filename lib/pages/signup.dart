import 'package:flutter/material.dart';
import 'package:travelapp/pages/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image with rounded bottom-right corner
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(180),
              ),
              child: Image.asset(
                "image/SignUp i.jpg",
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        "Image not found",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // Login title
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "SignUp",
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
            SizedBox(height: 5),
            // Name label and input
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Name",
                style: TextStyle(
                  color: Color.fromARGB(195, 233, 227, 227),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(190, 220, 211, 211),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your Name",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(height: 5),
            // Email label and input
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Email",
                style: TextStyle(
                  color: Color.fromARGB(195, 233, 227, 227),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(190, 220, 211, 211),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: (value) {
                  // Validate email format
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 10),
            // Password label and input
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Password",
                style: TextStyle(
                  color: Color.fromARGB(195, 233, 227, 227),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(190, 220, 211, 211),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your password",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            // Signup Button
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xfffc9502),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            // Already have an account? Sign In
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    " Sign In",
                    style: TextStyle(
                      color: const Color(0xfffea720),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
