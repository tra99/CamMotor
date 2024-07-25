import 'package:cached_network_image/cached_network_image.dart';
import 'package:cammotor_new_version/src/components/loading.dart';
import 'package:cammotor_new_version/src/providers/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../model/logo_company.dart';
import '../../model/model_bike.dart';
import '../../model/pagination.dart';
import '../../services/category_copy.dart';
import '../../services/year_model.dart';
import '../homepage.dart';
import '../product/productscreen.dart';

class CopyScreen extends StatefulWidget {
  const CopyScreen({Key? key}) : super(key: key);

  @override
  State<CopyScreen> createState() => _CopyScreenState();
}

class _CopyScreenState extends State<CopyScreen> with AutomaticKeepAliveClientMixin {
  int selectedItemIndex = -1;
  CompanyLogo? selectedCompanyLogo; // Store the selected CompanyLogo
  final scrollController = ScrollController();


  @override
  bool get wantKeepAlive => true;

  bool isLoadingMoreData = false; // Add a new flag to track loading more data
  bool hasMoreData = true; // Initialize it to true assuming there's more data initially

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    // Fetch initial data only if it hasn't been fetched before
    if (Provider.of<CopyProvider>(context, listen: false).modelData.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchInitialData();
      });
    }
  }
  Future<void> fetchCopyData(int page, int pageSize) async {
    final provider = Provider.of<CopyProvider>(context, listen: false);

    try {
      await provider.fetchCopyData(page, pageSize);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchInitialData() async {
    final provider = Provider.of<CopyProvider>(context, listen: false);

    try {
      await provider.fetchInitialData();
    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    CachedNetworkImage(
      //  imageUrl: "http://143.198.217.4:1026/api/storage/",
       imageUrl: '${dotenv.env['BASE_URL']}/storage',
       progressIndicatorBuilder: (context, url, downloadProgress) => 
               CircularProgressIndicator(value: downloadProgress.progress),
       errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double backgroundHeight = screenHeight * 0.2;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 53, 53),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        title: Column(
          children: [
            Text(
              'សំភារៈកូពី',
              style: GoogleFonts.coiny(
                color: const Color.fromARGB(255, 75, 74, 74),
                fontSize: 22,
              ),
            ),
            Text(
              'គ្រឿងបន្លាស់',
              style: GoogleFonts.coiny(
                color: const Color.fromARGB(255, 75, 74, 74),
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder<List<CompanyLogo>>(
        future: fetchDataCompanyLogoCopy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<CompanyLogo> companyLogos = snapshot.data!;

            return Column(
              children: [
                Container(
                  height: backgroundHeight,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 245, 160, 31),
                  child: ListView.builder(
                    itemCount: companyLogos.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: selectedItemIndex == index
                                        ? const Color(0xFF706F6F)
                                        : Colors.white,
                                  ),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: SizedBox(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                        image: CachedNetworkImageProvider(
                                          '${dotenv.env['BASE_URL']}/storage/${companyLogos[index].image}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                companyLogos[index].nameCompany,
                                style: GoogleFonts.coiny(
                                  color: const Color.fromARGB(255, 87, 85, 85),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedItemIndex == index) {
                              // If the user taps the selected logo again, unselect it
                              selectedItemIndex = -1;
                              selectedCompanyLogo = null;
                            } else {
                              selectedItemIndex = index;
                              selectedCompanyLogo = companyLogos[index]; // Store the selected CompanyLogo
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                
                Consumer<CopyProvider>(
                  builder: (context, copyProvider, _) {
                    final List<Model> studentData = copyProvider.modelData;

                    final List<Model> filteredCopyData = selectedCompanyLogo != null
                        ? studentData.where((model) => model.companyID == selectedCompanyLogo!.id).toList()
                        : studentData;

                    return Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo is ScrollEndNotification &&
                              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            if (!copyProvider.isLoading) {
                              final nextPage = copyProvider.currentPage + 1;
                              copyProvider.fetchCopyData(nextPage, copyProvider.pageSize);
                            }
                            return true;
                          }
                          return false;
                        },
                        child: Stack(
                          children: [
                            filteredCopyData.isEmpty
                                ? const Center(
                                    // child: Text('No more data'),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      children: filteredCopyData.map((model) {
                                        return GestureDetector(
                                          onTap: () => _showYearDialog(context, model),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                  border: Border.all(
                                                    width: 2.0,
                                                    color: const Color.fromARGB(255, 245, 160, 31),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(30),
                                                  child: Image(
                                                    image: CachedNetworkImageProvider(
                                                      '${dotenv.env['BASE_URL']}/storage/${model.image}',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                model.nameModel,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                    if (copyProvider.isLoading)
                                      const Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 16,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),



              ],
            );
          }
        },
      ),
    );
  }

  void _scrollListener() {
    final provider = Provider.of<CopyProvider>(context, listen: false);

    if (!provider.isLoading &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      provider.fetchCopyData(provider.currentPage + 1, provider.pageSize);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _showYearDialog(BuildContext context, Model selectedModel) async {
    bool dismissed = false;

    try {
      await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation1, animation2) {
          return WillPopScope(
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
                child: FutureBuilder<List<YearModel>>(
                  future: fetchDataYearModel(selectedModel.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomLoadingWidget();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final List<YearModel> yearModels = snapshot.data!;

                      final filteredYearModels = yearModels
                          .where((yearModel) => yearModel.modelId == selectedModel.id)
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredYearModels.length,
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
                            child: GestureDetector(
                              onTap: () {
                                _showYearDialog(context, selectedModel);
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    yearID: filteredYearModels[index].id,
                                  ),
                                ));
                              },
                              child: Semantics(
                                label: 'Year ${filteredYearModels[index].year}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Center(
                                    child: Text(
                                      filteredYearModels[index].year,
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
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error creating dialog: $e');
    }
  }
}
