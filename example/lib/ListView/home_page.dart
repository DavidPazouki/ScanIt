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
  List<Entry> data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScanIt'),
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
                    return Card(
                      child: ListTile(
                        title: Text(item.heading),
                        subtitle: Text(item.text),
                        onTap: () => share(context, item),
                        onLongPress: () => {remove(item)},
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

  share(BuildContext context, Entry alligator) {
    final RenderBox box = context.findRenderObject();

    Share.share("${alligator.heading}:\n${alligator.text}",
        subject: alligator.text,
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
