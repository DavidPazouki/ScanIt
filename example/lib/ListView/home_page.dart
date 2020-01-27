import 'dart:async';
import 'package:flutter_mobile_vision_example/ListView/model.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ocr.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScanIt'),
        centerTitle: true,

      ),
      body: FutureBuilder<List>(
        future: Services.getEntries(),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int position) {
                    final item = snapshot.data[position];
                    PopupMenuItem(
                      value: item,
                      child: Text("Delete"),
                    );
                    return Card(
                      child: ListTile(
                        title: Text(item.heading),
                        subtitle: Text(item.text),
                        //onTap: () => share(context, item),
                        //onLongPress: () => {remove(item)},
                        trailing: PopupMenuButton(
                          onSelected: _onSelected,
                          icon: Icon(Icons.menu),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: {2, item},
                              child: Text("Share"),
                            ),
                            PopupMenuItem(
                              value: {1, item},
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        child: Icon(Icons.add),
        onPressed: () {
          print("Clicked");
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new MyApp()),
          );
        },
      ),
    );
  }

  share(BuildContext context, Entry entry) {
    final RenderBox box = context.findRenderObject();
    Share.share("${entry.heading}:\n${entry.text}",
        subject: entry.text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  remove(item) async {
    print('remove');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0);
    for (int i = 1; i <= counter; i++) {
      if (prefs.getString('$i text') == item.text) {
        prefs.remove('$i heading');
        prefs.remove('$i text');
        break;
      }
    }
    setState(() {});
  }

  void _onSelected(Set value) {
    if (value.elementAt(0) == 1) {
      remove(value.elementAt(1));
    } else {
      share(context, value.elementAt(1));
    }
  }
}

class Services {
  static Future<List<Entry>> getEntries() async {
    List<Entry> entries = List<Entry>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0);
    for (int i = 1; i <= counter; i++) {
      if (prefs.getString('$i text') != null) {
        entries.add(new Entry(
            heading: prefs.getString('$i heading'),
            text: prefs.getString('$i text')));
      }
    }
    print('Loaded');
    return entries;
  }
}
