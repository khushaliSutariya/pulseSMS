import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phonebook/Screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({Key? key}) : super(key: key);

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
   FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              final GoogleSignIn googleSignIn = GoogleSignIn();
              final GoogleSignInAccount? googleSignInAccount =
                  await googleSignIn.signIn();
              if (googleSignInAccount != null) {
                final GoogleSignInAuthentication googleSignInAuthentication =
                    await googleSignInAccount.authentication;
                final AuthCredential authCredential =
                    GoogleAuthProvider.credential(
                        idToken: googleSignInAuthentication.idToken,
                        accessToken: googleSignInAuthentication.accessToken);
                UserCredential result = await auth.signInWithCredential(authCredential);
                User? user = result.user;
                var name = user!.displayName.toString();
                var photo = user!.photoURL.toString();
                var email = user!.email.toString();
                var googleid = user!.uid.toString();
                print(name);
                print(photo);
                print(email);
                print(googleid);
                SharedPreferences prefs =await SharedPreferences.getInstance();
                prefs.setString("name", name);
                prefs.setString("email", email);
                prefs.setString("photo", photo);
                prefs.setString("googleid", googleid);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));

              }
            },
            child: Center(
              child: Container(
                width: 300.0,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.deepOrange.shade50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/google.png",
                      height: 20.0,
                      width: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Sign in with google"),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
