import 'package:flutter/material.dart';

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('showDialog Sample')),
      body: Center(
        child: GestureDetector(
          onTap: () => _dialogBuilder(context),
          child: const Text('Open Dialog'),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    List<String> year = [
      "2015",
      "2016",
      "2018",
      "2020",
      "2021",
      "2022",
      "2023",
    ];

    bool dismissed = false;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside the dialog
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation1, animation2) {
        return WillPopScope(
          // Handle Android's back button
          onWillPop: () async {
            dismissed = true;
            Navigator.of(context).pop();
            return false;
          },
          child: Center(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.35,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 31, 31, 31),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: year.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(18),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        width: 2.0,
                        color: Colors.orange,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Center(
                        child: Text(
                          year[index],
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
