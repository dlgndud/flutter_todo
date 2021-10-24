import 'package:flutter/material.dart';
import 'package:flutter_todo/data/todo.dart';

class TodoWrite extends StatefulWidget {
  final Todo todo;

  const TodoWrite({Key key, this.todo}) : super(key: key);

  @override
  _TodoWriteState createState() => _TodoWriteState();
}

// 구현부
class _TodoWriteState extends State<TodoWrite> {
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  int colorIdx = 0;
  int categoryIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("등록"),
          actions: [
            TextButton(
                onPressed: () {
                  widget.todo.title = nameController.text;
                  widget.todo.memo = memoController.text;

                  Navigator.of(context).pop(widget.todo);
                },
                child: Text(
                  "저장",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, idx) {
            if (idx == 0) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "제목",
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else if (idx == 1) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: TextField(
                  controller: nameController,
                ),
              );
            } else if (idx == 2) {
              return InkWell(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "색상",
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: Color(widget.todo.color),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  print('색상변경');
                  List<Color> colors = [
                    Color(0xFF88d3f4),
                    Color(0xFFa794fa),
                    Color(0xFFfb8a94)
                  ];

                  widget.todo.color = colors[colorIdx].value;
                  colorIdx++;
                  setState(() {
                    colorIdx = colorIdx % colors.length; // loop
                  });
                },
              );
            } else if (idx == 3) {
              return InkWell(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "카테고리",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        widget.todo.category,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  List<String> category = ["공부", "운동", "게임"];
                  widget.todo.category = category[categoryIdx];
                  categoryIdx++;
                  setState(() {
                    categoryIdx = categoryIdx % category.length;
                  });
                },
              );
            } else if (idx == 4) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "메모",
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: TextField(
                  controller: memoController,
                  maxLines: 10,
                  minLines: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
              );
            }
          },
          itemCount: 6,
        ));
  }
}
