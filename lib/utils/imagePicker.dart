// ignore_for_file: unnecessary_getters_setters, file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  final ImagePicker _picker = ImagePicker();
  final StreamController _imageStreamController = StreamController.broadcast();
  Stream get imageStream => _imageStreamController.stream;
  StreamSink get _sink => _imageStreamController.sink;

  File? _pickedFile;

  File? get pickedFile => _pickedFile;

  set pickedFile(File? pickedFile) {
    _pickedFile = pickedFile;
  }

  pick({ImageSource? source}) async {
    await _picker
        .pickImage(source: source ?? ImageSource.gallery)
        .then((XFile? pickedFile) {
      File file = File(pickedFile!.path);
//adding map to stream
      _sink.add({
        "error": "",
        "file": file,
      });
    }).catchError((error) {
      _sink.add({
        "error": error,
        "file": null,
      });
    });
  }

// this widget will listen changes in ui, it is wrapper around Stream builder
  Widget ListenImageChange(
    Widget Function(
      BuildContext context,
      dynamic image,
    )
        ondata,
  ) {
    return StreamBuilder(
      stream: imageStream,
      builder: ((context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          pickedFile = snapshot.data["file"];

          return ondata.call(
            context,
            snapshot.data["file"],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return ondata.call(
            context,
            null,
          );
        }
        return ondata.call(
          context,
          null,
        );
      }),
    );
  }

  dispose() {
    if (!_imageStreamController.isClosed) {
      _imageStreamController.close();
    }
  }
}

enum PickImageStatus { initial, waiting, done, error }
