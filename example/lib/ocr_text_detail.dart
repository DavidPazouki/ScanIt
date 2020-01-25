import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class OcrTextDetail extends StatefulWidget {
  final OcrText ocrText;

  OcrTextDetail(this.ocrText);

  @override
  _OcrTextDetailState createState() => new _OcrTextDetailState();
}

class _OcrTextDetailState extends State<OcrTextDetail> {
  @override
  Widget build(BuildContext context) {
    print("ocr_text_detail started");

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Face Details'),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            subtitle: new TextFormField(),
            title: const Text('Heading'),
          ),
          new ListTile(
            subtitle: new TextFormField(
                initialValue: widget.ocrText.value, maxLines: 15),
            title: const Text('Text'),
          ),
          new ListTile(
            subtitle: new Text(widget.ocrText.language),
            title: const Text('Language'),
          ),
          new RaisedButton(
            onPressed: _save(),
            child: new Text('SAVE'),
          )
        ],
      ),
    );
  }

  _save() {
    print('saved');
  }
}
