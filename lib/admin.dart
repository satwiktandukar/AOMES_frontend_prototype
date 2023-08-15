import 'dart:convert';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'welcome.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // actions: <Widget>[
        //   IconButton(onPressed: logout, icon: Icon(Icons.logout))
        // ],
      ),
      body: Add_question(),
    );
  }
}

// class Admin extends StatefulWidget {
//   Admin({Key? key}) : super(key: key);

//   @override
//   State<Admin> createState() => _AdminState();
// }

// class _AdminState extends State<Admin> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("hello world"),
//     );
//   }
// }
var url = 'https://aomeibackend.herokuapp.com';

class Questions {
  dynamic question, answer_1, answer_2, answer_3, answer_4, subject, correct;
  Questions(
      question, answer_1, answer_2, answer_3, answer_4, subject, correct) {
    this.question = question;
    this.answer_1 = answer_1;
    this.answer_2 = answer_2;
    this.answer_4 = answer_4;
    this.answer_3 = answer_3;
  }
}

class Add_question extends StatelessWidget {
  TextEditingController _textController1 = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  TextEditingController _textController3 = TextEditingController();
  TextEditingController _textController4 = TextEditingController();
  TextEditingController _textController5 = TextEditingController();
  TextEditingController _textController6 = TextEditingController();
  TextEditingController _textController7 = TextEditingController();
  TextEditingController _textController8 = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  var _formKey1 = GlobalKey<FormState>();
  var _formKey3 = GlobalKey<FormState>();

  Future createPost(String url, branch) async {
    return post(Uri.parse(url + '/question/post/' + branch), body: null)
        .then((Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return "done";
    });
  }

  Future<Response> post_question(
    String branch,
    String subject,
    String question,
    String option1,
    String option2,
    String option3,
    String option4,
    String correct,
  ) async {
    Map<String, String> body = {
      'question': question,
      'answer_1': option1,
      'answer_2': option2,
      'answer_3': option3,
      'answer_4': option4,
      'correct': correct,
    };

    var resp = await http.post(
      Uri.parse(url + '/question/post/' + branch + '/' + subject),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
      },
      body: json.encode(body),
    );
    return resp;
  }

  Future<Response> delete_question(
    String branch,
    String subject,
    String question,
  ) async {
    var resp = await http.delete(
      Uri.parse(url +
          '/question/delete/' +
          branch +
          '/' +
          subject +
          '?question=' +
          question),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
      },
    );
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "ADD QUESTIONS: ",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.all(25),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController1,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Branch',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController2,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Subject',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController3,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Question',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController4,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Option1',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController5,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Option2',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController6,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Option3',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController7,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Option4',
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: TextField(
              controller: _textController8,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: 'Correct',
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  primary: kblue,

                  // Background color
                ),
                child: const Text(
                  'ADD',
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () {
                  post_question(
                      _textController1.text,
                      _textController2.text,
                      _textController3.text,
                      _textController4.text,
                      _textController5.text,
                      _textController6.text,
                      _textController7.text,
                      _textController8.text);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  primary: kblue,

                  // Background color
                ),
                child: const Text(
                  'DELETE',
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () {
                  delete_question(
                    _textController1.text,
                    _textController2.text,
                    _textController3.text,
                  );
                },
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ],
    );
  }
}
