import 'package:assignment/commonWidgets/commonWidgets.dart';
import 'package:assignment/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coding Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SignupPage(),
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";
  String _password = "";
  String _phone = "";
  bool _showPassword = false;
  String dropdownvalue = "Select a profession";
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Signup", context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: GoogleFonts.lato(color: Colors.black),
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.lato(color: Colors.black),
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      style: GoogleFonts.lato(color: Colors.black),
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ))),
                      obscureText: !_showPassword,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: GoogleFonts.lato(color: Colors.black),
                  decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  controller: phoneController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your Phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(

                      // labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  value: dropdownvalue,
                  // icon: const Icon(Icons.location_city),
                  dropdownColor: Colors.blue[50],
                  items: [
                    "Select a profession",
                    "Engineer",
                    "Doctor",
                    "Teacher",
                    "CA"
                  ].map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: GoogleFonts.lato(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownvalue = value.toString();
                    });
                  },
                  validator: ((value) {
                    if (value.toString() == "Select a profession") {
                      return "Select a profession.";
                    }
                  }),
                  focusColor: Colors.blue,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.red,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    style: customAgreeButtonStyle(context),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () async {
                      if (true) {
                        print("hello");
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('name', _name);
                          await prefs.setString('email', _email);
                          await prefs.setString('password', _password);
                          await prefs.setString('phone', _phone);
                          await prefs.setString('profession', dropdownvalue);
                          await Fluttertoast.showToast(
                              msg: "You have Successfully Signup !");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
