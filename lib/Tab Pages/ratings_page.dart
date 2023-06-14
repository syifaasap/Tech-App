import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:tech_app/InfoHandler/info_handler_app.dart';

import '../Global/global.dart';

class RatingTabPages extends StatefulWidget {
  String? assignedTechnicianId;
  RatingTabPages({super.key, this.assignedTechnicianId});

  @override
  State<RatingTabPages> createState() {
    return _RatingTabPagesState();
  }
}

class _RatingTabPagesState extends State<RatingTabPages> {
  double ratingsNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRatingsNumber();
  }

  getRatingsNumber() {
    setState(() {
      ratingsNumber = double.parse(Provider.of<InfoApp>(context, listen: false)
          .technicianAverageRatings);
    });

    setupRatingsTitle();
  }

  setupRatingsTitle() {
    if (ratingsNumber == 1) {
      setState(() {
        titleStarsRating = "Very Bad";
      });
    }
    if (ratingsNumber == 2) {
      setState(() {
        titleStarsRating = "Bad";
      });
    }
    if (ratingsNumber == 3) {
      setState(() {
        titleStarsRating = "Good";
      });
    }
    if (ratingsNumber == 4) {
      setState(() {
        titleStarsRating = "Very Good";
      });
    }
    if (ratingsNumber == 5) {
      setState(() {
        titleStarsRating = "Excellent";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white60,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22.0,
              ),
              const Text(
                "Your Experience",
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 72, 147, 137),
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              const Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              const SizedBox(
                height: 22.0,
              ),
              SmoothStarRating(
                rating: ratingsNumber,
                allowHalfRating: false,
                starCount: 5,
                color: const Color.fromARGB(255, 38, 65, 62),
                borderColor: const Color.fromARGB(255, 38, 65, 62),
                size: 46,
                onRatingChanged: (valueOfStarsChoosed) {
                  ratingsNumber = valueOfStarsChoosed;
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                titleStarsRating!,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 70, 81, 79),
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseReference rateTechnicianRef = FirebaseDatabase
                        .instance
                        .ref()
                        .child("technicians")
                        .child(widget.assignedTechnicianId!)
                        .child("ratings");

                    rateTechnicianRef.once().then((snap) {
                      if (snap.snapshot.value == null) {
                        rateTechnicianRef.set(ratingsNumber.toString());

                        SystemNavigator.pop();
                      } else {
                        double pastRatings =
                            double.parse(snap.snapshot.value.toString());
                        double newAverageRatings =
                            (pastRatings + ratingsNumber) / 2;
                        rateTechnicianRef.set(newAverageRatings.toString());

                        SystemNavigator.pop();
                      }

                      Fluttertoast.showToast(msg: "Please Restart App Now");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 72, 147, 137),
                    padding: const EdgeInsets.symmetric(horizontal: 74),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
