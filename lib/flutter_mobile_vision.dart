import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMobileVision {
  static const MethodChannel _channel =
  const MethodChannel('flutter_mobile_vision');

  static const int CAMERA_BACK = 0;
  static const int CAMERA_FRONT = 1;

  static const Size PREVIEW = const Size(640, 480);

  static Map<int, List<Size>> _previewSizes = {};

  ///
  ///
  ///
  static Future<Map<int, List<Size>>> start() async {
    var value = await _channel.invokeMethod('start');
    value.forEach((k, v) {
      List<Size> list = [];
      v.forEach((map) => list.add(Size.fromMap(map)));
      _previewSizes[k] = list;
    });
    return _previewSizes;
  }

  ///
  ///
  ///
  static List<Size> getPreviewSizes(int facing) {
    if (_previewSizes.containsKey(facing)) {
      return _previewSizes[facing];
    }
    return null;
  }

  ///
  ///
  ///
  static Future<List<OcrText>> read({
    bool flash: false,
    bool autoFocus: true,
    bool multiple: false,
    bool waitTap: false,
    bool showText: true,
    Size preview: PREVIEW,
    int camera: CAMERA_BACK,
    double fps: 2.0,
  }) async {
    Map<String, dynamic> arguments = {
      'flash': flash,
      'autoFocus': autoFocus,
      'multiple': multiple,
      'waitTap': waitTap,
      'showText': showText,
      'previewWidth': preview != null ? preview.width : PREVIEW.width,
      'previewHeight': preview != null ? preview.height : PREVIEW.height,
      'camera': camera,
      'fps': fps,
    };

    final List list = await _channel.invokeMethod('read', arguments);

    return list.map((map) => OcrText.fromMap(map)).toList();
  }
}
///
///
///
class OcrText {
  final String value;
  final String language;
  final int top;
  final int bottom;
  final int left;
  final int right;

  OcrText(
    this.value, {
    this.language: '',
    this.top: -1,
    this.bottom: -1,
    this.left: -1,
    this.right: -1,
  });

  OcrText.fromMap(Map map)
      : value = map['value'],
        language = map['language'],
        top = map['top'],
        bottom = map['bottom'],
        left = map['left'],
        right = map['right'];

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'language': language,
      'top': top,
      'bottom': bottom,
      'left': left,
      'right': right,
    };
  }
}

class Size {
  final int width;
  final int height;

  const Size(this.width, this.height);

  Size.fromMap(Map map)
      : width = map['width'],
        height = map['height'];

  String toString() {
    return '$width x $height';
  }
}
