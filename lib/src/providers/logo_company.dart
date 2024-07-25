import 'package:cammotor_new_version/src/model/logo_company.dart';
import 'package:cammotor_new_version/src/services/company_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Clogo extends StatefulWidget {
  const Clogo({super.key});

  @override
  State<Clogo> createState() => _ClogoState();
}

class _ClogoState extends State<Clogo> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder<List<CompanyLogo>>(
        future: fetchDataCompanyLogo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<CompanyLogo> companyLogos = snapshot.data!;
            companyLogos.forEach((companyLogo) {
              print('Icons URL for ${companyLogo.nameCompany}: ${companyLogo.image}');
            });
            return ListView.builder(
              itemCount: companyLogos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Name: ${companyLogos[index].nameCompany}'),
                  subtitle: Text('ID: ${companyLogos[index].id}'),
                  trailing: SizedBox(
                    width: 40,
                    child: Image.network('${dotenv.env['BASE_URL']}/storage/${companyLogos[index].image}'),
                  ),
                  // Add more widgets to display other company logo information as needed
                );
              },
            );
          }
        },
      )
    );
  }
}
