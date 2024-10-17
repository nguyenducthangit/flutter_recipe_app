import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Utils/constants.dart';
import 'package:flutter_recipe_app/Views/celendar_screen.dart';
import 'package:flutter_recipe_app/Views/favorite_screen.dart';
import 'package:flutter_recipe_app/Views/my_app_home_screen.dart';
import 'package:flutter_recipe_app/Views/setting_screen.dart';
import 'package:iconsax/iconsax.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int selectedIndex = 0; // Biến để theo dõi chỉ số của tab được chọn
  late final List<Widget> page; // Danh sách các widget màn hình

  @override
  void initState() {
    page = [
      const MyAppHomeScreen(),
      const FavoriteScreen(),
      const CelendarScreen(),
      const SettingScreen(),
      // navBarPage(Iconsax.calendar5),
      // navBarPage(Iconsax.setting_21),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0, // Loại bỏ đổ bóng
        iconSize: 28, // Kích thước icon
        currentIndex: selectedIndex, // Vị trí tab đang được chọn
        selectedItemColor: kprimaryColor, // Màu sắc của tab được chọn
        unselectedItemColor: Colors.grey, // Màu sắc của tab không được chọn
        type: BottomNavigationBarType.fixed, // Kiểu điều hướng cố định
        selectedLabelStyle: const TextStyle(
          color: kprimaryColor,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onTap: (value) {
          setState(() {
            selectedIndex = value; // Thay đổi chỉ số tab khi người dùng nhấn
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 0
                  ? Iconsax.home5
                  : Iconsax.home_1, // Icon thay đổi dựa trên tab được chọn
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 1 ? Iconsax.heart5 : Iconsax.heart,
            ),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 2 ? Iconsax.calendar5 : Iconsax.calendar,
            ),
            label: "Meal Plan",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              selectedIndex == 3 ? Iconsax.setting_21 : Iconsax.setting_2,
            ),
            label: "Setting",
          ),
        ],
      ),
      body:
          page[selectedIndex], // Hiển thị màn hình tương ứng với tab được chọn
    );
  }

  // Hàm để tạo trang với icon tương ứng
  navBarPage(iconName) {
    return Center(
      child: Icon(
        iconName,
        size: 100,
        color: kprimaryColor,
      ),
    );
  }
}
