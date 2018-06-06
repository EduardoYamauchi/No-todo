import 'package:flutter/material.dart';
import 'package:notodo/models/nodo_item.dart';
import 'package:notodo/utils/database_helper.dart';
import 'package:notodo/utils/date_formatter.dart';

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
                        onLongPress: () => _updateItem(_itemList[index], index),
                        trailing: new Listener(
                          key: new Key(_itemList[index].itemName),
                          child: new Icon(Icons.remove_circle,
                          color: Colors.redAccent),
                          onPointerDown: (pointerEvent) => _deleteNoDo( _itemList[index].id, index),
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
                hintText: "Exemple: Don't buy stuff",
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

  _deleteNoDo(int id, int index) async {
    debugPrint('Delete Item!');

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(NoDoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text('Update Item'),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,

                decoration:  new InputDecoration(
                  labelText: 'Item',
                  hintText: "Example: Don't buy styff",
                  icon: new Icon(Icons.update)),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(onPressed: () async {
          NoDoItem newItemUpdated = NoDoItem.fromMap(
              {'itemName': _textEditingController.text,
                'dateCreated': dateFormatted(),
                'id': item.id
              });
          _textEditingController.clear();
          _handleSubmittedUpdate(index, item); //this method call the redraw screen
          await db.updateItem(newItemUpdated); //updating the item
          setState(() {
            _readNoDoList();//redrawing the screen with all the items saved in the database
          });
          Navigator.pop(context);
        },
        child: new Text('Update')),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: new Text('Cancel'))
      ],
    );
    showDialog(context: context, builder: (_){
      return alert;
    });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }
}
