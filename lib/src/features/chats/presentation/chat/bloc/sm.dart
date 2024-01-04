import 'dart:io';

import 'package:equatable/equatable.dart';
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
  }) : super(const SMState(0));

  onUploadProgress(double newProgress) {
    progress = newProgress;
    emit(SMState(progress));
  }
}

class SMState extends Equatable {
  final double? progress;

  const SMState(this.progress);

  @override
  List<Object?> get props => [progress!];
}
