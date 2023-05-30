import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyFirebaseApp());
}

class MyFirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  //登録用　入力されたメール/パスワード
  String newUserEmail = "";
  String newUserPassword = "";
  //ログイン用
  String loginUserEmail = "";
  String loginUserPassword = "";

  String infoText = ""; //登録、ログインに関する情報を表示

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Firebase練習')),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(children: <Widget>[
              TextFormField(
                //テキスト入力のラベル
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                  decoration: InputDecoration(labelText: "パスワード(6文字以上)"),
                  obscureText: true, //パスワードが見えないようにする
                  onChanged: (String value) {
                    setState(() {
                      newUserPassword = value;
                    });
                  }),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      //メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                              email: newUserEmail, password: newUserPassword);
//登録したユーザー情報
                      final User user = result.user!;
                      setState(() {
                        infoText = "登録OK: ${user.email}";
                      });
                      //登録に失敗した場合
                    } catch (e) {
                      setState(() {
                        infoText = "登録NG : ${e.toString()}";
                      });
                    }
                  },
                  child: Text("ユーザー登録")),
              const SizedBox(height: 8),
              Text(infoText),

//ログイン用
              const SizedBox(height: 32),
              TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      loginUserEmail = value;
                    });
                  }),

              TextFormField(
                  decoration: InputDecoration(labelText: "パスワード"),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      loginUserPassword = value;
                    });
                  }),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.signInWithEmailAndPassword(
                              email: loginUserEmail,
                              password: loginUserPassword);

                      final User user = result.user!;
                      setState(() {
                        infoText = "ログインOK: ${user.email}";
                      });
                      //登録に失敗した場合
                    } catch (e) {
                      setState(() {
                        infoText = "ログインNG : ${e.toString()}";
                      });
                    }
                  },
                  child: Text("ログイン")),
              const SizedBox(height: 8),
              Text(infoText)
            ]),
          ),
        ));
  }
}
