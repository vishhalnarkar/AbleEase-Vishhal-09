import 'package:ableeasefinale/pages/UI/meditationPage.dart';
import 'package:ableeasefinale/pages/UI/navigationBar.dart';
import 'package:ableeasefinale/pages/UI/previousGame.dart';
import 'package:ableeasefinale/pages/doctorPages/doctorparentPage.dart';
import 'package:ableeasefinale/resources/scores_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:disabilities_traning_app/pages/navigationBar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class doctorHomePage extends StatefulWidget {
  const doctorHomePage({super.key});

  @override
  State<doctorHomePage> createState() => _doctorHomePageState();
}

class _doctorHomePageState extends State<doctorHomePage> {
  String username = "";

  List<String> quotesOfTheDays = [
    "The art of medicine consists of amusing the patient while nature cures the disease.",
    "Wherever the art of medicine is loved, there is also a love of humanity.",
    "Sometimes the best medicine is a kind word and a listening ear.",
    "Healing takes time, but a good doctor makes the journey easier.",
    "The mind is just as important to treat as the body.",
    "Medicine can cure disease, but only the mind can heal the soul.",
    "The doctor of the future will give no medicine but will instruct in care of the mind and body.",
    "A good doctor treats the disease; a great doctor treats the person who has the disease.",
    "Listen to your patient; they are telling you the diagnosis.",
    "Mental health is just as critical as physical health.",
    "The brain and the heart both need healing to thrive.",
    "Not all wounds are visible; treat each patient with empathy.",
    "A smile can be the best prescription for many illnesses.",
    "The best doctors are those who inspire hope in their patients.",
    "Medicine is a science of uncertainty and an art of probability.",
    "Your mental health is just as important as your physical health.",
    "The first step toward healing is believing that it is possible.",
    "Doctors fix the body; compassion fixes the soul.",
    "Every patient carries their own doctor inside them.",
    "It's okay not to be okay—seek help and start healing.",
    "The best prescription for patients is often just kindness.",
    "Healing doesn't mean the damage never existed. It means the damage no longer controls your life.",
    "Treat the patient, not the disease.",
    "Good mental health is a doctor's greatest gift to their patient.",
    "Empathy is the heartbeat of healthcare.",
    "A good psychiatrist listens; a great one understands.",
    "Taking care of your mind is just as essential as caring for your body.",
    "The best doctor gives the least medicine and the most understanding.",
    "Mental health care is not a luxury; it's a necessity.",
    "Health is not just the absence of disease; it's the presence of peace.",
    "The mind is the most complex organ to heal but the most rewarding.",
    "A doctor can treat symptoms; only compassion can treat the soul.",
    "Every patient deserves respect, empathy, and dignity.",
    "Mental strength is not the ability to stay out of the dark, but to sit in it with peace.",
    "Sometimes the best therapy is just being heard.",
    "Psychiatry helps people become who they were meant to be.",
    "The greatest gift a doctor can give is hope.",
    "Healing happens when patients feel understood.",
    "In medicine, knowledge cures disease, but compassion cures people.",
    "Being healthy mentally is a journey, not a destination.",
    "Doctors guide the healing process, but patients do the healing.",
    "The best treatment plan includes kindness and care.",
    "Mental health isn't just treating illness; it's building strength.",
    "A psychiatrist doesn't just treat the brain but nurtures the heart.",
    "Care for the whole person, not just their condition.",
    "Medicine treats the body; good doctors treat the spirit too.",
    "Mental health is the cornerstone of a healthy life.",
    "Caring for the mind is as important as caring for the heart.",
    "Doctors hold the knowledge, but empathy holds the cure.",
    "Good mental health is as important as breathing.",
    "Listening is often more healing than prescribing.",
    "Every patient is a story waiting to be heard.",
    "Healing is not about fixing; it's about finding balance.",
    "Treat the mind with the same importance as the body.",
    "A patient's trust is the foundation of healing.",
    "Mental health treatment restores the freedom to live.",
    "Your brain needs care, just like your heart.",
    "Hope is the best medicine any doctor can offer.",
    "Empathy is the invisible medicine that heals all wounds.",
    "Never underestimate the power of simply listening.",
    "In mental health care, compassion speaks louder than words.",
    "Healing begins where empathy thrives.",
    "A psychiatrist is a gardener of the mind.",
    "Empathy is the first step toward healing mental illness.",
    "Mental wellness requires care and support, not just pills.",
    "When doctors care, healing accelerates.",
    "A psychiatrist sees beyond the symptoms to the soul.",
    "Care for your mental garden; your thoughts are the seeds.",
    "Mental health matters because you matter.",
    "There's no shame in asking for help.",
    "Healing starts by acknowledging your worth.",
    "Mental care isn't just about surviving—it's about thriving.",
    "The brain deserves just as much attention as the heart.",
    "Healing the mind restores life's color.",
    "The best doctors guide healing, not force it.",
    "The human mind is resilient beyond measure.",
    "Hope is stronger than despair—always.",
    "Small conversations can lead to great breakthroughs.",
    "The brain's health is a journey worth investing in.",
    "Doctors don't just save lives; they help create better ones.",
    "Mental health treatment restores confidence and peace.",
    "It's brave to seek help when needed.",
    "The best therapy often comes from authentic care.",
    "Never be ashamed to speak about your mental health.",
    "The mind, body, and soul must be healed together.",
    "Your mental health defines the quality of your life.",
    "Even doctors need to prioritize mental health.",
    "The best medical care is given with compassion.",
    "Mental wellness is a continuous process, not a one-time fix.",
    "Listen with empathy, treat with care.",
    "Believe you can and you're halfway there.",
    "Your limitation—it's only your imagination.",
    "Push yourself, because no one else is going to do it for you.",
    "Great things never come from comfort zones.",
    "Dream it. Wish it. Do it.",
    "Success doesn't just find you. You have to go out and get it.",
    "The harder you work for something, the greater you'll feel when you achieve it.",
    "Dream bigger. Do bigger.",
    "Don't stop when you're tired. Stop when you're done.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Do something today that your future self will thank you for.",
    "Little things make big days.",
    "It's going to be hard, but hard does not mean impossible.",
    "Don't wait for opportunity. Create it.",
    "Sometimes we're tested not to show our weaknesses, but to discover our strengths.",
    "The key to success is to focus on goals, not obstacles.",
    "Dream it. Believe it. Build it.",
    "Keep going. Everything you need will come to you at the perfect time.",
    "Don't watch the clock; do what it does. Keep going.",
    "Doubt kills more dreams than failure ever will.",
    "The secret of getting ahead is getting started.",
    "If it doesn't challenge you, it won't change you.",
    "Life is 10% what happens to us and 90% how we react to it.",
    "Perseverance is not a long race; it is many short races one after the other.",
    "Keep your face always toward the sunshine—and shadows will fall behind you.",
    "The only limit to our realization of tomorrow is our doubts of today.",
    "Opportunities don't happen. You create them.",
    "Success is the sum of small efforts repeated day in and day out.",
  ];

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  int generateRandomNumber() {
    Random random = Random();
    return random.nextInt(100); // Generates a number between 0 and 99
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      // username = (snap.data() as Map<String, dynamic>)['username'];
      // username=username.substring(8,);
      // username=username.trim();
    });
  }

  String getGreetings() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    if (currentHour < 12) {
      return "Good Morning,";
    } else if (currentHour < 18) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main Home Column
      body: Column(
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
                      getGreetings(),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                    Expanded(
                      child: Text(
                        'Dr. Jayesh',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

          // Padding Between Name, Icon and Quote of the day
          const SizedBox(height: 10),

          // Quote of the day
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.primary),
            width: MediaQuery.of(context).size.width - 25,
            height: 150,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text("Quote of the day"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Text(
                    "\"${quotesOfTheDays[generateRandomNumber()]}\"",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 18),
                  ),
                )
              ],
            ),
          ),

          SizedBox(
            height: 25,
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // doc.navigateToPage(2);
                      // navigateToPage(2);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.primary),
                    width: MediaQuery.of(context).size.width / 2 - 25,
                    height: 200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "Recommended",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image(
                            image: AssetImage('assets/images/meditating.png'),
                            width: 100,
                          ),
                        ),
                        Text(
                          "Meditation",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // doc.navigateToPage(2);
                      // navigateToPage(2);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.primary),
                    width: MediaQuery.of(context).size.width / 2 - 25,
                    height: 200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "View Patients",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(Icons.person, size: 100),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
