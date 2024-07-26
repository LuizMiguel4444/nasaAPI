import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/navBar_controller.dart';
import '../controllers/theme_controller.dart';
import 'image_details_page.dart';

class FavoritePage extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navBarController.currentIndex.value = 1;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "favorites".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? customSwatchSecundary : customSwatch,
          iconTheme: IconThemeData(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          actions: [
            Obx(() => IconButton(
              icon: Icon(
                favoriteController.isGridLayout.value ? Icons.list : Icons.grid_on,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                favoriteController.toggleLayout();
              },
            )),
          ],
        ),
        body: Obx(() {
          if (favoriteController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          var favoriteImages = favoriteController.favoriteImages;
          if (favoriteImages.isEmpty) {
            return Center(child: Text("noFavoritesAdded".tr));
          }
          final locale = Get.locale?.languageCode ?? 'en';
          if (favoriteController.isGridLayout.value) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              padding: EdgeInsets.all(25),
              itemCount: favoriteImages.length,
              itemBuilder: (context, index) {
                final image = favoriteImages[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ImageDetailsPage(image: image));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 12,
                    color: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey[300],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black45,
                          title: Text(image.title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              favoriteController.removeFavorite(image);
                            },
                          ),
                        ),
                        child: Image.network(
                          image.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return ListView.builder(
              itemCount: favoriteImages.length,
              itemBuilder: (context, index) {
                final image = favoriteImages[index];
                final formattedDate = DateFormat.yMMMMd(locale).format(DateTime.parse(image.date));
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 8,
                  color: Theme.of(context).brightness == Brightness.dark ? null : Colors.grey[300],
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: Image.network(
                      image.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                    title: Text(
                      image.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(formattedDate),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        favoriteController.removeFavorite(image);
                      },
                    ),
                    onTap: () {
                      Get.to(() => ImageDetailsPage(image: image));
                    },
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
