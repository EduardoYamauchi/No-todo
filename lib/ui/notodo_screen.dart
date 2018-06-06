import 'package:flutter/material.dart';
import 'package:notodo/models/nodo_item.dart';
import 'package:notodo/utils/database_helper.dart';

class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => _NotoDoScreenState();
}

class _NotoDoScreenState extends State<NotoDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  var db = new DatabaseHelper();
  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  //init state, created on vue
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    NoDoItem noDoItem =
        new NoDoItem(text, new DateTime.now().toIso8601String());
//    print(noDoItem);
    int saveItemId = await db.saveItem(noDoItem);
    print('Item Saved $saveItemId');

    NoDoItem addedItem = await db.getItem(saveItemId);

    //method for update listview after add a new item
    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _itemList.length,
                  itemBuilder: (context, int index) {
                    return new Card(
                      color: Colors.white10,
                      child: new ListTile(
                        title: _itemList[index],
                        onLongPress: () => debugPrint(''),
                        trailing: new Listener(
                          key: new Key(_itemList[index].itemName),
                          child: new Icon(Icons.remove_circle,
                          color: Colors.redAccent),
                          onPointerDown: (pointerEvent) => debugPrint('del'),
                        ),
                      ),
                    );
                  }
              )
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
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
                icon: new Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text('Save')),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel'))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _readNoDoList() async {
    //This is a method for insert data before the screen load
    List items = await db.getItems();
    items.forEach((item) {
//      NoDoItem noDoItem = NoDoItem.map(item);
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
//      print('Db items: ${noDoItem.itemName}');
    });
  }
}
