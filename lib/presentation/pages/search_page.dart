import 'package:flutter/material.dart';
import '../../data/database/notes_database.dart';
import '../../data/models/note.dart';

enum TimeFilter {
  yesterday,
  last7Days,
  last30Days,
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Note> results = [];
  bool isLoading = false;

TimeFilter? _filter; // null = không lọc


  // 📅 TÍNH NGÀY BẮT ĐẦU
  DateTime _getFromDate() {
  final now = DateTime.now();

  if (_filter == null) {
    return DateTime(2000); // không lọc
  }

  switch (_filter!) {
    case TimeFilter.yesterday:
      return now.subtract(const Duration(days: 1));
    case TimeFilter.last7Days:
      return now.subtract(const Duration(days: 7));
    case TimeFilter.last30Days:
      return now.subtract(const Duration(days: 30));
  }
}


  // 🔍 SEARCH (keyword có thể rỗng)
  Future<void> _search() async {
    setState(() => isLoading = true);

    final keyword = _searchController.text.trim();
    final fromDate = _getFromDate();

    final data = await NotesDatabase.instance
        .searchNotesWithRange(keyword, fromDate);

    setState(() {
      results = data;
      isLoading = false;
    });
  }

  // 🎨 NÚT LỌC
Widget _buildFilterButton(TimeFilter value, String label) {
  final isSelected = _filter == value;

  return OutlinedButton(
    onPressed: () {
      setState(() {
        // 🔥 nếu bấm lại cùng filter → tắt
        if (_filter == value) {
          _filter = null;
        } else {
          _filter = value;
        }
      });
      _search();
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: isSelected ? Colors.pink : Colors.grey,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.pink : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm ghi chú'),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BOX
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _search(),
            ),
          ),

          // 🔽 LỌC
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lọc',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterButton(TimeFilter.yesterday, 'Hôm qua'),
                    _buildFilterButton(TimeFilter.last7Days, '7 ngày'),
                    _buildFilterButton(TimeFilter.last30Days, '30 ngày'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 📄 RESULT LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : results.isEmpty
                    ? const Center(child: Text('Không có kết quả'))
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final note = results[index];
                          return ListTile(
                            title: Text(note.title),
                            subtitle: Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.pop(context, note.id);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
