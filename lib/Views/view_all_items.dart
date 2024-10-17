import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Utils/constants.dart';
import 'package:flutter_recipe_app/Views/NotificationPage.dart';
import 'package:flutter_recipe_app/Widget/food_items_display.dart';
import 'package:flutter_recipe_app/Widget/my_icon_button.dart';
import 'package:iconsax/iconsax.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp =
      FirebaseFirestore.instance.collection("Complete-Flutter-App");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor:
            kbackgroundColor, // Đặt màu nền của AppBar theo giá trị kbackgroundColor.
        automaticallyImplyLeading:
            false, // Tắt chức năng tự động thêm nút "back" của AppBar.
        elevation: 0, // Xóa bóng đổ (shadow) dưới AppBar, làm nó phẳng.
        actions: [
          const SizedBox(
              width: 15), // Thêm khoảng trống rộng 15 đơn vị ở bên trái AppBar.

          MyIconButton(
            icon: Icons
                .arrow_back_ios_new, // Tạo một nút icon có biểu tượng "mũi tên quay lại".
            pressed: () {
              Navigator.pop(
                  context); // Khi nhấn vào, quay trở lại trang trước (thoát khỏi trang hiện tại).
            },
          ),

          const Spacer(), // Tạo khoảng cách giữa các phần tử trước và sau.

          const Text(
            "Quick & Easy", // Hiển thị tiêu đề "Quick & Easy" giữa AppBar.
            style: TextStyle(
              fontSize: 20, // Đặt cỡ chữ là 20.
              fontWeight: FontWeight.bold, // Đặt kiểu chữ đậm.
            ),
          ),

          const Spacer(), // Tạo khoảng cách giữa tiêu đề và các phần tử sau.

          MyIconButton(
            icon: Iconsax
                .notification, // Tạo một nút icon có biểu tượng thông báo (notification).
            pressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
            }, // Hành động khi nhấn vào (hiện tại chưa được định nghĩa).
          ),

          const SizedBox(
              width: 15), // Thêm khoảng trống rộng 15 đơn vị ở bên phải AppBar.
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: completeApp.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Column(
                        children: [
                          FoodItemsDisplay(documentSnapshot: documentSnapshot),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.star1,
                                color: Colors.amberAccent,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                documentSnapshot['rate'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("/5"),
                              const SizedBox(width: 5),
                              Text(
                                "${documentSnapshot['reviews'.toString()]} Reviews",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                // it means if snapshot has date then show the date otherwise show the progress bar
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
