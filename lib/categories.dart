import 'package:flutter/material.dart';

import 'main.dart';

class Application extends StatefulWidget {
  Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}


class _ApplicationState extends State<Application> {
  
dynamic register = false;
dynamic _incorrect = "";
var score = 0;
TextEditingController _textController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _passwordController1 = TextEditingController();

var users = [
  {"username": "satwik", "password": "cuduu"},
  {"username": "rosie", "password": "love"},
  {"username": "", "password": ""}
];
var logged_in = false;
var admin = false;

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  Future<int> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
    return _counter;
  }

  //Incrementing counter after click
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  var url = 'http://localhost:8000';
  Future createUser(String phone, String password) {
    return get(
        Uri.parse(url + "/create?phone=" + phone + "&password=" + password));
  }

  void login(phone, password) async {
    var response = await get(
        Uri.parse(url + "/login?phone=" + phone + "&password=" + password));
    jsonBody = json.decode(response.body);
    // print(jsonBody['info']);

    if ((jsonBody['info'] as String) == 'logged_in') {
      setState(() {
        _incrementCounter();

        logged_in = true;
      });
    } else {
      logged_in = false;
      setState(() {
        _incorrect = "Invalid Credentials";
      });
    }
  }

  var i = 0;
  dynamic question_length = 0;

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

  var topic_picked = false;
  void reset() {
    setState(() {
      topic_picked = false;
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
  List<myModel> questions = [];
  // questions.clear();
  var jsonBody;
  gets(branch) async {
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

  void MBBS() async {
    questions.clear();
    // print(questions);

    question = await gets('MBBS');
    print(question.length);
    setState(() {
      question_length = question.length - 1;
      print(question_length);
      topic_picked = true;
      i = 0;
    });
    // print(question );
  }

  void Nursing() async {
    questions.clear();

    question = await gets('Nursing');
    question_length = 0;

    setState(() {
      question_length = question.length - 1;

      topic_picked = true;
      i = 0;
    });
  }

  void BMLT() async {
    questions.clear();

    question = await gets('BMLT');

    setState(() {
      question_length = question.length - 1;

      topic_picked = true;
      i = 0;
    });
  }

  void ag() async {
    questions.clear();

    question = await gets('Agriculture');

    setState(() {
      question_length = questions.length - 1;

      topic_picked = true;
      i = 0;
    });
  }

  void logout() {
    setState(() {
      logged_in = false;
    });
  }

  void onBackPressed() {}

  @override
  Widget build(BuildContext context) {
    return (logged_in == true && admin == false)
            ?  Scaffold(
                  // drawer: Drawer(),
                  appBar: AppBar(
                    automaticallyImplyLeading: true,
                    //`true` if you want Flutter to automatically add Back Button when needed,
                    //or `false` if you want to force your own back button every where

                    backgroundColor: kblue,
                    centerTitle: true,
                    title: Text(
                      "Smart Education Academy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
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
                                  "Categories: ",
                                  style: TextStyle(
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
                              //         style: TextStyle(fontSize: 20),
                              //       ),
                              //       onPressed: MBBS,
                              //     ),
                              //   ),
                              // ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Material(
                                          // color: kblue,
                                          elevation: 8,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: InkWell(
                                            splashColor: kblue,
                                            onTap: ag,
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
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: InkWell(
                                            splashColor: Color.fromARGB(
                                                255, 232, 245, 233),
                                            onTap: MBBS,
                                            child: Column(
                                              children: [
                                                Ink.image(
                                                  image: AssetImage(
                                                      'assets/images/doc.png'),
                                                  height: 180,
                                                  width: 180,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "MBBS/BDS",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Material(
                                          // color: kblue,
                                          elevation: 8,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: InkWell(
                                            splashColor: kblue,
                                            onTap: BMLT,
                                            child: Column(
                                              children: [
                                                Ink.image(
                                                  image: AssetImage(
                                                      'assets/images/labs.png'),
                                                  height: 180,
                                                  width: 180,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "BMLT",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: InkWell(
                                            splashColor: kblue,
                                            onTap: Nursing,
                                            child: Column(
                                              children: [
                                                Ink.image(
                                                  image: AssetImage(
                                                      'assets/images/nursing.png'),
                                                  height: 180,
                                                  width: 180,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Nursing",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                              //         'Nursing',
                              //         style: TextStyle(fontSize: 20),
                              //       ),
                              //       onPressed: Nursing,
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
                              //         style: TextStyle(fontSize: 20),
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
                              //         style: TextStyle(fontSize: 20),
                              //       ),
                              //       onPressed: ag,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      : Scaffold(
                          body: i < (question.length - 1)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Question(questions[i].question),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ButtonTheme(
                                          height: 60,
                                          minWidth: double.infinity,
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              color: kblue,
                                              child: Text(
                                                questions[i].answer1,
                                                style: TextStyle(
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
                                                      BorderRadius.circular(
                                                          10)),
                                              color: kblue,
                                              child: Text(
                                                questions[i].answer2,
                                                style: TextStyle(
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
                                                      BorderRadius.circular(
                                                          10)),
                                              color: kblue,
                                              child: Text(
                                                questions[i].answer3,
                                                style: TextStyle(
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
                                                      BorderRadius.circular(
                                                          10)),
                                              color: kblue,
                                              child: Text(
                                                questions[i].answer4,
                                                style: TextStyle(
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
                                            child: Text(
                                              "GO BACK",
                                              style: TextStyle(
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
                                )),
                
              )
            : Scaffold(
                // appBar: AppBar(
                //   automaticallyImplyLeading: true,
                //   //`true` if you want Flutter to automatically add Back Button when needed,
                //   //or `false` if you want to force your own back button every where

                //   backgroundColor: kblue,
                //   title: Text(
                //     "Smart Education",
                //     style: TextStyle(
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
                                  'Smart Education',
                                  style: TextStyle(
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
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                    ),
                                    primary: kblue,

                                    // Background color
                                  ),
                                  child: const Text('Login'),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/admin');
                                    // login(_textController.text,
                                    //     _passwordController.text);
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
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      register = true;
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                    ),
                                    primary: kblue,

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
                                    style: TextStyle(fontSize: 17),
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