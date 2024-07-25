import 'package:flutter/material.dart';

class T1 extends StatefulWidget {
  const T1({Key? key}) : super(key: key);

  @override
  _T1State createState() => _T1State();
}

class _T1State extends State<T1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            _display(context);
          },
          height: 50,
          minWidth: 200,
          color: Colors.black,
          child: const Text(
            'Open',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _display(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Column(
          children: [
            ListTile(
              title: Text('Hello'),
              subtitle: Text('ok'),
              trailing: Icon(Icons.delete_forever_outlined),
            ),
            ListTile(
              title: Text('Bonjour'),
              subtitle: Text('ok'),
              trailing: Icon(Icons.delete_forever_outlined),
            ),
            ListTile(
              title: Text('Ni hao'),
              subtitle: Text('ok'),
              trailing: Icon(Icons.delete_forever_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

