import 'package:cached_network_image/cached_network_image.dart';
import 'package:cammotor_new_version/src/model/category.dart';
import 'package:cammotor_new_version/src/model/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../components/loading.dart';
import '../../model/real_product.dart';
import '../../providers/sub_categ.dart';
import '../../services/category.dart';
import '../../services/real_product.dart';
import '../../services/sub_category.dart';
import 'real_product.dart';

class ProductScreen extends StatefulWidget {
  final int yearID;

  const ProductScreen({Key? key, required this.yearID}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with AutomaticKeepAliveClientMixin {
  late SubCategoryProvider subCategoryProvider;
  SubCategoryService subCategoryService = SubCategoryService();
  List<CategoryModel> displayList = [];
  List<SubCategoryModel> filteredSubCategoryList = [];
  int selectedCategoryIndex = 0;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInitialData(widget.yearID); // Changed to yearID
    });
    subCategoryProvider = Provider.of<SubCategoryProvider>(context, listen: false);

    fetchDataCategoryModel().then((categories) {
      setState(() {
        displayList = categories.where((category) => category.yearID == widget.yearID).toList();
      });
      resetGridView();
    });
  }

  void toggleCategorySelection(int index) {
    setState(() {
      selectedCategoryIndex = index;
      resetGridView();
    });
  }
  void resetGridView() {
  setState(() {
    final int categoryId = displayList[selectedCategoryIndex].id;

    subCategoryService.fetchDataSubCategoryModel(1, 10, categoryId).then((subCategories) {
      setState(() {
        filteredSubCategoryList = subCategories;
      });
    });
  });
}
  void updateSubCategoryList(String value) {
    setState(() {
      filteredSubCategoryList = subCategoryProvider.studentData
        .where((subCategory) =>
            subCategory.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    });
  }
  Future<void> fetchInitialData(int yearID) async {
    final provider = Provider.of<SubCategoryProvider>(context, listen: false);
      try {
        await provider.fetchInitialData(yearID);
      } catch (e) {
        print("Error: $e");
      }
  }

  @override
  Widget build(BuildContext context) {
    subCategoryProvider = Provider.of<SubCategoryProvider>(context);
    CachedNetworkImage(
      //  imageUrl: "http://143.198.217.4:1026/api/storage/",
       imageUrl: '${dotenv.env['BASE_URL']}/storage',
       progressIndicatorBuilder: (context, url, downloadProgress) => 
               CircularProgressIndicator(value: downloadProgress.progress),
       errorWidget: (context, url, error) => const Icon(Icons.error),
    );

    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(BootstrapIcons.basket),
            ),
          )
        ],
      ),
      body: Consumer<SubCategoryProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.01,
              ),
              SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: displayList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          displayList[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: (selectedCategoryIndex == index) ? Colors.blue : Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          height: 2,
                          width: 40, 
                          color: (selectedCategoryIndex == index) ? Colors.blue : Colors.transparent,
                        ),
                      ],
                    )
                  ),
                  onTap: () {
                    toggleCategorySelection(index);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                updateSubCategoryList(value);
              },
              decoration: InputDecoration(
                hintText: 'ស្វែងរកគ្រឿងបន្លាស់',
                filled: true,
                fillColor: const Color.fromARGB(255, 217, 217, 217),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
               Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!provider.isLoading &&
                        scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200.0) {
                      provider.fetchSubCategoryData(
                        provider.currentPage + 1,
                        provider.pageSize,
                        displayList[selectedCategoryIndex].id,
                      );
                      return true;
                    }
                    return false;
                  },
                  child: GridView.builder(
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                      crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
                    ),
                    itemCount: filteredSubCategoryList.length, // Ensure this count is updated
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          int subCategoryId = filteredSubCategoryList[index].id;
                          // Show loading indicator
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CustomLoadingWidget1(),
                              );
                            },
                          );

                          try {
                            // Fetch RealProductModel data using the selected subcategory ID
                            List<RealProductModel> products = await RealProductService().fetchProductData(1, 10, subCategoryId);
                            
                            Navigator.of(context, rootNavigator: true).pop();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RealProduct(subcategoryID: subCategoryId),
                              ),
                            );
                          } catch (error) {
                            Navigator.of(context, rootNavigator: true).pop();
                            print("Error fetching data: $error");
                          }
                        },
                        child: Card(
                    color: const Color.fromARGB(255, 51, 51, 51),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
                      side: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 225, 219, 219),
                      ),
                    ),
                    child: GridTile(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 7 / 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.05),
                                topRight: Radius.circular(MediaQuery.of(context).size.width * 0.05),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: '${dotenv.env['BASE_URL']}/storage/${filteredSubCategoryList[index].image}',
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, downloadProgress) {
                                  return CircularProgressIndicator(value: downloadProgress.progress);
                                },
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Center(
                              child: Text(
                                filteredSubCategoryList[index].name,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 198, 150, 27),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                      );
                    },
                  ),
                ),
              ),
              if(provider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        },
      ),
    );
  }

  void _scrollListener() {
    final provider = Provider.of<SubCategoryProvider>(context, listen: false);
    if (!provider.isLoading &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      provider.fetchSubCategoryData(
        provider.currentPage + 1,
        provider.pageSize,
        displayList[selectedCategoryIndex].id, // Pass category ID
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}


