import 'package:cached_network_image/cached_network_image.dart';
import 'package:cammotor_new_version/src/model/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductExpandedWidget extends StatelessWidget {
  final List<SubCategoryModel> filteredSubCategoryList;
  final double screenWidth;

  const ProductExpandedWidget({
    Key? key,
    required this.filteredSubCategoryList,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          mainAxisSpacing: screenWidth * 0.02,
          crossAxisSpacing: screenWidth * 0.01,
        ),
        itemCount: filteredSubCategoryList.length,
        itemBuilder: (context, index) {
          final subCategory = filteredSubCategoryList[index];

          return Card(
            color: const Color.fromARGB(255, 51, 51, 51),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                        topLeft: Radius.circular(screenWidth * 0.05),
                        topRight: Radius.circular(screenWidth * 0.05),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '${dotenv.env['BASE_URL']}/storage/${subCategory.image}',
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
                        subCategory.name,
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
          );
        },
      ),
    );
  }
}