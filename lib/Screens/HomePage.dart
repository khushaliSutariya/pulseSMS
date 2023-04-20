import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phonebook/Screens/LoginScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var name = "", email = "", photo = "";

  List<Contact>? contacts;
  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name").toString();
      email = prefs.getString("email").toString();
      photo = prefs.getString("photo").toString();
    });
  }
  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    getContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phonebook",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: Image.asset("assets/images/menu.png",color: Colors.red,height: 40.0,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              accountName: Text(
                name,
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.amber.shade50,
                radius: 30.0,
                backgroundImage: NetworkImage(photo),
                //Text
              ),
            ),
            ListTile(
              title: Container(
                height: 30.0,
                width: 100.0,
                color: Colors.amber.shade200,
                child: Center(child: Text("Log out")),
              ),
              onTap: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                GoogleSignIn googlesignin = GoogleSignIn();
                googlesignin.signOut();
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginScreens(),
                ));
              },
            ),
          ],
        ),
      ),
      body:
      (contacts) == null
          ? Center(child: CircularProgressIndicator())
          :
      ListView.builder(
        itemCount: contacts!.length,
        itemBuilder: (BuildContext context, int index) {
          Uint8List? image = contacts![index].photo;
          String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0,right: 8.0,left: 20.0),
                child: ListTile(
                    leading: (contacts![index].photo == null)
                        ? const CircleAvatar(child: Icon(Icons.person))
                        : CircleAvatar(backgroundImage: MemoryImage(image!)),
                    trailing: Icon(Icons.call),
                    title: Text(
                        "${contacts![index].name.first} ${contacts![index].name.last}"),
                    subtitle: Text(num),
                    onTap: () {
                      if (contacts![index].phones.isNotEmpty) {
                        launch('tel: ${num}');
                      }
                    }),
              ),
            ],
          );
        },
      ));

  }
}
