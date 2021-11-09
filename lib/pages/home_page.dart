import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todofire_base/custom/todo_card.dart';
import 'package:todofire_base/pages/add_todo.dart';
import 'package:todofire_base/pages/signup_page.dart';
import 'package:todofire_base/pages/view_data.dart';
import 'package:todofire_base/service/auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.png"),
          ),
          SizedBox(width: 15),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authClass.logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => SignUpPage()),
                  (route) => false);
            },
          ),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent.shade700,
                      Colors.amber.shade600,
                      Colors.redAccent.shade700,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            title: Container(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  switch (document["Category"]) {
                    case "Work":
                      iconData = Icons.work_outlined;
                      iconColor = Color(0xFF3625F5);
                      break;
                    case "WorkOut":
                      iconData = Icons.alarm;
                      iconColor = Color(0xff29732f);
                      break;
                    case "Food":
                      iconData = Icons.local_grocery_store;
                      iconColor = Color(0xFFF30A0A);
                      break;
                    case "Design":
                      iconData = Icons.audiotrack;
                      iconColor = Color(0xFFF1C916);
                      break;
                    case "Run":
                      iconData = Icons.run_circle_outlined;
                      iconColor = Color(0xFF35F506);
                      break;
                    default:
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.blue;
                  }
                  selected.add(
                    Select(
                      id: snapshot.data!.docs[index].id,
                      checkValue: false,
                    ),
                  );
                  return InkWell(
                    child: TodoCard(
                      title: document["title"] == null
                          ? "Hey There"
                          : document["title"],
                      check: selected[index].checkValue,
                      iconBgColor: Colors.white,
                      iconColor: iconColor,
                      iconData: iconData,
                      time: "",
                      index: index,
                      onChange: onChange,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ViewData(
                                    document: document,
                                    id: snapshot.data!.docs[index].id,
                                  )));
                    },
                  );
                });
          }),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
