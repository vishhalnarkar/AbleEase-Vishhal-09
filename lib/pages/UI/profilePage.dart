import 'package:ableeasefinale/pages/UI/insightsPage.dart';
import 'package:ableeasefinale/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/appColors.dart';
import '../../theme/profileBarChart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var authMethods = AuthMethods();
  String username = "";

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username=(snap.data() as Map<String, dynamic>) ['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main Home Column
      body: Column (
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Notification Bar Padding
          const SizedBox(
            height: 42,
            // 37 looked perfect
            // 42 perfect starts right after the notification bar
          ),

          // For Name and Icon
          SizedBox(
            // color: Colors.white,
            height: 200,
            width: 411,

            // To align Name and Icon side by side
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              // To align greattings and Name One below the other
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                    Expanded(
                      child: Text(
                        '${username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              // For Padding
              const SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0, top: 20, left: 30),
                child: CircleAvatar(
                  radius: 67,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: const CircleAvatar(
                    radius: 65,
                    foregroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                ),
              )
            ]),
          ),

          // Padding Between Name
          const SizedBox(height: 40),


          GestureDetector (
            child: Image(image: AssetImage('assets/images/seeInsights.png'),
            width: 400,
            height:300,
            
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InsightsPage()));}
          ),

          //Bar Graphs
          // const Center(
          //   child: SizedBox(
          //     height: 400,
          //     child: MyBarChart(),
          //   ),

          // ),
          //See insights button



          SizedBox(
            height: 36,
          ),


          // Logout Button
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary
                    ),
                    
                    child: Text("LOGOUT", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    onPressed: () {
                      authMethods.signOutUser(context);
                      setState(() {
                        
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 25,
          ),

          // Container(
          //   color: Theme.of(context).colorScheme.primary,
          //   height: 200,
          //   width: 200,
          //   child: Column(
          //     children: [],
          //   ),
          // )
        ],
      ),
    );
  }
}
