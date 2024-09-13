import 'package:klontong_store/models/menu_model.dart';

class MenuRepository {
  List<MenuItem> getMenuItems() {
    return [
      MenuItem(
        id: '66e430f32f8ae1eeb401e3a7',
        label: 'Clothes',
        imagePath: 'assets/icon/ic_Clothes.png',
      ),
      MenuItem(
        id: '66e2da063bd4f8bad0908cf3',
        label: 'Snacks',
        imagePath: 'assets/icon/ic_Food.png',
      ),
      MenuItem(
        id: "66e2d97b97ba9e9debc0f448",
        label: 'Breakfast',
        imagePath: 'assets/icon/ic_restaurant.png',
      ),
      MenuItem(
        id: "66e2cf68435512f2a907085a",
        label: 'Lunch',
        imagePath: 'assets/icon/ic_noodle.png',
      ),
      MenuItem(
        id: "66e16b270794e49b479ac842",
        label: 'Dinner',
        imagePath: 'assets/icon/ic_pizza.png',
      ),
      MenuItem(
        id: "66e16b1e0794e49b479ac83e",
        label: 'Fruits',
        imagePath: 'assets/icon/ic_fruit.png',
      ),
      MenuItem(
        id: "66e16b0e0794e49b479ac83a",
        label: 'Drinks',
        imagePath: 'assets/icon/ic_drink.png',
      ),
      MenuItem(
        id: "66e16afd0794e49b479ac835",
        label: 'Coffee',
        imagePath: 'assets/icon/ic_coffe.png',
      ),
      MenuItem(
        id: "66e16af40794e49b479ac831",
        label: 'Desserts',
        imagePath: 'assets/icon/ic_icecream.png',
      ),
      MenuItem(
        id: "66e16ae70794e49b479ac82d",
        label: 'Computer',
        imagePath: 'assets/icon/ic_computer.png',
      ),
      MenuItem(
        id: "66e16ad70794e49b479ac829",
        label: 'Stationery',
        imagePath: 'assets/icon/ic_book.png',
      ),
    ];
  }
}
