import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Utils/constants.dart';
import 'package:flutter_recipe_app/Views/NotificationPage.dart';
import 'package:flutter_recipe_app/Views/view_all_items.dart';
import 'package:flutter_recipe_app/Widget/banner.dart';
import 'package:flutter_recipe_app/Widget/food_items_display.dart';
import 'package:flutter_recipe_app/Widget/my_icon_button.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
  // for category
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("App-Category");
  // for all itesm display
  Query get fileteredRecipes =>
      FirebaseFirestore.instance.collection("Complete-Flutter-App").where(
            'category',
            isEqualTo: category,
          );
  Query get allRecipes =>
      FirebaseFirestore.instance.collection("Complete-Flutter-App");
  Query get selectedRecipes =>
      category == "All" ? allRecipes : fileteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // nó cung cấp cấu trúc cơ bản bên trong màn hình
      backgroundColor: kbackgroundColor,
      body: SafeArea(
        // đảm bảo rằng nội dung không bị tràn vào khu vực không an toàn
        child: SingleChildScrollView(
          //cho phép màn hình của chúng ta có thể cuộn nếu nội dung nhiều hơn chiều cao màn hình
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                  height:
                      10), // sizebox là tạo khoản cách giữa các widget(khoảng cách là 10pixel)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        15), // tạo khoản cách giữa giữa các nội dung .Horizontal là thuộc tính theo chiều nang nên nó khoảng cách trái phải 15 pixel
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    mySearchBar(),
                    // for banner
                    const BannerToExplore(),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical:
                            20, // vertical tạo khoản cách trên dưới 20 pixel
                      ),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // for category
                    selectedCategory(),

                    const SizedBox(
                        height:
                            10), // tạo khoảng các xung quanh nội dung 10 pixel

                    // Quick& easy and Viewall
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick & Easy",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing:
                                0.1, // tạo khoảng cách giữa các chữ 0,1 pixel
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewAllItems(),
                            ),
                          ),
                          child: const Text(
                            "View All",
                            style: TextStyle(
                                fontSize: 15,
                                color: kBannerColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              StreamBuilder(
                // được dùng để hiển thị các món ăn lấy từ FireStore theo thơi gian thực
                stream: selectedRecipes
                    .snapshots(), // đây là stream từ firestore nó lắng nghe và nhận dữ liệu từ selectedRecipes
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // snapshot.hasData dùng để kiểm tra xem có dữ liệu từ stream.
                    final List<DocumentSnapshot>
                        recipes = // khai báo 1 danh sách để lấy dữ liệu từ firestore .Nếu không có dữ liệu thì nó trả về rổng
                        snapshot.data?.docs ?? [];

                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 5,
                          left:
                              15), //tạo khoảng cách trông top là 5pixel và bên trái là 15pixel

                      child: SingleChildScrollView(
                        //cho phép màn hình chúng ta cuộn

                        scrollDirection: Axis
                            .horizontal, //vì có phương thức horizontal nên màn hinh cho phép ta cuộn ngang nhiều item
                        child: Row(
                          children: recipes
                              .map((e) => FoodItemsDisplay(documentSnapshot: e))
                              .toList(),
                        ),
                      ),
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
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      category = streamSnapshot.data!.docs[index]['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          category == streamSnapshot.data!.docs[index]['name']
                              ? kprimaryColor
                              : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]['name'],
                      style: TextStyle(
                        color:
                            category == streamSnapshot.data!.docs[index]['name']
                                ? Colors.white
                                : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // it means if snapshot has date then show the date otherwise show the progress bar
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 22), // tạo khoảng cách trên dưới vơi 22pixel
      child: TextField(
        // dùng để người dùng nhập vào đoạn text
        decoration: InputDecoration(
          // decoration thuộc tính này định dạng cho TextFiel thông qua InputDecoration .
          filled:
              true, // Đặt nền của thanh tìm kiếm thành màu được chỉ định bởi fillColor.
          prefixIcon: const Icon(Iconsax
              .search_normal), //prefixIcon dùng để thêm biểu tượng Icon nằm bên trái quả textfiel
          fillColor: Colors.white,
          border: InputBorder
              .none, // thuộc tính này giúp bỏ viền mặc định của Textfield
          hintText: "Search any recipes",
          hintStyle: const TextStyle(
            // định dạng màu cho văn bản trong texlFiel khi nhập vào
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              //enabledBorder: Kiểu viền khi TextField không được chọn.
              borderRadius: BorderRadius.circular(
                  15), //Bo tròn các góc của viền với bán kính 10 pixel.
              borderSide: BorderSide
                  .none), //Không hiển thị đường viền thực tế, chỉ có đường bo góc.
          focusedBorder: OutlineInputBorder(
              // Kiểu viền khi TextField đang được chọn (người dùng đang nhập liệu).
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Row headerParts() {
    return Row(
      children: [
        const Text(
          "What are you\ncooking today?",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        const Spacer(),
        MyIconButton(
          icon: Iconsax.notification,
          pressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationPage())),
        ),
      ],
    );
  }
}
