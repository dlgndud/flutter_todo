import 'package:flutter/material.dart';
import 'package:flutter_todo/data/database.dart';
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
  final dbHelper = DatabaseHelper.instance;

  List<Todo> todos = [];

  int selectedIndex = 0;

  void getTodayTodo() async {
    todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTodayTodo();
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
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "오늘"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: "기록"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "더보기")
        ],
        currentIndex: selectedIndex,
        onTap: (idx) {
          setState(() {
            selectedIndex = idx;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 등록화면으로 이동
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => TodoWrite(
                  todo: Todo(
                      title: '',
                      color: 0,
                      memo: '',
                      done: 0,
                      category: '',
                      date: Utils.getFormatTime(DateTime.now())))));

          getTodayTodo();
        },
      ),
    );
  }

  Widget getPage() {
    if (selectedIndex == 0) {
      return getMain();
    } else {
      return getHistory();
    }
  }

  Widget getMain() {
    return ListView.builder(
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
                return InkWell(
                  child: TodoCardWidget(todo: item),
                  onTap: () {
                    setState(() {
                      if (item.done == 0) {
                        item.done = 1;
                      } else {
                        item.done = 0;
                      }
                    });
                  },
                  onLongPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => TodoWrite(todo: item)));

                    setState(() {}); // 상태값이 변경되면 호출
                  },
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
                return InkWell(
                  child: TodoCardWidget(todo: item),
                  onTap: () {
                    setState(() {
                      if (item.done == 1) {
                        item.done = 0;
                      } else {
                        item.done = 1;
                      }
                    });
                  },
                  onLongPress: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => TodoWrite(todo: item)));

                    setState(() {});
                  },
                );
              }),
            ),
          );
        }
      },
      itemCount: 4,
    );
  }

  Widget getHistory() {
    return Container();
  }
}

class TodoCardWidget extends StatelessWidget {
  final Todo todo;

  TodoCardWidget({
    Key key,
    this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(todo.color), borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                todo.title,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                todo.done == 0 ? "미완료" : "완료",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Container(
            height: 8,
          ),
          Text(
            todo.memo,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
