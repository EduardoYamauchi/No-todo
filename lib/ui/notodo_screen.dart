import 'package:flutter/material.dart';
import 'package:notodo/models/nodo_item.dart';
import 'package:notodo/utils/database_helper.dart';

class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => _NotoDoScreenState();
}

class _NotoDoScreenState extends State<NotoDoScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    NoDoItem noDoItem = new NoDoItem(text, new DateTime.now().toIso8601String());
//    print(noDoItem);
    int saveItemId = await db.saveItem(noDoItem);
    print('Item Saved $saveItemId');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: Column(),


      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add Item',
          backgroundColor: Colors.blueAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Item',
                  hintText: "eg. Don't buy stuff",
                  icon: new Icon(Icons.note_add)
                ),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
    }, child: Text('Save')),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: Text('Cancel'))
      ],
    );
    showDialog(context: context,
    builder: (_) {
      return alert;
    });
  }
}
