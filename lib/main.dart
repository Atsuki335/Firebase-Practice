import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ;
  runApp(MyFirebaseApp());
}

class MyFirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //デバッグモードの右上のタグ消す
      title: 'Firebase Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity:
              VisualDensity.adaptivePlatformDensity //視覚密度 適応プラットフォーム密度
          ),
      home: MyFirestorePage(),
    );
  }
}

/*class MyAuthPage extends StatefulWidget {
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
}*/

class MyFirestorePage extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<MyFirestorePage> {
  //作成したドキュメント一覧
  List<DocumentSnapshot> documentList = [];
//指定したドキュメントの情報
  String orderDocumentInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
      Container(padding: EdgeInsets.all(50)), //上すぎたから余白入れた
      ElevatedButton(
          child: Text('コレクション＋ドキュメント作成'),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .set({'name': '鈴木', 'age': '40'});
          }),
      ElevatedButton(
          child: Text('サブコレクション＋ドキュメント作成'),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .collection('orders')
                .doc('id_123')
                .set({'price': 600, 'date': '9/13'});
          }),
      ElevatedButton(
          child: Text('ドキュメント一覧取得'),
          onPressed: () async {
            final snapshot =
                await FirebaseFirestore.instance.collection('users').get();
            setState(() {
              documentList = snapshot.docs; //.documentsになっていたがエラー .docsで○
            });
          }),
      Column(
        children: documentList.map((document) {
          return ListTile(
            title: Text('${document['name']}さん'),
            subtitle: Text('${document['age']}歳'),
          );
        }).toList(),
      ),
      ElevatedButton(
          child: Text('ドキュメントを指定して取得'),
          onPressed: () async {
            final document = await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .collection('orders')
                .doc('id_123')
                .get();
            setState(() {
              orderDocumentInfo = '${document['date']} ${document['price']}円';
            });
          }),
      ListTile(title: Text(orderDocumentInfo)),
      ElevatedButton(
          child: Text('ドキュメント更新'),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .update({'age': 41});
          }),
      ElevatedButton(
          child: Text('ドキュメント削除'),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .collection('orders')
                .doc('id_123')
                .delete();
          }),
    ])));
  }
}
