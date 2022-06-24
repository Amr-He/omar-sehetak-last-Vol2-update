import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sehetak2/screens/bottom_bar.dart';
import 'package:sehetak2/screens/components%20drawer/contact.dart';
import 'package:sehetak2/screens/medicine-remminder/screens/home/home.dart';
import 'package:sehetak2/screens/pediatric-home.dart';
import 'package:sehetak2/screens/sos/sos.dart';
import 'package:sehetak2/widget/OnlineConsultation.dart';
import 'package:sehetak2/widget/home-examination.dart';

import '../initial_diagnosis/initial_diagnosis_home.dart';

class Dashboard extends StatefulWidget {
  static String uid;
  static String name;
  static String email;
  static String joinedAt;
  static String userImageUrl;
  static int phoneNumber;
  const Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to exit an App?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
  void getData() async {
    User user = _auth.currentUser;
    Dashboard.uid = user.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    final DocumentSnapshot userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(Dashboard.uid).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        Dashboard.name = userDoc.get('name');
        Dashboard.email = user.email;
        Dashboard.joinedAt = userDoc.get('joinedAt');
        Dashboard.phoneNumber = userDoc.get('phoneNumber');
        Dashboard.userImageUrl = userDoc.get('imageUrl');
      });
    }
    // print("name $_name");
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb7dcea),Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: NavDrawer(),
          appBar: AppBar(
            brightness: Brightness.dark,
            //remove bcakgroundcolor from appbar
            backgroundColor: Colors.transparent,
            //remove shadwo frome app bar
            elevation: 0 ,
            flexibleSpace:Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30) ),
                gradient: LinearGradient(
                  colors: [HexColor("#80b1fe"),HexColor("#3D50E7")],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            title: const Text('Home',style: TextStyle(color: Colors.white),),
          ),
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Dashboard.name != null ? Dashboard.name : "User",
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                      const Text(
                        "Welcome To Sehetk!!",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xff80B1FE),),

                      ),
                    ],
                  ),
                ),
              ),

              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(Dashboard.userImageUrl != null ? Dashboard.userImageUrl : ""),
                  ) ,
                ),
              ),
              const SizedBox(height: 50,),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 50,),
                    Expanded(
                      child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: <Widget>[
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BottomBarScreen()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/icons8_shopping_cart_240px_1 1.png",width: 70,height: 70,),
                                  const Text('Online Pharmacy',style: TextStyle(fontSize: 12,color: Colors.white),),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const OnlineConsultation()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/chat.png",height: 60,),
                                  const Text('Online Consultation',style: TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeExamination()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/icons8_home_80px 1.png",height: 60,),
                                  const Text('Home Examinations',style: TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/icons8_timesheet_128px 1.png",height: 60,),
                                  const Text('Book An Appointment',style: TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: ()
                              {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>IntialDiagnisisHomeScreen()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/icons8_health_checkup_100px 1.png",height: 60,),
                                  const Text('Intial Diagnosis',style: TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const showSos()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/image 5.png",height: 60,),
                                  const Text('SOS',style: TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MakeDashboardItems()));
                                
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/pharmacy.png",height: 60,),
                                  const Text('Pediatric Dose',style: TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: const Color(0xff80B1FE),
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeReminder()));

                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("assets/lottie/reminder.png",height: 60,),
                                  const Text('Medicine Reminder',style: const TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            margin: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(Dashboard.userImageUrl != null ? Dashboard.userImageUrl : "",),
                ),

                Expanded(
                  child: Text(Dashboard.name != null ? Dashboard.name : "User",style:
                  const TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black),),
                ),
                Expanded(
                  child: Text(Dashboard.phoneNumber != null ? Dashboard.phoneNumber.toString() : "Phone Number",style:
                  TextStyle(fontSize: 12,color: Colors.grey[600]),),
                )
              ],
            ),
          ),

          ListTile(
            leading: Image.asset("assets/lottie/setuser.png"),
            title: Text('Account settings',style: TextStyle(color: HexColor("#807C7C")),),
            onTap: () => {},
          ),
          ListTile(
            leading:  Image.asset("assets/lottie/setting.png"),
            title: Text('Setting',style: TextStyle(color: HexColor("#807C7C")),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Image.asset("assets/lottie/Group.png"),
            title: Text('Feedback & Contact us',style: TextStyle(color: HexColor("#807C7C")),),
            onTap:  (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Contact()));
              },
          ),
          Divider(
            color: HexColor("#E5E5E9"),
          ),
          ListTile(
            leading: Image.asset("assets/lottie/share 1.png"),
            title: Text('Tell your friend',style: TextStyle(color: HexColor("#807C7C")),),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Image.asset("assets/lottie/Logout.png"),
            title: Text('Sign out',style: TextStyle(color: HexColor("#807C7C")),),
            onTap: () async {
              // await _auth.signOut().then(
              //         (value) =>
              //         Navigator.pop(context));
            },
          ),
        ],
      ),
    );
  }
}