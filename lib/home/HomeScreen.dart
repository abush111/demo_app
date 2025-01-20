import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicele/home/widget/detail_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: "yared@gmail.com",
        password: "123456",
      );

      // Get the token from the user credential
      // String? token = await userCredential.user!.getIdToken();
      String uid = userCredential.user!.uid;

      // Save the token using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', uid);

      // Navigate to the next screen after successful login
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    _login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Vehicle Dashboard',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 160,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle Name: Toyota',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailWidget()),
                                  );
                                },
                                child: Text(
                                  "Details",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Location: Addis Ababa, Gerjii',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
