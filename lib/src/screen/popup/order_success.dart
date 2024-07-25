import 'package:cammotor_new_version/src/screen/homepage.dart';
import 'package:flutter/material.dart';

Future<void> _dialogSuccess(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Payment Success!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'IDR 1,000,000',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '12-12-2024',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
             Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 200, 
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 80, 70, 72),
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      shadowColor: Colors.grey,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified),
                        Text('ទិញបានជោគជ័យ'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }