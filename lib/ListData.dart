import 'package:flutter/material.dart';

class ListData extends StatelessWidget {
  List<String> data;
  ListData(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        height: 600,
        child: Expanded(
          child: ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              return Card(
                child: TextButton(
                  child: Text(
                    data[i],
                  ),
                  onPressed: () {
                    Navigator.pop(context, data[i]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}