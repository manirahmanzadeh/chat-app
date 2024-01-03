import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class SM extends Cubit<SMState> {
  // a sending message
  final File? file;
  double? progress;
  final String text;
  final String? fileType;

  SM({
    required this.text,
    this.file,
    this.progress,
    this.fileType,
  }) : super(const SMState());

  onUploadProgress(double newProgress) {
    progress = newProgress;
  }
}

class SMState {
  const SMState();
}
