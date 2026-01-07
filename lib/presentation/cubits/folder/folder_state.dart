import 'package:equatable/equatable.dart';
import '../../../domain/entities/folder_entity.dart';

abstract class FolderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FolderLoading extends FolderState {}

class FolderLoaded extends FolderState {
  final List<FolderEntity> folders;
  final Map<int, int> noteCount;

  FolderLoaded(this.folders, this.noteCount);

  @override
  List<Object?> get props => [folders, noteCount];
}

class FolderError extends FolderState {
  final String message;
  FolderError(this.message);

  @override
  List<Object?> get props => [message];
}
