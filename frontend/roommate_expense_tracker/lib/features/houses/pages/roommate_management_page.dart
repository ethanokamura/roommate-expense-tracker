import 'package:flutter/material.dart';

class RoommateManagementPage extends StatelessWidget {
  const RoommateManagementPage({super.key});

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
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text("Add Roommate"),
            leading: Icon(Icons.person_add),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Add roommate functionality goes here."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Remove Roommate"),
            leading: Icon(Icons.person_remove),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Remove roommate functionality goes here."),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
