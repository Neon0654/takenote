import 'package:bloc/bloc.dart';
import 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState(selecting: false, selectedIds: {}));

  void startSelection(int id) {
    emit(SelectionState(selecting: true, selectedIds: {id}));
  }

  void toggle(int id) {
    final ids = Set<int>.from(state.selectedIds);

    ids.contains(id) ? ids.remove(id) : ids.add(id);

    emit(
      SelectionState(
        selecting: ids.isNotEmpty, 
        selectedIds: ids,
      ),
    );
  }

  void selectAll(List<int> allIds) {
    emit(SelectionState(selecting: true, selectedIds: allIds.toSet()));
  }

  void clear() {
    emit(SelectionState(selecting: false, selectedIds: {}));
  }
}
