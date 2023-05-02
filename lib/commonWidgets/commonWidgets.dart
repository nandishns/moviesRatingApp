import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Color appLightBlue() {
  return const Color(0xff9FD7f7);
}

String firstLetterToUpperCase(String value) {
  return value.toString().split(" ").map((e) {
    if (e.length == 1) {
      return e.toUpperCase();
    } else {
      if (e == "") {
        return e;
      }
      return e[0].toUpperCase() + e.substring(1).toLowerCase();
    }
  }).join(" ");
}

PreferredSizeWidget customAppBar(String pageName, BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return PreferredSize(
    preferredSize: Size.fromHeight(height * 0.065),
    child: AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.indigo[50],
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
      elevation: 0,
      backgroundColor: appLightBlue(),
      shape: CustomShapeClipper().toBorder(),
      title: Text(pageName),
      centerTitle: true,
      titleTextStyle: GoogleFonts.lato(
          color: Colors.black,
          fontSize: height / 42,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600),
    ),
  );
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  ShapeBorder toBorder() {
    return RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        side: BorderSide(
          color: Colors.indigo.shade50,
          width: 2,
        ));
  }
}

ButtonStyle customAgreeButtonStyle(context) {
  final height = MediaQuery.of(context).size.height;
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(appLightBlue()),
    fixedSize: MaterialStateProperty.all(
        Size(MediaQuery.of(context).size.width * 0.4, height * 0.052)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.lightBlue.shade500),
      ),
    ),
  );
}
