import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  final Set<int> _selectedIds = {};
  bool _isSelectionMode = false;

  bool get isSelectionMode => _isSelectionMode;
  Set<int> get selectedIds => _selectedIds;

  bool isSelected(int id) => _selectedIds.contains(id);

  void startSelection(int id) {
    _isSelectionMode = true;
    _selectedIds.add(id);
    notifyListeners();
  }

  void toggle(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }

    if (_selectedIds.isEmpty) {
      _isSelectionMode = false;
    }
    notifyListeners();
  }

  void selectAll(List<int> ids) {
    _isSelectionMode = true;
    _selectedIds
      ..clear()
      ..addAll(ids);
    notifyListeners();
  }

  void clear() {
    _selectedIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }
}
