import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../commonWidgets/commonWidgets.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String address = 'Geeksynergy Technologies Pvt Ltd';
    const String email = 'XXXXXX@gmail.com';
    const String phone = 'XXXXXXXXX09';
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: customAppBar("About Us", context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/about_lottie.json'),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Geeksynergy Technologies Pvt Ltd provides a platform for lorem eposum to rloreum sdofj epsumns. We aim to help businesses in loreum edpis lottie gains.",
                  style: GoogleFonts.openSans(
                      fontSize: height / 55, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.transparent, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Reach Out To Us",
                          style: GoogleFonts.lato(
                              fontSize: height / 42,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                            height: height * 0.065,
                            child: Lottie.asset(
                              "assets/about2_lottie.json",
                            ))
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red[300],
                          size: 35,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            address,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.openSans(
                                fontSize: height / 60,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.email, color: Colors.indigo, size: 28),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            child: Text(
                              email,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            onTap: () {
                              // launch('mailto:$email');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.phone,
                            color: Colors.blueAccent, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            child: Text(
                              phone,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.ubuntu(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            onTap: () {
                              // launch('tel:$phone');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
