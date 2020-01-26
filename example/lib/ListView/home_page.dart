import 'package:flutter_mobile_vision_example/ListView/model.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../ocr.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Alligator> alligators = [
    Alligator(
        name: "Crunchy", description: "A fierce Alligator with many teeth."),
    Alligator(name: "Munchy", description: "Has a big belly, eats a lot."),
    Alligator(
        name: "Grunchy", description: "Scaly Alligator that looks menacing."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My favourite Alligators"),
      ),
      body: Column(
          children: alligators
              .map((Alligator alligator) => Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            title: Text(alligator.name),
                            subtitle: Text(alligator.description),
                            onTap: () => share(context, alligator),
                            onLongPress: () {
                              print("Hahahaha");
                              alligators.remove(
                                  alligator.description); //maybe causes problem
                            })
                      ],
                    ),
                  ))
              .toList()),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        backgroundColor: Colors.pinkAccent,
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

  share(BuildContext context, Alligator alligator) {
    final RenderBox box = context.findRenderObject();

    Share.share("${alligator.name} - ${alligator.description}",
        subject: alligator.description,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
