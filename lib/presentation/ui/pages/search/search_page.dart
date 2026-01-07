import 'package:flutter/material.dart';

import 'widgets/search_app_bar.dart';
import 'widgets/search_body.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: const SearchBody(),
    );
  }
}
