import 'package:flutter/material.dart';

class RoommateManagementPage extends StatelessWidget {
  const RoommateManagementPage({
    super.key
  });

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Roommate Management"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text("to be filled"),
      ),
    );
  }
}