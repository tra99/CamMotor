import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedItemIndex = 0;

  // Define a list of items for the container.
  List<String> containerItems = ['Item 1', 'Item 2', 'Item 3'];

  // Define a list of corresponding content for the body.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Original Product'),
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        actions: [
              GestureDetector(
                onTap: () {
                  // code here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3.0),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                  ),
                ),
              )
        ]
      ),
      body: Row(
        children: [
          // Container on the left side
          Container(
            width: 200,
            child: ListView.builder(
              itemCount: containerItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(containerItems[index]),
                  onTap: () {
                    // Update the selected item index when tapped.
                    setState(() {
                      selectedItemIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          // Body on the right side
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text("Hello world"),
            ),
          ),
        ],
      ),
    );
  }
}
