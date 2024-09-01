import 'package:cammotor_new_version/src/model/bottom_sheet.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/copy.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/general.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/original.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/repair.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/thailand.dart';
import 'package:cammotor_new_version/src/services/buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TestProductScreen extends StatelessWidget {
  const TestProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 137, 249),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Image.asset(
              "assets/images/logo3.png",
              width: 140,
            ),
      ),
      body: FutureBuilder<List<Student>>(
        future: fetchData(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            final students = snapshot.data!;
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  color: const Color.fromARGB(255, 36, 87, 197),
                  child: const Center(
                      child: Text(
                    'ទំនិញ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                  )),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16.0),
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.4,
                      children: List.generate(students.length, (index) {
                        final student = students[index];
                        return _buildGridItem(
                          context,
                          iconUrl: '${dotenv.env['BASE_URL']}/storage/${student.icons}',
                          label: student.name,
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const OriginalScreen()));
                            } else if (index == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CopyScreen()));
                            } else if (index == 2) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralScreen()));
                            } else if (index == 3) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RepairScreenProduct()));
                            }else if(index == 4){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ThailandScreen()));
                            }
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, {required String iconUrl, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: iconUrl,
                height: 50,
                width: 50,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}