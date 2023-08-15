import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'questions.dart';
import 'answer.dart';
import 'json.dart';
import 'welcome.dart';
import 'admin.dart';

// import 'application.dart';
void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: Color(0xFFC8E6C9)),
      routes: <String, WidgetBuilder>{
        '/admin': (context) => Admin(),
      },
      home: MyApp(),
    );
  }
}

List<myModel> questions = [];
dynamic question_length = 0;
dynamic subject_picked = false;
dynamic topic = '';
List<String> subject = [];

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

dynamic register = false;
dynamic _incorrect = "";
var score = 0;
TextEditingController _textController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _passwordController1 = TextEditingController();

var users = [
  {"username": "admin", "password": "admin"},
  {"username": "", "password": ""}
];
var logged_in = false;
var admin = false;

class MyAppState extends State<MyApp> {
  int _counter = 0;
  String jwt_token = '';

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // Future<bool> _exitApp(BuildContext context) {
  //   return showDialog(
  //         context: context,
  //         child: AlertDialog(
  //           title: Text('Do you want to exit this application?'),
  //           content: Text('We hate to see you leave...'),
  //           actions: <Widget>[
  //             FlatButton(
  //               onPressed: () {
  //                 print("you choose no");
  //                 Navigator.of(context).pop(false);
  //               },
  //               child: Text('No'),
  //             ),
  //             FlatButton(
  //               onPressed: () {
  //                 SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //               },
  //               child: Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       );
  // }

  //Loading counter value on start
  Future<String> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt_token = (prefs.getString('jwt_token') ?? '');
      _counter = (prefs.getInt('counter') ?? 0);
      print(jwt_token);
    });
    return jwt_token;
  }

  //Incrementing counter after click
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  void _getJWT(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt_token = (prefs.getString('jwt_token') ?? '') + jwt;
      prefs.setString('jwt_token', jwt);
    });
    print(jwt_token);
  }

  void _nullJWT() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove("jwt_token");
      jwt_token = '';
    });
  }

  var url = 'http://localhost:8000';
  Future createUser(String phone, String password) {
    return post(
      Uri.parse(url + "/create"),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
      },
      body: json.encode(
        {'phone': phone, 'password': password},
      ),
    );
  }

  void login(phone, password) async {
    var response = await post(
      Uri.parse(url + "/login"),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
      },
      body: json.encode(
        {'phone': phone, 'password': password},
      ),
    );
    jsonBody = json.decode(response.body);
    // print(jsonBody['info']);
    if ((jsonBody['info'] as String) == 'Admin') {
      Navigator.pushNamed(context, '/admin');
    } else if ((jsonBody['access_token'] as String) != null) {
      setState(() {
        _incrementCounter();
        _getJWT(jsonBody['access_token']);
        logged_in = true;
        print(jwt_token);
      });
    } else {
      setState(() {
        logged_in = false;

        _incorrect = "Invalid Credentials";
      });
    }
  }

  var i = 0;

  void answer(String answers) {
    print(questions[i].answer1);
    print(questions[i].answer2);
    print(questions[i].answer3);
    print(questions[i].answer4);

    print("correct: " + answers);
    print(questions[i].correct);
    if (questions[i].correct == answers) {
      score += 1;
    }
    print(score);

    setState(() {
      if (i < questions.length) {
        print(question.length);
        i += 1;
      } else {
        question = [];
        questions = [];
      }
    });
  }

  // String subject(sub){

  // }

  var topic_picked = false;
  void reset() {
    setState(() {
      topic_picked = false;
      topic = '';
      subject_picked = false;
      score = 0;
      i = 0;
    });
  }

  var uri = 'http://localhost:8000';
// Future gets(branch) async{
//   final response = await get(Uri.parse( uri + '/question/get/' + branch));
//   var item = json.decode(response.body);

//   var questions = [];
//   for (var json in item){
//     questions.add(Json.fromJson(json));
//   }

// }
//   questions.clear();
  var jsonBody;

  Future gets(branch) async {
    var response = await get(Uri.parse(url + "/question/get/" + branch));

    if (response.statusCode == 200) {
      String responeBody = response.body;
      jsonBody = json.decode(responeBody);
      for (var data in jsonBody) {
        questions.add(new myModel(
          data['id'],
          data['question'],
          data['correct'],
          data['answer_1'],
          data['answer_2'],
          data['answer_3'],
          data['answer_4'],
        ));
      }
      setState(() {});
      questions.forEach((someData) => print("question : ${someData.question}"));
    } else {
      print('Something went wrong');
    }

    return questions;
  }

  void subjects(subject) async {
    if (topic == 'MBBS') {
      questions.clear();
      // print(questions);

      question = await gets('MBBS/' + subject);
      print(question.length);
      setState(() {
        question_length = question.length - 1;
        print(question_length);
        topic_picked = true;
        i = 0;
        subject_picked = true;
      });
    }
    if (topic == 'Agriculture') {
      questions.clear();
      // print(questions);

      question = await gets('Agriculture/' + subject);
      print(question.length);
      setState(() {
        question_length = question.length - 1;
        print(question_length);
        topic_picked = true;
        i = 0;
        subject_picked = true;
      });
    }
    if (topic == 'BMLT') {
      questions.clear();
      // print(questions);

      question = await gets('BMLT/' + subject);
      print(question.length);
      setState(() {
        question_length = question.length - 1;
        print(question_length);
        topic_picked = true;
        i = 0;
        subject_picked = true;
      });
    }
    if (topic == 'Nursing License') {
      questions.clear();
      // print(questions);

      question = await gets('Nursing License/' + subject);
      print(question.length);
      setState(() {
        question_length = question.length - 1;
        print(question_length);
        topic_picked = true;
        i = 0;
        subject_picked = true;
      });
    }
    // return get(
    //     Uri.parse(url + "/create?phone=" + phone + "&password=" + password));
  }

  void MBBS() async {
    setState(() {
      topic = 'MBBS';
      subject = ['Zoology', 'Botany', 'Chemistry', 'MAT'];
    });

    // //from here new
    // questions.clear();
    // // print(questions);

    // question = await gets('MBBS');
    // print(question.length);
    // setState(() {
    //   question_length = question.length - 1;
    //   print(question_length);
    //   topic_picked = true;
    //   i = 0;
    // });
    // // print(question );
  }

  void Nursing_License() async {
    setState(() {
      topic = 'Nursing License';
      subject = [
        'Integrated Science',
        'Community Health Nursing',
        'Fundamental of Nursing',
        'Adult Nursing',
        'Child Health Nursing',
        'Midwifery and Gynecology',
        'Leadership and Management',
      ];
    });
  }

  void BMLT() async {
    setState(() {
      topic = 'BMLT';
      subject = [
        'Zoology',
        'Botany',
        'Chemistry',
        'MAT',
      ];
    });
  }

  void ag() async {
    setState(() {
      topic = 'Agriculture';
      subject = [
        'English',
        'Physics',
        'Chemistry',
        'Maths',
        'Botany',
        'Zoology',
        'GK',
        'Relevant Science'
      ];
    });
  }

  void logout() {
    setState(() {
      logged_in = false;
      topic_picked = false;
      _counter = 0;
      jwt_token = '';
      subject_picked = false;
      _nullJWT();
    });
  }

  void onBackPressed() {}

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    var _formKey1 = GlobalKey<FormState>();
    var _formKey3 = GlobalKey<FormState>();
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     routes: <String,WidgetBuilder>{
    //       '/admin' : (context) => Admin(),
    //     },
    // home:
    return jwt_token != '' || (logged_in == true && admin == false)
        ? Scaffold(
            // drawer: Drawer(),
            appBar: AppBar(
              automaticallyImplyLeading: true,
              //`true` if you want Flutter to automatically add Back Button when needed,
              //or `false` if you want to force your own back button every where

              backgroundColor: nav,
              centerTitle: true,
              title: Text(
                "AOMEI",
                style: TextStyle(
                  fontFamily: 'Font1',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              actions: <Widget>[
                IconButton(onPressed: logout, icon: Icon(Icons.logout))
              ],
            ),
            body: topic_picked == false
                ? Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(70),
                          child: Text(
                            "CATEGORIES ",
                            style: TextStyle(
                              fontFamily: 'Font1',
                              color: Color.fromARGB(255, 115, 201, 196),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.all(5),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     height: 60,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         primary:
                        //             Color.fromARGB(255, 110, 216, 113),
                        //         shape: new RoundedRectangleBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(15.0),
                        //         ),

                        //         // Background color
                        //       ),
                        //       child: const Text(
                        //         'MBBS/BDS',
                        //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                        //       ),
                        //       onPressed: MBBS,
                        //     ),
                        //   ),
                        // ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Material(
                                    // color: kblue,
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(18),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      splashColor: kblue,
                                      onTap: () {
                                        setState(() {
                                          ag();
                                          topic_picked = true;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Ink.image(
                                            image: AssetImage(
                                                'assets/images/agro.png'),
                                            height: 180,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Agriculture",
                                            style: TextStyle(
                                              fontFamily: 'Font1',
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Material(
                                    // color: kblue,
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(18),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      splashColor:
                                          Color.fromARGB(255, 232, 245, 233),
                                      onTap: () {
                                        setState(() {
                                          MBBS();
                                          topic_picked = true;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Ink.image(
                                            image: AssetImage(
                                                'assets/images/sort.png'),
                                            height: 180,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "MBBS/BDS",
                                            style: TextStyle(
                                              fontFamily: 'Font1',

                                              fontSize: 16,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Material(
                                    // color: kblue,
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(18),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      splashColor: kblue,
                                      onTap: () {
                                        setState(() {
                                          BMLT();
                                          topic_picked = true;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Ink.image(
                                            image: AssetImage(
                                                'assets/images/lab.png'),
                                            height: 180,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "BMLT",
                                            style: TextStyle(
                                              fontFamily: 'Font1',
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Material(
                                    // color: kblue,
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(18),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      splashColor: kblue,
                                      onTap: () {
                                        setState(() {
                                          Nursing_License();
                                          topic_picked = true;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Ink.image(
                                            image: AssetImage(
                                                'assets/images/nurse.png'),
                                            height: 180,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Nursing License",
                                            style: TextStyle(
                                              fontFamily: 'Font1',
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Container(
                        //   margin: EdgeInsets.all(5),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     height: 60,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         shape: new RoundedRectangleBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(15.0),
                        //         ),
                        //         primary:
                        //             Color.fromARGB(255, 110, 216, 113),

                        //         // Background color
                        //       ),
                        //       child: const Text(
                        //         'Nursing License',
                        //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                        //       ),
                        //       onPressed: Nursing License,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.all(5),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     height: 60,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         shape: new RoundedRectangleBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(15.0),
                        //         ),
                        //         primary:
                        //             Color.fromARGB(255, 110, 216, 113),

                        //         // Background color
                        //       ),
                        //       child: const Text(
                        //         'BMLT',
                        //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                        //       ),
                        //       onPressed: BMLT,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.all(5),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     height: 60,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         shape: new RoundedRectangleBorder(
                        //           borderRadius:
                        //               new BorderRadius.circular(15.0),
                        //         ),
                        //         primary:
                        //             Color.fromARGB(255, 110, 216, 113),

                        //         // Background color
                        //       ),
                        //       child: const Text(
                        //         'Agriculture',
                        //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                        //       ),
                        //       onPressed: ag,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                : Scaffold(
                    body: (subject_picked == false)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Container(
                                  margin: EdgeInsets.all(30),
                                  child: Center(
                                    child: Text(
                                      "SUBJECTS",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 115, 201, 196),
                                        fontFamily: 'Font1',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.only(
                                //       left: 10.0,
                                //       right: 10.0,
                                //       top: 60,
                                //       bottom: 10),
                                //   child: SizedBox(
                                //     width: double.infinity,
                                //     height: 80,
                                //     child: ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //         primary: button,
                                //         shape: new RoundedRectangleBorder(
                                //           borderRadius:
                                //               new BorderRadius.circular(15.0),
                                //         ),

                                //         // Background color
                                //       ),
                                //       child: const Text(
                                //         'Physics',
                                //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                                //       ),
                                //       onPressed: () {
                                //         setState(() {
                                //           subject_picked = true;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   margin: EdgeInsets.all(10),
                                //   child: SizedBox(
                                //     width: double.infinity,
                                //     height: 80,
                                //     child: ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //         primary: button,
                                //         shape: new RoundedRectangleBorder(
                                //           borderRadius:
                                //               new BorderRadius.circular(15.0),
                                //         ),

                                //         // Background color
                                //       ),
                                //       child: const Text(
                                //         'Physics',
                                //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                                //       ),
                                //       onPressed: () {
                                //         setState(() {
                                //           subject_picked = true;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   margin: EdgeInsets.all(10),
                                //   child: SizedBox(
                                //     width: double.infinity,
                                //     height: 80,
                                //     child: ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //         primary: button,
                                //         shape: new RoundedRectangleBorder(
                                //           borderRadius:
                                //               new BorderRadius.circular(15.0),
                                //         ),

                                //         // Background color
                                //       ),
                                //       child: const Text(
                                //         'Physics',
                                //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                                //       ),
                                //       onPressed: () {
                                //         setState(() {
                                //           subject_picked = true;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   margin: EdgeInsets.all(10),
                                //   child: SizedBox(
                                //     width: double.infinity,
                                //     height: 80,
                                //     child: ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //         primary: button,
                                //         shape: new RoundedRectangleBorder(
                                //           borderRadius:
                                //               new BorderRadius.circular(15.0),
                                //         ),

                                //         // Background color
                                //       ),
                                //       child: const Text(
                                //         'Physics',
                                //         style: TextStyle(fontFamily: 'Font1',
// fontSize: 20),
                                //       ),
                                //       onPressed: () {
                                //         setState(() {
                                //           subject_picked = true;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),

                                Column(
                                  // alignment: Alignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ...(subject as List<String>).map((subject) {
                                      return ButtonTheme(
                                        height: 60,
                                        minWidth: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: Color.fromARGB(
                                                255, 140, 162, 221),
                                            child: Text(
                                              subject,
                                              style: TextStyle(
                                                fontFamily: 'Font1',
                                                fontSize: 25,
                                                color: Color.fromARGB(
                                                    255, 215, 236, 216),
                                              ),
                                            ),
                                            onPressed: () => subjects(subject),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ])
                        : i < (question.length - 1)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Question(questions[i].question),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonTheme(
                                        height: 60,
                                        minWidth: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: Color.fromARGB(
                                                255, 140, 162, 221),
                                            child: Text(
                                              questions[i].answer1,
                                              style: TextStyle(
                                                fontFamily: 'Font1',
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () =>
                                                answer(questions[i].answer1),
                                          ),
                                        ),
                                      ),
                                      ButtonTheme(
                                        height: 60,
                                        minWidth: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: Color.fromARGB(
                                                255, 140, 162, 221),
                                            child: Text(
                                              questions[i].answer2,
                                              style: TextStyle(
                                                fontFamily: 'Font1',
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () =>
                                                answer(questions[i].answer2),
                                          ),
                                        ),
                                      ),
                                      ButtonTheme(
                                        height: 60,
                                        minWidth: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: Color.fromARGB(
                                                255, 140, 162, 221),
                                            child: Text(
                                              questions[i].answer3,
                                              style: TextStyle(
                                                fontFamily: 'Font1',
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () =>
                                                answer(questions[i].answer3),
                                          ),
                                        ),
                                      ),
                                      ButtonTheme(
                                        height: 60,
                                        minWidth: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: Color.fromARGB(
                                                255, 140, 162, 221),
                                            child: Text(
                                              questions[i].answer4,
                                              style: TextStyle(
                                                fontFamily: 'Font1',
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () =>
                                                answer(questions[i].answer4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Text(" Result: $score / $question_length",
                                        style: TextStyle(
                                          fontFamily: 'Font1',

                                          color: Colors.black,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          // backgroundColor: Colors.black),
                                        )),
                                    Container(
                                      height: 60,
                                      margin: EdgeInsets.all(10),
                                      child: ButtonTheme(
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: Color.fromARGB(
                                              255, 140, 162, 221),
                                          child: Text(
                                            "GO BACK",
                                            style: TextStyle(
                                              fontFamily: 'Font1',
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: reset,
                                        ),
                                        minWidth: double.infinity,
                                        buttonColor: kblue,
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                  ),
          )
        : Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: true,
            //   //`true` if you want Flutter to automatically add Back Button when needed,
            //   //or `false` if you want to force your own back button every where

            //   backgroundColor: kblue,
            //   title: Text(
            //     "Smart Education",
            //     style: TextStyle(fontFamily: 'Font1',

            //       fontWeight: FontWeight.bold,
            //       fontSize: 23,
            //     ),
            //   ),
            // ),
            body: register == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: kblue,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(50))),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          "assets/images/welcome.png"))
                                ],
                              ),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'AOMEI',
                              style: TextStyle(
                                color: Color.fromARGB(255, 89, 158, 155),
                                fontFamily: 'Font1',
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: _formKey,
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: 'Phone number',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Form(
                            key: _formKey1,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password_sharp),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            _incorrect,
                            style: TextStyle(
                              fontFamily: 'Font1',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                primary: button,

                                // Background color
                              ),
                              child: const Text('Login'),
                              onPressed: () {
                                login(_textController.text,
                                    _passwordController.text);
                                // // for (int j = 0; j < users.length; j++) {
                                // //   if (users[j]["username"] ==
                                // //           _textController.text &&
                                // //       users[j]["password"] ==
                                // //           _passwordController.text) {
                                // //     setState(() {
                                // //       logged_in = true;
                                // //     });
                                // //   } else {
                                // //     setState(() {
                                // //       _incorrect = "Invalid Credentials";
                                // //     });
                                // //   }
                                // // }
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Text('Do\'nt have account?'),
                            TextButton(
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 89, 158, 155),
                                    fontFamily: 'Font1',
                                    fontSize: 17),
                              ),
                              onPressed: () {
                                setState(() {
                                  register = true;
                                  _incorrect = "";
                                });
                                //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ])
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: kblue,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(50))),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Image.asset(
                                          "assets/images/welcome.png"))
                                ],
                              ),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Color.fromARGB(255, 89, 158, 155),
                                fontFamily: 'Font1',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: _formKey,
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: 'New Phone number',
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Form(
                            key: _formKey1,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                labelText: 'New Password',
                                prefixIcon: Icon(Icons.password_sharp),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        //   child: Form(
                        //     key: _formKey3,
                        //     child: TextField(
                        //       controller: _passwordController1,
                        //       obscureText: true,
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(8)),
                        //         labelText: 'Retype New Password',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            _incorrect,
                            style: TextStyle(
                              fontFamily: 'Font1',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                primary: button,

                                // Background color
                              ),
                              child: const Text('Register'),
                              onPressed: () async {
                                users.add({
                                  "username": _textController.text,
                                  "password": _passwordController.text,
                                });

                                await createUser(_textController.text,
                                    _passwordController.text);
                                setState(() {
                                  register = false;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Text(''),
                            TextButton(
                              child: const Text(
                                '',
                                style: TextStyle(
                                    fontFamily: 'Font1', fontSize: 17),
                              ),
                              onPressed: () {
                                //signup screen
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ]),
          );
  }
}
