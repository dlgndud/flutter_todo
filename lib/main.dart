import 'package:flutter/material.dart';
import 'package:flutter_todo/data/todo.dart';
import 'package:flutter_todo/data/utils.dart';
import 'package:flutter_todo/todowrite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [
    Todo(
        title: "패스트캠퍼스 강의듣기",
        memo: "플러터 앱개발 강의",
        color: Colors.redAccent.value,
        done: 0,
        category: "공부",
        date: 20211101),
    Todo(
        title: "패스트캠퍼스 강의듣기",
        memo: "VueJS 프런트앤드개발 강의",
        color: Colors.blue.value,
        done: 1,
        category: "공부",
        date: 20211101),
    Todo(
        title: "패스트캠퍼스 강의듣기",
        memo: "TypeScript 프런트앤드개발 강의",
        color: Colors.amber.value,
        done: 1,
        category: "공부",
        date: 20211101)
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // 앱바를 공백으로 하지 않고 사이즈를 0으로 셋팅
        child: AppBar(
          title: Text(widget.title),
        ),
        preferredSize: Size.fromHeight(0),
      ),
      body: ListView.builder(
        // ListView를 빌더를 통해서 4개 생성
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "오늘하루",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ));
          } else if (idx == 1) {
            List<Todo> undone =
                todos.where((element) => element.done == 0).toList();
            return Container(
              child: Column(
                children: List.generate(undone.length, (index) {
                  Todo item = undone[index];
                  if (item.done == 0) {}
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(item.color),
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.done == 0 ? "미완료" : "완료",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          height: 8,
                        ),
                        Text(
                          item.memo,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  );
                }),
              ),
            );
          } else if (idx == 2) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "완료된 항목",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ));
          } else {
            List<Todo> done =
                todos.where((element) => element.done == 1).toList();
            return Container(
              child: Column(
                children: List.generate(done.length, (index) {
                  Todo item = done[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(item.color),
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.done == 0 ? "미완료" : "완료",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          height: 8,
                        ),
                        Text(
                          item.memo,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  );
                }),
              ),
            );
          }
        },
        itemCount: 4,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "오늘"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "더보기")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 등록화면으로 이동
          Todo todo = await Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => TodoWrite(
                  todo: new Todo(
                      title: '',
                      color: 0,
                      memo: '',
                      done: 0,
                      category: '',
                      date: Utils.getFormatTime(DateTime.now())))));
          setState(() {
            todos.add(todo);
          });
        },
      ),
    );
  }
}