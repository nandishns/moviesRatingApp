import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:assignment/commonWidgets/commonWidgets.dart';
import 'package:assignment/pages/companyInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Movie {
  final title;
  final language;
  final director;
  final genre;
  final actors;
  final poster;
  final synopsis;
  final imdbRating;
  final upVoted;
  final pageViews;
  final voting;

  Movie({
    required this.title,
    required this.language,
    required this.director,
    required this.genre,
    required this.actors,
    required this.poster,
    required this.synopsis,
    required this.imdbRating,
    required this.upVoted,
    required this.pageViews,
    required this.voting,
  });

  factory Movie.fromJson(json) {
    return Movie(
        title: json['title'],
        language: json['language'],
        director: json['director'],
        genre: json['genre'],
        actors: json['stars'],
        poster: json['poster'],
        synopsis: json['synopsis'],
        imdbRating: json['imdb_rating'],
        upVoted: json["upVoted"],
        pageViews: json['pageViews'],
        voting: json['voting']);
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> _futureMovies;

  @override
  void initState() {
    super.initState();
    _futureMovies = fetchMovies();
  }

  Future<dynamic> fetchMovies() async {
    final response = await http.post(
      Uri.parse('https://hoblist.com/api/movieList'),
      body: {
        'category': 'movies',
        'language': 'kannada',
        'genre': 'all',
        'sort': 'voting',
      },
    );

    if (response.statusCode == 200) {
      final moviesJson = json.decode(response.body)['result'];
      // print(moviesJson);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: FutureBuilder<dynamic>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data!;

            return showMovies(context, movies);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget showMovies(context, snapshot) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Column(
      children: List.generate(snapshot.length, (index) {
        return showMoviesWidgets(snapshot[index], height, width, index,
            onTap: (selectedIndex) {});
      }),
    ));
  }

  Widget showMoviesWidgets(snapshots, height, width, index, {onTap}) {
    // var upVotes = 0;
    var upvotes = snapshots.upVoted == null ? "0" : snapshots.upVoted.length;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        margin:
            EdgeInsets.fromLTRB(width * 0.03, 10, width * 0.03, width * 0.005),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // Voting container
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          //upVote Logic
                          setState(() {
                            upvotes++;
                          });
                          print(upvotes);
                        },
                        icon: Icon(Icons.arrow_upward),
                      ),
                      Text(
                        "$upvotes",
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            upvotes--;
                          });
                          print(upvotes);
                        },
                        icon: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Poster container
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        snapshots.poster,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshots.title,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SizedBox(height: 8),
                        Text(
                          "${snapshots.language} | ${firstLetterToUpperCase(snapshots.genre.toString())}",
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Directors: ${snapshots.director[0].toString()}",
                          style: GoogleFonts.openSans(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 2),

                        SizedBox(
                          height: height * snapshots.actors.length * 0.04,
                          width: width * 0.45,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListView.builder(
                                  itemCount: snapshots.actors.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String itemName = firstLetterToUpperCase(
                                        snapshots.actors[index].toString());
                                    String separator =
                                        (index == snapshots.actors.length - 1)
                                            ? '.'
                                            : ', ';
                                    return Text(
                                      'Starring: $itemName$separator',
                                      style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2),
                        Text(
                          "${snapshots.pageViews} views | Voted by ${snapshots.voting} person ",
                          style: GoogleFonts.openSans(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Container(
              width: 350,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(appLightBlue()),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 4)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse("https://www.youtube.com/"));
                  },
                  child: Text(
                    "Watch Trailer",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

// Widget showMovies(context, snapshot) {
//   final width = MediaQuery.of(context).size.width;
//   final height = MediaQuery.of(context).size.height;
//   return SingleChildScrollView(
//       child: Column(
//     children: List.generate(snapshot.length, (index) {
//       return showMoviesWidgets(snapshot[index], height, width, index,
//           onTap: (selectedIndex) {});
//     }),
//   ));
// }

// Widget showMoviesWidgets(snapshots, height, width, index, {onTap}) {
//   print("in showMOvie");
//   var upvotes = snapshots.upVoted == null ? "0" : snapshots.upVoted.length;
//   return Container(
//     margin: EdgeInsets.fromLTRB(width * 0.03, 10, width * 0.03, width * 0.005),
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Colors.white.withOpacity(0.2),
//           spreadRadius: 2,
//           blurRadius: 2,
//           offset: const Offset(0, 3), // changes position of shadow
//         ),
//       ],
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.grey.shade300),
//     ),
//     child: Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               // Voting container
//               width: 40,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       //upVote Logic
//
//                       // setState({
//                       // upvotes++
//                       // });
//                       print(upvotes);
//                     },
//                     icon: Icon(Icons.arrow_upward),
//                   ),
//                   Text(
//                     "$upvotes",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       // SetState({
//                       // upvotes--
//                       // });
//                       print(upvotes);
//                     },
//                     icon: Icon(Icons.arrow_downward),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               // Poster container
//               width: 100,
//               height: 150,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     snapshots.poster,
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       snapshots.title,
//                       style: GoogleFonts.openSans(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     // SizedBox(height: 8),
//                     Text(
//                       "${snapshots.language} | ${firstLetterToUpperCase(snapshots.genre.toString())}",
//                       style: GoogleFonts.openSans(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Directors: ${snapshots.director[0].toString()}",
//                       style: GoogleFonts.openSans(
//                           fontSize: 14, fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(height: 2),
//
//                     SizedBox(
//                       height: height * snapshots.actors.length * 0.04,
//                       width: width * 0.45,
//                       child: Flex(
//                         direction: Axis.horizontal,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: ListView.builder(
//                               itemCount: snapshots.actors.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 String itemName = firstLetterToUpperCase(
//                                     snapshots.actors[index].toString());
//                                 String separator =
//                                     (index == snapshots.actors.length - 1)
//                                         ? '.'
//                                         : ', ';
//                                 return Text(
//                                   'Starring: $itemName$separator',
//                                   style: GoogleFonts.openSans(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     SizedBox(height: 2),
//                     Text(
//                       "${snapshots.pageViews} views | Voted by ${snapshots.voting} person ",
//                       style: GoogleFonts.openSans(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 2),
//         Container(
//           width: 350,
//           child: ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStateProperty.all<Color>(appLightBlue()),
//                 padding: MaterialStateProperty.all<EdgeInsets>(
//                     EdgeInsets.symmetric(vertical: 10, horizontal: 4)),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     side: BorderSide(color: Colors.blue),
//                   ),
//                 ),
//               ),
//               onPressed: () {
//                 print("pressed");
//                 launchUrl(Uri.parse("https://www.youtube.com/"));
//               },
//               child: Text(
//                 "Watch Trailer",
//                 style: GoogleFonts.openSans(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     letterSpacing: 0.5,
//                     color: Colors.black),
//               )),
//         )
//       ],
//     ),
//   );
// }

PreferredSizeWidget appBar(
  BuildContext context,
) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return PreferredSize(
    preferredSize: Size.fromHeight(height * 0.062),
    child: AppBar(
      leading: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: IconButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.black,
              size: 36,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        );
      }),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.indigo[50],
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      elevation: 0,
      backgroundColor: appLightBlue(),
      shape: CustomShapeClipper().toBorder(),
      title: Row(
        children: [
          Expanded(
            flex: 5,
            child: AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
              TypewriterAnimatedText("Welcome !",
                  textAlign: TextAlign.center,
                  textStyle: GoogleFonts.poppins(
                      fontSize: height / 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  speed: const Duration(milliseconds: 250),
                  cursor: ""),
            ]),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutUs()));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 2),
                    // borderRadius: const BorderRadius.all(
                    //   Radius.circular(60),
                    // ),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.info,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
